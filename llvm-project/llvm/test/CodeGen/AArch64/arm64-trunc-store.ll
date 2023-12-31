; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-none-eabi | FileCheck %s

define void @bar(<8 x i16> %arg, ptr %p) nounwind {
; CHECK-LABEL: bar:
; CHECK:       // %bb.0:
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %tmp = trunc <8 x i16> %arg to <8 x i8>
  store <8 x i8> %tmp, ptr %p, align 8
  ret void
}

@zptr8 = common global ptr null, align 8
@zptr16 = common global ptr null, align 8
@zptr32 = common global ptr null, align 8

define void @fct32(i32 %arg, i64 %var) {
; CHECK-LABEL: fct32:
; CHECK:       // %bb.0: // %bb
; CHECK-NEXT:    adrp x8, :got:zptr32
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:zptr32]
; CHECK-NEXT:    ldr x8, [x8]
; CHECK-NEXT:    add x8, x8, w0, sxtw #2
; CHECK-NEXT:    stur w1, [x8, #-4]
; CHECK-NEXT:    ret
bb:
  %.pre37 = load ptr, ptr @zptr32, align 8
  %dec = add nsw i32 %arg, -1
  %idxprom8 = sext i32 %dec to i64
  %arrayidx9 = getelementptr inbounds i32, ptr %.pre37, i64 %idxprom8
  %tmp = trunc i64 %var to i32
  store i32 %tmp, ptr %arrayidx9, align 4
  ret void
}

define void @fct16(i32 %arg, i64 %var) {
; CHECK-LABEL: fct16:
; CHECK:       // %bb.0: // %bb
; CHECK-NEXT:    adrp x8, :got:zptr16
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:zptr16]
; CHECK-NEXT:    ldr x8, [x8]
; CHECK-NEXT:    add x8, x8, w0, sxtw #1
; CHECK-NEXT:    sturh w1, [x8, #-2]
; CHECK-NEXT:    ret
bb:
  %.pre37 = load ptr, ptr @zptr16, align 8
  %dec = add nsw i32 %arg, -1
  %idxprom8 = sext i32 %dec to i64
  %arrayidx9 = getelementptr inbounds i16, ptr %.pre37, i64 %idxprom8
  %tmp = trunc i64 %var to i16
  store i16 %tmp, ptr %arrayidx9, align 4
  ret void
}

define void @fct8(i32 %arg, i64 %var) {
; CHECK-LABEL: fct8:
; CHECK:       // %bb.0: // %bb
; CHECK-NEXT:    adrp x8, :got:zptr8
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:zptr8]
; CHECK-NEXT:    ldr x8, [x8]
; CHECK-NEXT:    add x8, x8, w0, sxtw
; CHECK-NEXT:    sturb w1, [x8, #-1]
; CHECK-NEXT:    ret
bb:
  %.pre37 = load ptr, ptr @zptr8, align 8
  %dec = add nsw i32 %arg, -1
  %idxprom8 = sext i32 %dec to i64
  %arrayidx9 = getelementptr inbounds i8, ptr %.pre37, i64 %idxprom8
  %tmp = trunc i64 %var to i8
  store i8 %tmp, ptr %arrayidx9, align 4
  ret void
}
