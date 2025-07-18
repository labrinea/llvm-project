//===- DeclareRuntimeLibcalls.h ---------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_DECLARERUNTIMELIBCALLS_H
#define LLVM_TRANSFORMS_UTILS_DECLARERUNTIMELIBCALLS_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class DeclareRuntimeLibcallsPass
    : public PassInfoMixin<DeclareRuntimeLibcallsPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

} // end namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_DECLARERUNTIMELIBCALLS_H
