; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=msp430-unknown-unknown < %s | FileCheck %s

define i1 @fcmp_false_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_false_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    clr.b r12
; CHECK-NEXT:    ret
  %cmp = fcmp false double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oeq_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_oeq_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp oeq double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ogt_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ogt_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jge .LBB2_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp ogt double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oge_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_oge_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jge .LBB3_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp oge double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_olt_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_olt_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jl .LBB4_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB4_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp olt double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ole_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ole_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jl .LBB5_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB5_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp ole double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_one_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_one_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r4
; CHECK-NEXT:    push r5
; CHECK-NEXT:    push r6
; CHECK-NEXT:    push r7
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    sub #8, r1
; CHECK-NEXT:    mov r15, r7
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 24(r1), r12
; CHECK-NEXT:    mov 26(r1), r5
; CHECK-NEXT:    mov 28(r1), r4
; CHECK-NEXT:    mov 30(r1), r6
; CHECK-NEXT:    mov r7, r11
; CHECK-NEXT:    mov r5, r13
; CHECK-NEXT:    mov r4, r14
; CHECK-NEXT:    mov r6, r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r6, 6(r1)
; CHECK-NEXT:    mov r4, 4(r1)
; CHECK-NEXT:    mov r5, 2(r1)
; CHECK-NEXT:    mov 24(r1), r13
; CHECK-NEXT:    mov r13, 0(r1)
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r6
; CHECK-NEXT:    mov r8, r12
; CHECK-NEXT:    mov r9, r13
; CHECK-NEXT:    mov r10, r14
; CHECK-NEXT:    mov r7, r15
; CHECK-NEXT:    call #__unorddf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r6
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    bic r6, r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    add #8, r1
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    pop r7
; CHECK-NEXT:    pop r6
; CHECK-NEXT:    pop r5
; CHECK-NEXT:    pop r4
; CHECK-NEXT:    ret
  %cmp = fcmp one double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ord_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ord_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub #8, r1
; CHECK-NEXT:    mov 16(r1), 6(r1)
; CHECK-NEXT:    mov 14(r1), 4(r1)
; CHECK-NEXT:    mov 12(r1), 2(r1)
; CHECK-NEXT:    mov 10(r1), 0(r1)
; CHECK-NEXT:    call #__unorddf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    add #8, r1
; CHECK-NEXT:    ret
  %cmp = fcmp ord double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uno_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_uno_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub #8, r1
; CHECK-NEXT:    mov 16(r1), 6(r1)
; CHECK-NEXT:    mov 14(r1), 4(r1)
; CHECK-NEXT:    mov 12(r1), 2(r1)
; CHECK-NEXT:    mov 10(r1), 0(r1)
; CHECK-NEXT:    call #__unorddf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r13
; CHECK-NEXT:    rra r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    bic r13, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    add #8, r1
; CHECK-NEXT:    ret
  %cmp = fcmp uno double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ueq_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ueq_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r4
; CHECK-NEXT:    push r5
; CHECK-NEXT:    push r6
; CHECK-NEXT:    push r7
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    sub #8, r1
; CHECK-NEXT:    mov r15, r7
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 24(r1), r12
; CHECK-NEXT:    mov 26(r1), r5
; CHECK-NEXT:    mov 28(r1), r4
; CHECK-NEXT:    mov 30(r1), r6
; CHECK-NEXT:    mov r7, r11
; CHECK-NEXT:    mov r5, r13
; CHECK-NEXT:    mov r4, r14
; CHECK-NEXT:    mov r6, r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r6, 6(r1)
; CHECK-NEXT:    mov r4, 4(r1)
; CHECK-NEXT:    mov r5, 2(r1)
; CHECK-NEXT:    mov 24(r1), r13
; CHECK-NEXT:    mov r13, 0(r1)
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r6
; CHECK-NEXT:    rra r6
; CHECK-NEXT:    and #1, r6
; CHECK-NEXT:    mov r8, r12
; CHECK-NEXT:    mov r9, r13
; CHECK-NEXT:    mov r10, r14
; CHECK-NEXT:    mov r7, r15
; CHECK-NEXT:    call #__unorddf2
; CHECK-NEXT:    bis r6, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    add #8, r1
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    pop r7
; CHECK-NEXT:    pop r6
; CHECK-NEXT:    pop r5
; CHECK-NEXT:    pop r4
; CHECK-NEXT:    ret
  %cmp = fcmp ueq double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ugt_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ugt_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jge .LBB10_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB10_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp ugt double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uge_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_uge_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jge .LBB11_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB11_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp uge double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ult_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ult_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jl .LBB12_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB12_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp ult double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ule_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_ule_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jl .LBB13_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB13_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp ule double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_une_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_une_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r11
; CHECK-NEXT:    mov r14, r10
; CHECK-NEXT:    mov r13, r9
; CHECK-NEXT:    mov r12, r8
; CHECK-NEXT:    mov 8(r1), r12
; CHECK-NEXT:    mov 10(r1), r13
; CHECK-NEXT:    mov 12(r1), r14
; CHECK-NEXT:    mov 14(r1), r15
; CHECK-NEXT:    call #__mspabi_cmpd
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r13
; CHECK-NEXT:    rra r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    bic r13, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    ret
  %cmp = fcmp une double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_true_f64(double %a, double %b) #0 {
; CHECK-LABEL: fcmp_true_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov.b #1, r12
; CHECK-NEXT:    ret
  %cmp = fcmp true double %a, %b
  ret i1 %cmp
}

define i1 @fcmp_false_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_false_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    clr.b r12
; CHECK-NEXT:    ret
  %cmp = fcmp false float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oeq_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_oeq_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp oeq float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ogt_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ogt_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jge .LBB18_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB18_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ogt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oge_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_oge_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jge .LBB19_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB19_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp oge float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_olt_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_olt_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jl .LBB20_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB20_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp olt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ole_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ole_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jl .LBB21_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB21_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ole float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_one_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_one_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r6
; CHECK-NEXT:    push r7
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r10
; CHECK-NEXT:    mov r14, r9
; CHECK-NEXT:    mov r13, r8
; CHECK-NEXT:    mov r12, r7
; CHECK-NEXT:    call #__unordsf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r6
; CHECK-NEXT:    mov r7, r12
; CHECK-NEXT:    mov r8, r13
; CHECK-NEXT:    mov r9, r14
; CHECK-NEXT:    mov r10, r15
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    rra r6
; CHECK-NEXT:    bic r12, r6
; CHECK-NEXT:    and #1, r6
; CHECK-NEXT:    mov.b r6, r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    pop r7
; CHECK-NEXT:    pop r6
; CHECK-NEXT:    ret
  %cmp = fcmp one float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ord_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ord_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__unordsf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ord float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uno_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_uno_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__unordsf2
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r13
; CHECK-NEXT:    rra r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    bic r13, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp uno float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ueq_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ueq_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    push r6
; CHECK-NEXT:    push r7
; CHECK-NEXT:    push r8
; CHECK-NEXT:    push r9
; CHECK-NEXT:    push r10
; CHECK-NEXT:    mov r15, r10
; CHECK-NEXT:    mov r14, r9
; CHECK-NEXT:    mov r13, r8
; CHECK-NEXT:    mov r12, r7
; CHECK-NEXT:    call #__unordsf2
; CHECK-NEXT:    mov r12, r6
; CHECK-NEXT:    mov r7, r12
; CHECK-NEXT:    mov r8, r13
; CHECK-NEXT:    mov r9, r14
; CHECK-NEXT:    mov r10, r15
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r12
; CHECK-NEXT:    rra r12
; CHECK-NEXT:    and #1, r12
; CHECK-NEXT:    bis r6, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    pop r10
; CHECK-NEXT:    pop r9
; CHECK-NEXT:    pop r8
; CHECK-NEXT:    pop r7
; CHECK-NEXT:    pop r6
; CHECK-NEXT:    ret
  %cmp = fcmp ueq float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ugt_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ugt_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jge .LBB26_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB26_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ugt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uge_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_uge_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jge .LBB27_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB27_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp uge float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ult_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ult_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    tst r13
; CHECK-NEXT:    jl .LBB28_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB28_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ult float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ule_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_ule_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    mov r12, r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    cmp #1, r13
; CHECK-NEXT:    jl .LBB29_2
; CHECK-NEXT:  ; %bb.1:
; CHECK-NEXT:    clr r12
; CHECK-NEXT:  .LBB29_2:
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp ule float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_une_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_une_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    call #__mspabi_cmpf
; CHECK-NEXT:    tst r12
; CHECK-NEXT:    mov r2, r13
; CHECK-NEXT:    rra r13
; CHECK-NEXT:    mov #1, r12
; CHECK-NEXT:    bic r13, r12
; CHECK-NEXT:    ; kill: def $r12b killed $r12b killed $r12
; CHECK-NEXT:    ret
  %cmp = fcmp une float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_true_f32(float %a, float %b) #0 {
; CHECK-LABEL: fcmp_true_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov.b #1, r12
; CHECK-NEXT:    ret
  %cmp = fcmp true float %a, %b
  ret i1 %cmp
}

attributes #0 = { nounwind }
