//===- PassCrashRecovery.cpp - Pass Crash Recovery Implementation ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/FileUtilities.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/Support/CrashRecoveryContext.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/Mutex.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/Threading.h"
#include "llvm/Support/ToolOutputFile.h"

using namespace mlir;
using namespace mlir::detail;

//===----------------------------------------------------------------------===//
// RecoveryReproducerContext
//===----------------------------------------------------------------------===//

namespace mlir {
namespace detail {
/// This class contains all of the context for generating a recovery reproducer.
/// Each recovery context is registered globally to allow for generating
/// reproducers when a signal is raised, such as a segfault.
struct RecoveryReproducerContext {
  RecoveryReproducerContext(std::string passPipelineStr, Operation *op,
                            ReproducerStreamFactory &streamFactory,
                            bool verifyPasses);
  ~RecoveryReproducerContext();

  /// Generate a reproducer with the current context.
  void generate(std::string &description);

  /// Disable this reproducer context. This prevents the context from generating
  /// a reproducer in the result of a crash.
  void disable();

  /// Enable a previously disabled reproducer context.
  void enable();

private:
  /// This function is invoked in the event of a crash.
  static void crashHandler(void *);

  /// Register a signal handler to run in the event of a crash.
  static void registerSignalHandler();

  /// The textual description of the currently executing pipeline.
  std::string pipelineElements;

  /// The MLIR operation representing the IR before the crash.
  Operation *preCrashOperation;

  /// The factory for the reproducer output stream to use when generating the
  /// reproducer.
  ReproducerStreamFactory &streamFactory;

  /// Various pass manager and context flags.
  bool disableThreads;
  bool verifyPasses;

  /// The current set of active reproducer contexts. This is used in the event
  /// of a crash. This is not thread_local as the pass manager may produce any
  /// number of child threads. This uses a set to allow for multiple MLIR pass
  /// managers to be running at the same time.
  static llvm::ManagedStatic<llvm::sys::SmartMutex<true>> reproducerMutex;
  static llvm::ManagedStatic<
      llvm::SmallSetVector<RecoveryReproducerContext *, 1>>
      reproducerSet;
};
} // namespace detail
} // namespace mlir

llvm::ManagedStatic<llvm::sys::SmartMutex<true>>
    RecoveryReproducerContext::reproducerMutex;
llvm::ManagedStatic<llvm::SmallSetVector<RecoveryReproducerContext *, 1>>
    RecoveryReproducerContext::reproducerSet;

RecoveryReproducerContext::RecoveryReproducerContext(
    std::string passPipelineStr, Operation *op,
    ReproducerStreamFactory &streamFactory, bool verifyPasses)
    : pipelineElements(std::move(passPipelineStr)),
      preCrashOperation(op->clone()), streamFactory(streamFactory),
      disableThreads(!op->getContext()->isMultithreadingEnabled()),
      verifyPasses(verifyPasses) {
  enable();
}

RecoveryReproducerContext::~RecoveryReproducerContext() {
  // Erase the cloned preCrash IR that we cached.
  preCrashOperation->erase();
  disable();
}

static void appendReproducer(std::string &description, Operation *op,
                             const ReproducerStreamFactory &factory,
                             const std::string &pipelineElements,
                             bool disableThreads, bool verifyPasses) {
  llvm::raw_string_ostream descOS(description);

  // Try to create a new output stream for this crash reproducer.
  std::string error;
  std::unique_ptr<ReproducerStream> stream = factory(error);
  if (!stream) {
    descOS << "failed to create output stream: " << error;
    return;
  }
  descOS << "reproducer generated at `" << stream->description() << "`";

  std::string pipeline =
      (op->getName().getStringRef() + "(" + pipelineElements + ")").str();
  AsmState state(op);
  state.attachResourcePrinter(
      "mlir_reproducer", [&](Operation *op, AsmResourceBuilder &builder) {
        builder.buildString("pipeline", pipeline);
        builder.buildBool("disable_threading", disableThreads);
        builder.buildBool("verify_each", verifyPasses);
      });

  // Output the .mlir module.
  op->print(stream->os(), state);
}

void RecoveryReproducerContext::generate(std::string &description) {
  appendReproducer(description, preCrashOperation, streamFactory,
                   pipelineElements, disableThreads, verifyPasses);
}

void RecoveryReproducerContext::disable() {
  llvm::sys::SmartScopedLock<true> lock(*reproducerMutex);
  reproducerSet->remove(this);
  if (reproducerSet->empty())
    llvm::CrashRecoveryContext::Disable();
}

void RecoveryReproducerContext::enable() {
  llvm::sys::SmartScopedLock<true> lock(*reproducerMutex);
  if (reproducerSet->empty())
    llvm::CrashRecoveryContext::Enable();
  registerSignalHandler();
  reproducerSet->insert(this);
}

void RecoveryReproducerContext::crashHandler(void *) {
  // Walk the current stack of contexts and generate a reproducer for each one.
  // We can't know for certain which one was the cause, so we need to generate
  // a reproducer for all of them.
  for (RecoveryReproducerContext *context : *reproducerSet) {
    std::string description;
    context->generate(description);

    // Emit an error using information only available within the context.
    emitError(context->preCrashOperation->getLoc())
        << "A signal was caught while processing the MLIR module:"
        << description << "; marking pass as failed";
  }
}

void RecoveryReproducerContext::registerSignalHandler() {
  // Ensure that the handler is only registered once.
  static bool registered =
      (llvm::sys::AddSignalHandler(crashHandler, nullptr), false);
  (void)registered;
}

//===----------------------------------------------------------------------===//
// PassCrashReproducerGenerator
//===----------------------------------------------------------------------===//

struct PassCrashReproducerGenerator::Impl {
  Impl(ReproducerStreamFactory &streamFactory, bool localReproducer)
      : streamFactory(streamFactory), localReproducer(localReproducer) {}

  /// The factory to use when generating a crash reproducer.
  ReproducerStreamFactory streamFactory;

  /// Flag indicating if reproducer generation should be localized to the
  /// failing pass.
  bool localReproducer = false;

  /// A record of all of the currently active reproducer contexts.
  SmallVector<std::unique_ptr<RecoveryReproducerContext>> activeContexts;

  /// The set of all currently running passes. Note: This is not populated when
  /// `localReproducer` is true, as each pass will get its own recovery context.
  SetVector<std::pair<Pass *, Operation *>> runningPasses;

  /// Various pass manager flags that get emitted when generating a reproducer.
  bool pmFlagVerifyPasses = false;
};

PassCrashReproducerGenerator::PassCrashReproducerGenerator(
    ReproducerStreamFactory &streamFactory, bool localReproducer)
    : impl(std::make_unique<Impl>(streamFactory, localReproducer)) {}
PassCrashReproducerGenerator::~PassCrashReproducerGenerator() = default;

void PassCrashReproducerGenerator::initialize(
    iterator_range<PassManager::pass_iterator> passes, Operation *op,
    bool pmFlagVerifyPasses) {
  assert((!impl->localReproducer ||
          !op->getContext()->isMultithreadingEnabled()) &&
         "expected multi-threading to be disabled when generating a local "
         "reproducer");

  llvm::CrashRecoveryContext::Enable();
  impl->pmFlagVerifyPasses = pmFlagVerifyPasses;

  // If we aren't generating a local reproducer, prepare a reproducer for the
  // given top-level operation.
  if (!impl->localReproducer)
    prepareReproducerFor(passes, op);
}

static void
formatPassOpReproducerMessage(Diagnostic &os,
                              std::pair<Pass *, Operation *> passOpPair) {
  os << "`" << passOpPair.first->getName() << "` on "
     << "'" << passOpPair.second->getName() << "' operation";
  if (SymbolOpInterface symbol = dyn_cast<SymbolOpInterface>(passOpPair.second))
    os << ": @" << symbol.getName();
}

void PassCrashReproducerGenerator::finalize(Operation *rootOp,
                                            LogicalResult executionResult) {
  // Don't generate a reproducer if we have no active contexts.
  if (impl->activeContexts.empty())
    return;

  // If the pass manager execution succeeded, we don't generate any reproducers.
  if (succeeded(executionResult))
    return impl->activeContexts.clear();

  InFlightDiagnostic diag = emitError(rootOp->getLoc())
                            << "Failures have been detected while "
                               "processing an MLIR pass pipeline";

  // If we are generating a global reproducer, we include all of the running
  // passes in the error message for the only active context.
  if (!impl->localReproducer) {
    assert(impl->activeContexts.size() == 1 && "expected one active context");

    // Generate the reproducer.
    std::string description;
    impl->activeContexts.front()->generate(description);

    // Emit an error to the user.
    Diagnostic &note = diag.attachNote() << "Pipeline failed while executing [";
    llvm::interleaveComma(impl->runningPasses, note,
                          [&](const std::pair<Pass *, Operation *> &value) {
                            formatPassOpReproducerMessage(note, value);
                          });
    note << "]: " << description;
    impl->runningPasses.clear();
    impl->activeContexts.clear();
    return;
  }

  // If we were generating a local reproducer, we generate a reproducer for the
  // most recently executing pass using the matching entry from  `runningPasses`
  // to generate a localized diagnostic message.
  assert(impl->activeContexts.size() == impl->runningPasses.size() &&
         "expected running passes to match active contexts");

  // Generate the reproducer.
  RecoveryReproducerContext &reproducerContext = *impl->activeContexts.back();
  std::string description;
  reproducerContext.generate(description);

  // Emit an error to the user.
  Diagnostic &note = diag.attachNote() << "Pipeline failed while executing ";
  formatPassOpReproducerMessage(note, impl->runningPasses.back());
  note << ": " << description;

  impl->activeContexts.clear();
  impl->runningPasses.clear();
}

void PassCrashReproducerGenerator::prepareReproducerFor(Pass *pass,
                                                        Operation *op) {
  // If not tracking local reproducers, we simply remember that this pass is
  // running.
  impl->runningPasses.insert(std::make_pair(pass, op));
  if (!impl->localReproducer)
    return;

  // Disable the current pass recovery context, if there is one. This may happen
  // in the case of dynamic pass pipelines.
  if (!impl->activeContexts.empty())
    impl->activeContexts.back()->disable();

  // Collect all of the parent scopes of this operation.
  SmallVector<OperationName> scopes;
  while (Operation *parentOp = op->getParentOp()) {
    scopes.push_back(op->getName());
    op = parentOp;
  }

  // Emit a pass pipeline string for the current pass running on the current
  // operation type.
  std::string passStr;
  llvm::raw_string_ostream passOS(passStr);
  for (OperationName scope : llvm::reverse(scopes))
    passOS << scope << "(";
  pass->printAsTextualPipeline(passOS);
  for (unsigned i = 0, e = scopes.size(); i < e; ++i)
    passOS << ")";

  impl->activeContexts.push_back(std::make_unique<RecoveryReproducerContext>(
      passStr, op, impl->streamFactory, impl->pmFlagVerifyPasses));
}
void PassCrashReproducerGenerator::prepareReproducerFor(
    iterator_range<PassManager::pass_iterator> passes, Operation *op) {
  std::string passStr;
  llvm::raw_string_ostream passOS(passStr);
  llvm::interleaveComma(
      passes, passOS, [&](Pass &pass) { pass.printAsTextualPipeline(passOS); });

  impl->activeContexts.push_back(std::make_unique<RecoveryReproducerContext>(
      passStr, op, impl->streamFactory, impl->pmFlagVerifyPasses));
}

void PassCrashReproducerGenerator::removeLastReproducerFor(Pass *pass,
                                                           Operation *op) {
  // We only pop the active context if we are tracking local reproducers.
  impl->runningPasses.remove(std::make_pair(pass, op));
  if (impl->localReproducer) {
    impl->activeContexts.pop_back();

    // Re-enable the previous pass recovery context, if there was one. This may
    // happen in the case of dynamic pass pipelines.
    if (!impl->activeContexts.empty())
      impl->activeContexts.back()->enable();
  }
}

//===----------------------------------------------------------------------===//
// CrashReproducerInstrumentation
//===----------------------------------------------------------------------===//

namespace {
struct CrashReproducerInstrumentation : public PassInstrumentation {
  CrashReproducerInstrumentation(PassCrashReproducerGenerator &generator)
      : generator(generator) {}
  ~CrashReproducerInstrumentation() override = default;

  void runBeforePass(Pass *pass, Operation *op) override {
    if (!isa<OpToOpPassAdaptor>(pass))
      generator.prepareReproducerFor(pass, op);
  }

  void runAfterPass(Pass *pass, Operation *op) override {
    if (!isa<OpToOpPassAdaptor>(pass))
      generator.removeLastReproducerFor(pass, op);
  }

  void runAfterPassFailed(Pass *pass, Operation *op) override {
    // Only generate one reproducer per crash reproducer instrumentation.
    if (alreadyFailed)
      return;

    alreadyFailed = true;
    generator.finalize(op, /*executionResult=*/failure());
  }

private:
  /// The generator used to create crash reproducers.
  PassCrashReproducerGenerator &generator;
  bool alreadyFailed = false;
};
} // namespace

//===----------------------------------------------------------------------===//
// FileReproducerStream
//===----------------------------------------------------------------------===//

namespace {
/// This class represents a default instance of mlir::ReproducerStream
/// that is backed by a file.
struct FileReproducerStream : public mlir::ReproducerStream {
  FileReproducerStream(std::unique_ptr<llvm::ToolOutputFile> outputFile)
      : outputFile(std::move(outputFile)) {}
  ~FileReproducerStream() override { outputFile->keep(); }

  /// Returns a description of the reproducer stream.
  StringRef description() override { return outputFile->getFilename(); }

  /// Returns the stream on which to output the reproducer.
  raw_ostream &os() override { return outputFile->os(); }

private:
  /// ToolOutputFile corresponding to opened `filename`.
  std::unique_ptr<llvm::ToolOutputFile> outputFile = nullptr;
};
} // namespace

//===----------------------------------------------------------------------===//
// PassManager
//===----------------------------------------------------------------------===//

LogicalResult PassManager::runWithCrashRecovery(Operation *op,
                                                AnalysisManager am) {
  const bool threadingEnabled = getContext()->isMultithreadingEnabled();
  crashReproGenerator->initialize(getPasses(), op, verifyPasses);

  // Safely invoke the passes within a recovery context.
  LogicalResult passManagerResult = failure();
  llvm::CrashRecoveryContext recoveryContext;
  const auto runPassesFn = [&] { passManagerResult = runPasses(op, am); };
  if (threadingEnabled)
    recoveryContext.RunSafelyOnThread(runPassesFn);
  else
    recoveryContext.RunSafely(runPassesFn);
  crashReproGenerator->finalize(op, passManagerResult);

  return passManagerResult;
}

static ReproducerStreamFactory
makeReproducerStreamFactory(StringRef outputFile) {
  // Capture the filename by value in case outputFile is out of scope when
  // invoked.
  std::string filename = outputFile.str();
  return [filename](std::string &error) -> std::unique_ptr<ReproducerStream> {
    std::unique_ptr<llvm::ToolOutputFile> outputFile =
        mlir::openOutputFile(filename, &error);
    if (!outputFile) {
      error = "Failed to create reproducer stream: " + error;
      return nullptr;
    }
    return std::make_unique<FileReproducerStream>(std::move(outputFile));
  };
}

void printAsTextualPipeline(
    raw_ostream &os, StringRef anchorName,
    const llvm::iterator_range<OpPassManager::pass_iterator> &passes,
    bool pretty = false);

std::string mlir::makeReproducer(
    StringRef anchorName,
    const llvm::iterator_range<OpPassManager::pass_iterator> &passes,
    Operation *op, StringRef outputFile, bool disableThreads,
    bool verifyPasses) {

  std::string description;
  std::string pipelineStr;
  llvm::raw_string_ostream passOS(pipelineStr);
  ::printAsTextualPipeline(passOS, anchorName, passes);
  appendReproducer(description, op, makeReproducerStreamFactory(outputFile),
                   pipelineStr, disableThreads, verifyPasses);
  return description;
}

void PassManager::enableCrashReproducerGeneration(StringRef outputFile,
                                                  bool genLocalReproducer) {
  enableCrashReproducerGeneration(makeReproducerStreamFactory(outputFile),
                                  genLocalReproducer);
}

void PassManager::enableCrashReproducerGeneration(
    ReproducerStreamFactory factory, bool genLocalReproducer) {
  assert(!crashReproGenerator &&
         "crash reproducer has already been initialized");
  if (genLocalReproducer && getContext()->isMultithreadingEnabled())
    llvm::report_fatal_error(
        "Local crash reproduction can't be setup on a "
        "pass-manager without disabling multi-threading first.");

  crashReproGenerator = std::make_unique<PassCrashReproducerGenerator>(
      factory, genLocalReproducer);
  addInstrumentation(
      std::make_unique<CrashReproducerInstrumentation>(*crashReproGenerator));
}

//===----------------------------------------------------------------------===//
// Asm Resource
//===----------------------------------------------------------------------===//

void PassReproducerOptions::attachResourceParser(ParserConfig &config) {
  auto parseFn = [this](AsmParsedResourceEntry &entry) -> LogicalResult {
    if (entry.getKey() == "pipeline") {
      FailureOr<std::string> value = entry.parseAsString();
      if (succeeded(value))
        this->pipeline = std::move(*value);
      return value;
    }
    if (entry.getKey() == "disable_threading") {
      FailureOr<bool> value = entry.parseAsBool();
      if (succeeded(value))
        this->disableThreading = *value;
      return value;
    }
    if (entry.getKey() == "verify_each") {
      FailureOr<bool> value = entry.parseAsBool();
      if (succeeded(value))
        this->verifyEach = *value;
      return value;
    }
    return entry.emitError() << "unknown 'mlir_reproducer' resource key '"
                             << entry.getKey() << "'";
  };
  config.attachResourceParser("mlir_reproducer", parseFn);
}

LogicalResult PassReproducerOptions::apply(PassManager &pm) const {
  if (pipeline.has_value()) {
    FailureOr<OpPassManager> reproPm = parsePassPipeline(*pipeline);
    if (failed(reproPm))
      return failure();
    static_cast<OpPassManager &>(pm) = std::move(*reproPm);
  }

  if (disableThreading.has_value())
    pm.getContext()->disableMultithreading(*disableThreading);

  if (verifyEach.has_value())
    pm.enableVerifier(*verifyEach);

  return success();
}
