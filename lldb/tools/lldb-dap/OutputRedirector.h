//===-- OutputRedirector.h -------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===/

#ifndef LLDB_TOOLS_LLDB_DAP_OUTPUT_REDIRECTOR_H
#define LLDB_TOOLS_LLDB_DAP_OUTPUT_REDIRECTOR_H

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"
#include <atomic>
#include <functional>
#include <thread>

namespace lldb_dap {

class OutputRedirector {
public:
  static int kInvalidDescriptor;

  /// Creates writable file descriptor that will invoke the given callback on
  /// each write in a background thread.
  ///
  /// \param[in] file_override
  ///     Updates the file descriptor to the redirection pipe, if not null.
  ///
  /// \param[in] callback
  ///     A callback invoked when any data is written to the file handle.
  ///
  /// \return
  ///     \a Error::success if the redirection was set up correctly, or an error
  ///     otherwise.
  llvm::Error RedirectTo(std::FILE *file_override,
                         std::function<void(llvm::StringRef)> callback);

  llvm::Expected<int> GetWriteFileDescriptor();
  void Stop();

  ~OutputRedirector() { Stop(); }

  OutputRedirector();
  OutputRedirector(const OutputRedirector &) = delete;
  OutputRedirector &operator=(const OutputRedirector &) = delete;

private:
  std::atomic<bool> m_stopped = false;
  int m_fd;
  int m_original_fd;
  int m_restore_fd;
  std::thread m_forwarder;
};

} // namespace lldb_dap

#endif // LLDB_TOOLS_LLDB_DAP_OUTPUT_REDIRECTOR_H
