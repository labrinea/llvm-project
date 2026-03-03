# This test checks that the LongJmp pass uses a dead register when relaxing stubs.

# REQUIRES: system-linux, asserts

# RUN: %clang %cflags -Wl,-q %s -o %t
# RUN: link_fdata --no-lbr %s %t %t.fdata
# RUN: not llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions 2>&1 \
# RUN:   | FileCheck %s --check-prefix=NOABI

# RUN: %clang %cflags -Wl,-q %s -o %t
# RUN: link_fdata --no-lbr %s %t %t.fdata
# RUN: llvm-bolt %t -o %t.bolt --data %t.fdata -split-functions --assume-abi \
# RUN:   --print-split --print-longjmp 2>&1 | FileCheck %s

# NOABI: BOLT-INFO: Starting stub-insertion pass
# NOABI: BOLT-ERROR: no scratch register to relax stub

  .globl fn1
  .type fn1, %function
fn1:
.entry_fn1:
# FDATA: 1 fn1 #.entry_fn1# 10
    mov x8, #1
    cmp x0, #0
    bgt .Lcold_fn1
.fallthrough_fn1:
## LiveIn = { x1-x8 }
    add x0, x8, #1
.Lcold_fn1:
## LiveIn = { x0-x7 }
    ret

# CHECK: BOLT-INFO: Starting stub-insertion pass

# CHECK: Binary Function "fn1(*2)" after long-jmp

# CHECK:      .LBB00 (3 instructions
# CHECK:        mov x8, #0x1
# CHECK-NEXT:   cmp x0, #0x0
# CHECK-NEXT:   b.gt .LStub0
# CHECK-NEXT: Successors: .LStub0

# CHECK:      .Ltmp0 (1 instructions
# CHECK:      Predecessors: .LBB00
# CHECK-NEXT:   add x0, x8, #0x1
# CHECK-NEXT: Successors: .LStub0

# CHECK:      .LStub0 (3 instructions
# CHECK:      Predecessors: .LBB00, .Ltmp0
# CHECK-NEXT:   adrp x9, .Ltmp2
# CHECK-NEXT:   add x9, x9, :lo12:.Ltmp2
# CHECK-NEXT:   br x9 # UNKNOWN CONTROL FLOW
# CHECK-NEXT: Successors: .Ltmp2

# CHECK:      -------   HOT-COLD SPLIT POINT   -------

# CHECK:      .Ltmp2 (1 instructions
# CHECK:      Predecessors: .LStub0
# CHECK-NEXT:   ret

  .globl fn2
  .type fn2, %function
fn2:
.entry_fn2:
# FDATA: 1 fn2 #.entry_fn2# 10
    cmp x3, #0
    bgt .Lcold_fn2
.fallthrough_fn2:
## LiveIn = { x0, x2, x4-x7 }
    mov x1, #1
    mov x3, #10
    ret
.Lcold_fn2:
## LiveIn = { x0, x1, x4-x7 }
    mov x2, #2
    mov x3, #20
    ret

# CHECK: Binary Function "fn2" after long-jmp

# CHECK:      .LBB01 (2 instructions
# CHECK:        cmp x3, #0x0
# CHECK-NEXT:   b.gt .LStub1
# CHECK-NEXT: Successors: .LStub1

# CHECK:      .Ltmp1 (3 instructions
# CHECK:      Predecessors: .LBB01
# CHECK-NEXT:   mov x1, #0x1
# CHECK-NEXT:   mov x3, #0xa
# CHECK-NEXT:   ret

# CHECK:      .LStub1 (3 instructions
# CHECK:      Predecessors: .LBB01
# CHECK-NEXT:   adrp x3, .Ltmp3
# CHECK-NEXT:   add x3, x3, :lo12:.Ltmp3
# CHECK-NEXT:   br x3 # UNKNOWN CONTROL FLOW
# CHECK-NEXT: Successors: .Ltmp3

# CHECK:      -------   HOT-COLD SPLIT POINT   -------

# CHECK:      .Ltmp3 (3 instructions
# CHECK:      Predecessors: .LStub1
# CHECK-NEXT:   mov x2, #0x2
# CHECK-NEXT:   mov x3, #0x14
# CHECK-NEXT:   ret

.space 0x8000000

## Force relocation mode.
.reloc 0, R_AARCH64_NONE

