; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le-unknown-linux-gnu -mattr=+power8-vector < %s | FileCheck %s

define void @VPKUDUM_unary(ptr %A) {
; CHECK-LABEL: VPKUDUM_unary:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvd2x 0, 0, 3
; CHECK-NEXT:    xxswapd 34, 0
; CHECK-NEXT:    vpkudum 2, 2, 2
; CHECK-NEXT:    xxswapd 0, 34
; CHECK-NEXT:    stxvd2x 0, 0, 3
; CHECK-NEXT:    blr
entry:
	%tmp = load <2 x i64>, ptr %A
	%tmp2 = bitcast <2 x i64> %tmp to <4 x i32>
	%tmp3 = extractelement <4 x i32> %tmp2, i32 0
	%tmp4 = extractelement <4 x i32> %tmp2, i32 2
	%tmp5 = insertelement <4 x i32> undef, i32 %tmp3, i32 0
	%tmp6 = insertelement <4 x i32> %tmp5, i32 %tmp4, i32 1
	%tmp7 = insertelement <4 x i32> %tmp6, i32 %tmp3, i32 2
	%tmp8 = insertelement <4 x i32> %tmp7, i32 %tmp4, i32 3
	%tmp9 = bitcast <4 x i32> %tmp8 to <2 x i64>
	store <2 x i64> %tmp9, ptr %A
	ret void
}

define void @VPKUDUM(ptr %A, ptr %B) {
; CHECK-LABEL: VPKUDUM:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvd2x 0, 0, 3
; CHECK-NEXT:    xxswapd 34, 0
; CHECK-NEXT:    lxvd2x 0, 0, 4
; CHECK-NEXT:    xxswapd 35, 0
; CHECK-NEXT:    vpkudum 2, 3, 2
; CHECK-NEXT:    xxswapd 0, 34
; CHECK-NEXT:    stxvd2x 0, 0, 3
; CHECK-NEXT:    blr
entry:
	%tmp = load <2 x i64>, ptr %A
	%tmp2 = bitcast <2 x i64> %tmp to <4 x i32>
        %tmp3 = load <2 x i64>, ptr %B
        %tmp4 = bitcast <2 x i64> %tmp3 to <4 x i32>
	%tmp5 = extractelement <4 x i32> %tmp2, i32 0
	%tmp6 = extractelement <4 x i32> %tmp2, i32 2
	%tmp7 = extractelement <4 x i32> %tmp4, i32 0
	%tmp8 = extractelement <4 x i32> %tmp4, i32 2
	%tmp9 = insertelement <4 x i32> undef, i32 %tmp5, i32 0
	%tmp10 = insertelement <4 x i32> %tmp9, i32 %tmp6, i32 1
	%tmp11 = insertelement <4 x i32> %tmp10, i32 %tmp7, i32 2
	%tmp12 = insertelement <4 x i32> %tmp11, i32 %tmp8, i32 3
	%tmp13 = bitcast <4 x i32> %tmp12 to <2 x i64>
	store <2 x i64> %tmp13, ptr %A
	ret void
}

