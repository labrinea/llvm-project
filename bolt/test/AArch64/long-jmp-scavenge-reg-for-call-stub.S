# This test checks that the LongJmp pass uses a dead register
# when relaxing stubs needed for calls to far away functions
# if --assume-abi is specified, or x16 when not specified.

# REQUIRES: system-linux, asserts

# RUN: %clang %cflags -Wl,-q %s -o %t
# RUN: link_fdata --no-lbr %s %t %t.fdata
# RUN: llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions \
# RUN:   --print-split --print-longjmp 2>&1 | FileCheck %s --check-prefix=NOABI

# RUN: %clang %cflags -Wl,-q %s -o %t
# RUN: link_fdata --no-lbr %s %t %t.fdata
# RUN: llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions --assume-abi \
# RUN:   --print-split --print-longjmp 2>&1 | FileCheck %s

  .globl foo
  .type foo, %function
foo:
.entry_foo:
# FDATA: 1 foo #.entry_foo# 10
    bl bar
## LiveIn = { x0-x3, x5-x7 }
    mov x4, #4
    ret

# NOABI: BOLT-INFO: Starting stub-insertion pass
#
# NOABI: Binary Function "foo" after long-jmp
#
# NOABI:      .LBB01 (3 instructions
# NOABI:        bl .LStub0
# NOABI-NEXT:   mov x4, #0x4
# NOABI-NEXT:   ret
#
# NOABI:      .LStub0 (3 instructions
# NOABI:        adrp x16, bar
# NOABI-NEXT:   add x16, x16, :lo12:bar
# NOABI-NEXT:   br x16 # UNKNOWN CONTROL FLOW


# CHECK: BOLT-INFO: Starting stub-insertion pass
#
# CHECK: Binary Function "foo" after long-jmp
#
# CHECK:      .LBB01 (3 instructions
# CHECK:        bl .LStub0
# CHECK-NEXT:   mov x4, #0x4
# CHECK-NEXT:   ret
#
# CHECK:      .LStub0 (3 instructions
# CHECK:        adrp x4, bar
# CHECK-NEXT:   add x4, x4, :lo12:bar
# CHECK-NEXT:   br x4 # UNKNOWN CONTROL FLOW

.space 0x8000000

  .globl bar
  .type bar, %function
bar:
.entry_bar:
# FDATA: 1 bar #.entry_bar# 10
    add x0, x0, #1
    ret

# NOABI: Binary Function "bar" after long-jmp
#
# NOABI:      .LBB02 (2 instructions
# NOABI:        add x0, x0, #0x1
# NOABI-NEXT:   ret


# CHECK: Binary Function "bar" after long-jmp
#
# CHECK:      .LBB02 (2 instructions
# CHECK:        add x0, x0, #0x1
# CHECK-NEXT:   ret

## Force relocation mode.
.reloc 0, R_AARCH64_NONE
