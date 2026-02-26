# This test checks that BOLT can generate BTI landing pads for targets of stubs inserted in LongJmp.

# REQUIRES: system-linux

# RUN: %clang %s %cflags -Wl,-q -o %t -mbranch-protection=bti -Wl,-z,force-bti
# RUN: link_fdata --no-lbr %s %t %t.fdata
# RUN: not llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions \
# RUN: --print-split --print-only foo --print-longjmp 2>&1 | FileCheck %s
# RUN: llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions --assume-abi \
# RUN: --print-split --print-only foo --print-longjmp 2>&1 | FileCheck %s --check-prefixes=ASSUME-ABI

# CHECK: BOLT-ERROR: no scratch register to relax stub

# ASSUME-ABI: BOLT-INFO: Starting stub-insertion pass
# ASSUME-ABI: Binary Function "foo" after long-jmp

# ASSUME-ABI:      cmp     x0, #0x0
# ASSUME-ABI-NEXT: Successors: .LStub0

# ASSUME-ABI:      adrp    x0, .Ltmp0
# ASSUME-ABI-NEXT: add     x0, x0, :lo12:.Ltmp0
# ASSUME-ABI-NEXT: br      x0 # UNKNOWN CONTROL FLOW

# ASSUME-ABI: -------   HOT-COLD SPLIT POINT   -------

# ASSUME-ABI:      bti     j
# ASSUME-ABI-NEXT: mov     x0, #0x2
# ASSUME-ABI-NEXT: ret

  .text
  .globl  foo
  .type foo, %function
foo:
.cfi_startproc
.entry_bb:
# FDATA: 1 foo #.entry_bb# 10
    cmp x0, #0
    b .Lcold_bb1
.Lcold_bb1:
    mov x0, #2
    ret
.cfi_endproc
  .size foo, .-foo

# empty space, so the splitting needs short stubs
.data
.space 0x8000000

## Force relocation mode.
.reloc 0, R_AARCH64_NONE
