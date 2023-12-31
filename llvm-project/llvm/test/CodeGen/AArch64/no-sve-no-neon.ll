; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=-neon < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu-elf"

define <16 x float> @foo(<16 x i64> %a) {
; CHECK-LABEL: foo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp x10, x9, [sp, #48]
; CHECK-NEXT:    ucvtf s0, x9
; CHECK-NEXT:    ldp x11, x9, [sp, #32]
; CHECK-NEXT:    ucvtf s1, x10
; CHECK-NEXT:    ucvtf s2, x9
; CHECK-NEXT:    ldp x10, x9, [sp, #16]
; CHECK-NEXT:    ucvtf s3, x11
; CHECK-NEXT:    str s0, [x8, #60]
; CHECK-NEXT:    ucvtf s4, x9
; CHECK-NEXT:    ldp x11, x9, [sp]
; CHECK-NEXT:    ucvtf s0, x10
; CHECK-NEXT:    stp s2, s1, [x8, #52]
; CHECK-NEXT:    ucvtf s1, x9
; CHECK-NEXT:    ucvtf s2, x11
; CHECK-NEXT:    stp s4, s3, [x8, #44]
; CHECK-NEXT:    ucvtf s3, x7
; CHECK-NEXT:    ucvtf s4, x6
; CHECK-NEXT:    stp s1, s0, [x8, #36]
; CHECK-NEXT:    ucvtf s0, x5
; CHECK-NEXT:    ucvtf s1, x4
; CHECK-NEXT:    stp s3, s2, [x8, #28]
; CHECK-NEXT:    ucvtf s2, x3
; CHECK-NEXT:    ucvtf s3, x2
; CHECK-NEXT:    stp s0, s4, [x8, #20]
; CHECK-NEXT:    ucvtf s4, x1
; CHECK-NEXT:    ucvtf s0, x0
; CHECK-NEXT:    stp s2, s1, [x8, #12]
; CHECK-NEXT:    stp s4, s3, [x8, #4]
; CHECK-NEXT:    str s0, [x8]
; CHECK-NEXT:    ret
  %conv1 = uitofp <16 x i64> %a to <16 x float>
  ret <16 x float> %conv1
}
