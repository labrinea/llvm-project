; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instsimplify < %s | FileCheck %s

declare void @zero_args()
declare void @two_args(ptr, ptr)

define i1 @test_zero_args_nonnull(ptr %p) {
; CHECK-LABEL: @test_zero_args_nonnull(
; CHECK-NEXT:    call void @zero_args(ptr noundef nonnull [[P:%.*]])
; CHECK-NEXT:    ret i1 true
;
  call void @zero_args(ptr nonnull noundef %p)
  %c = icmp ne ptr %p, null
  ret i1 %c
}

define i1 @test_zero_args_maybe_null(ptr %p) {
; CHECK-LABEL: @test_zero_args_maybe_null(
; CHECK-NEXT:    call void @zero_args(ptr [[P:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne ptr [[P]], null
; CHECK-NEXT:    ret i1 [[C]]
;
  call void @zero_args(ptr %p)
  %c = icmp ne ptr %p, null
  ret i1 %c
}

define i1 @test_two_args_nonnull(ptr %p) {
; CHECK-LABEL: @test_two_args_nonnull(
; CHECK-NEXT:    call void @two_args(ptr noundef nonnull [[P:%.*]])
; CHECK-NEXT:    ret i1 true
;
  call void @two_args(ptr nonnull noundef %p)
  %c = icmp ne ptr %p, null
  ret i1 %c
}

define i1 @test_two_args_maybe_null(ptr %p) {
; CHECK-LABEL: @test_two_args_maybe_null(
; CHECK-NEXT:    call void @two_args(ptr [[P:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne ptr [[P]], null
; CHECK-NEXT:    ret i1 [[C]]
;
  call void @two_args(ptr %p)
  %c = icmp ne ptr %p, null
  ret i1 %c
}
