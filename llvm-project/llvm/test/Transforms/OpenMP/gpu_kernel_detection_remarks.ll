; RUN: opt -passes=openmp-opt-cgscc -pass-remarks-analysis=openmp-opt -openmp-print-gpu-kernels -disable-output < %s 2>&1 | FileCheck %s --implicit-check-not=non_kernel

; CHECK-DAG: remark: <unknown>:0:0: OpenMP GPU kernel kernel1
; CHECK-DAG: remark: <unknown>:0:0: OpenMP GPU kernel kernel2

define void @kernel1() "kernel" {
  ret void
}

define void @kernel2() "kernel" {
  ret void
}

define void @non_kernel() {
  ret void
}

; Needed to trigger the openmp-opt pass
declare dso_local void @__kmpc_kernel_prepare_parallel(ptr)

!llvm.module.flags = !{!4}
!nvvm.annotations = !{!2, !0, !1, !3, !1, !2}

!0 = !{ptr @kernel1, !"kernel", i32 1}
!1 = !{ptr @non_kernel, !"non_kernel", i32 1}
!2 = !{null, !"align", i32 1}
!3 = !{ptr @kernel2, !"kernel", i32 1}
!4 = !{i32 7, !"openmp", i32 50}
