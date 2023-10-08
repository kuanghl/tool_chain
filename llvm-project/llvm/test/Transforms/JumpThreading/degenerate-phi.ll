; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=jump-threading < %s | FileCheck %s
; PR9112

; This is actually a test for value tracking. Jump threading produces
; "%phi = phi i16" when it removes all edges leading to %unreachable.
; The .ll parser won't let us write that directly since it's invalid code.

define void @func() nounwind {
; CHECK-LABEL: @func(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    br label [[BB]]
; CHECK:       unreachable:
; CHECK-NEXT:    [[PHI:%.*]] = phi i16 [ [[ADD:%.*]], [[UNREACHABLE:%.*]] ], [ 0, [[NEXT:%.*]] ]
; CHECK-NEXT:    [[ADD]] = add i16 0, [[PHI]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[PHI]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[UNREACHABLE]], label [[NEXT]]
; CHECK:       next:
; CHECK-NEXT:    br label [[UNREACHABLE]]
;
entry:
  br label %bb

bb:
  br label %bb

unreachable:
  %phi = phi i16 [ %add, %unreachable ], [ 0, %next ]
  %add = add i16 0, %phi
  %cmp = icmp slt i16 %phi, 0
  br i1 %cmp, label %unreachable, label %next

next:
  br label %unreachable
}
