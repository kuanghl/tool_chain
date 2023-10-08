; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

; If we only want bits that already match the signbit then we don't need to shift.

define i32 @srem2_ashr_mask(i32 %a0) {
; CHECK-LABEL: @srem2_ashr_mask(
; CHECK-NEXT:    [[SREM:%.*]] = srem i32 [[A0:%.*]], 2
; CHECK-NEXT:    [[MASK:%.*]] = and i32 [[SREM]], 2
; CHECK-NEXT:    ret i32 [[MASK]]
;
  %srem = srem i32 %a0, 2 ; result = (1,0,-1) num signbits = 31
  %ashr = ashr i32 %srem, 31
  %mask = and i32 %ashr, 2
  ret i32 %mask
}

; Negative test - mask demands non-signbit from shift source
define i32 @srem8_ashr_mask(i32 %a0) {
; CHECK-LABEL: @srem8_ashr_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A0:%.*]], -2147483641
; CHECK-NEXT:    [[ISNEG:%.*]] = icmp ugt i32 [[TMP1]], -2147483648
; CHECK-NEXT:    [[MASK:%.*]] = select i1 [[ISNEG]], i32 2, i32 0
; CHECK-NEXT:    ret i32 [[MASK]]
;
  %srem = srem i32 %a0, 8
  %ashr = ashr i32 %srem, 31
  %mask = and i32 %ashr, 2
  ret i32 %mask
}

define <2 x i32> @srem2_ashr_mask_vector(<2 x i32> %a0) {
; CHECK-LABEL: @srem2_ashr_mask_vector(
; CHECK-NEXT:    [[SREM:%.*]] = srem <2 x i32> [[A0:%.*]], <i32 2, i32 2>
; CHECK-NEXT:    [[MASK:%.*]] = and <2 x i32> [[SREM]], <i32 2, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[MASK]]
;
  %srem = srem <2 x i32> %a0, <i32 2, i32 2>
  %ashr = ashr <2 x i32> %srem, <i32 31, i32 31>
  %mask = and <2 x i32> %ashr, <i32 2, i32 2>
  ret <2 x i32> %mask
}

define <2 x i32> @srem2_ashr_mask_vector_nonconstant(<2 x i32> %a0, <2 x i32> %a1) {
; CHECK-LABEL: @srem2_ashr_mask_vector_nonconstant(
; CHECK-NEXT:    [[SREM:%.*]] = srem <2 x i32> [[A0:%.*]], <i32 2, i32 2>
; CHECK-NEXT:    [[MASK:%.*]] = and <2 x i32> [[SREM]], <i32 2, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[MASK]]
;
  %srem = srem <2 x i32> %a0, <i32 2, i32 2>
  %ashr = ashr <2 x i32> %srem, %a1
  %mask = and <2 x i32> %ashr, <i32 2, i32 2>
  ret <2 x i32> %mask
}