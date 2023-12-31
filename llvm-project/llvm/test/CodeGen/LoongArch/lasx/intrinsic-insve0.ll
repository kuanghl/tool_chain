; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

declare <8 x i32> @llvm.loongarch.lasx.xvinsve0.w(<8 x i32>, <8 x i32>, i32)

define <8 x i32> @lasx_xvinsve0_w(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvinsve0_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvinsve0.w $xr0, $xr1, 1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvinsve0.w(<8 x i32> %va, <8 x i32> %vb, i32 1)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvinsve0.d(<4 x i64>, <4 x i64>, i32)

define <4 x i64> @lasx_xvinsve0_d(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvinsve0_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvinsve0.d $xr0, $xr1, 1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvinsve0.d(<4 x i64> %va, <4 x i64> %vb, i32 1)
  ret <4 x i64> %res
}
