; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=jump-threading < %s | FileCheck %s

; Make sure this does not crash due to conflicting known bits.

define i32 @test() {
; CHECK-LABEL: define i32 @test() {
; CHECK-NEXT:  end:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %join

unreachable:
  %sh_prom = zext i32 -1 to i64
  %shl = shl nsw i64 -1, %sh_prom
  %conv = trunc i64 %shl to i32
  br label %join

join:
  %phi = phi i32 [ %conv, %unreachable ], [ 0, %entry ]
  %cmp = icmp eq i32 %phi, 0
  br i1 %cmp, label %end, label %if

if:
  br label %end

end:
  ret i32 0
}
