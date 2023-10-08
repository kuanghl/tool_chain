; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='default<O3>' -enable-matrix -S %s | FileCheck %s

target triple = "arm64-apple-ios"

define void @matrix_extract_insert_scalar(i32 %i, i32 %k, i32 %j, ptr nonnull align 8 dereferenceable(1800) %A, ptr nonnull align 8 dereferenceable(1800) %B) #0 {
; CHECK-LABEL: @matrix_extract_insert_scalar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext i32 [[K:%.*]] to i64
; CHECK-NEXT:    [[CONV1:%.*]] = zext i32 [[J:%.*]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = mul nuw nsw i64 [[CONV1]], 15
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw nsw i64 [[TMP0]], [[CONV]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i64 [[TMP1]], 225
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds <225 x double>, ptr [[A:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[MATRIXEXT:%.*]] = load double, ptr [[TMP3]], align 8
; CHECK-NEXT:    [[CONV2:%.*]] = zext i32 [[I:%.*]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i64 [[TMP0]], [[CONV2]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ult i64 [[TMP4]], 225
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP5]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds <225 x double>, ptr [[B:%.*]], i64 0, i64 [[TMP4]]
; CHECK-NEXT:    [[MATRIXEXT4:%.*]] = load double, ptr [[TMP6]], align 8
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[MATRIXEXT]], [[MATRIXEXT4]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[MATRIXEXT7:%.*]] = load double, ptr [[TMP7]], align 8
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[MATRIXEXT7]], [[MUL]]
; CHECK-NEXT:    store double [[SUB]], ptr [[TMP7]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %i.addr = alloca i32, align 4
  %k.addr = alloca i32, align 4
  %j.addr = alloca i32, align 4
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  store i32 %i, ptr %i.addr, align 4
  store i32 %k, ptr %k.addr, align 4
  store i32 %j, ptr %j.addr, align 4
  store ptr %A, ptr %A.addr, align 8
  store ptr %B, ptr %B.addr, align 8
  %0 = load i32, ptr %k.addr, align 4
  %conv = zext i32 %0 to i64
  %1 = load i32, ptr %j.addr, align 4
  %conv1 = zext i32 %1 to i64
  %2 = mul i64 %conv1, 15
  %3 = add i64 %2, %conv
  %4 = icmp ult i64 %3, 225
  call void @llvm.assume(i1 %4)
  %5 = load ptr, ptr %A.addr, align 8
  %6 = load <225 x double>, ptr %5, align 8
  %matrixext = extractelement <225 x double> %6, i64 %3
  %7 = load i32, ptr %i.addr, align 4
  %conv2 = zext i32 %7 to i64
  %8 = load i32, ptr %j.addr, align 4
  %conv3 = zext i32 %8 to i64
  %9 = mul i64 %conv3, 15
  %10 = add i64 %9, %conv2
  %11 = icmp ult i64 %10, 225
  call void @llvm.assume(i1 %11)
  %12 = load ptr, ptr %B.addr, align 8
  %13 = load <225 x double>, ptr %12, align 8
  %matrixext4 = extractelement <225 x double> %13, i64 %10
  %mul = fmul double %matrixext, %matrixext4
  %14 = load ptr, ptr %B.addr, align 8
  %15 = load i32, ptr %k.addr, align 4
  %conv5 = zext i32 %15 to i64
  %16 = load i32, ptr %j.addr, align 4
  %conv6 = zext i32 %16 to i64
  %17 = mul i64 %conv6, 15
  %18 = add i64 %17, %conv5
  %19 = icmp ult i64 %18, 225
  call void @llvm.assume(i1 %19)
  %20 = load <225 x double>, ptr %14, align 8
  %matrixext7 = extractelement <225 x double> %20, i64 %18
  %sub = fsub double %matrixext7, %mul
  %21 = icmp ult i64 %18, 225
  call void @llvm.assume(i1 %21)
  %22 = load <225 x double>, ptr %14, align 8
  %matins = insertelement <225 x double> %22, double %sub, i64 %18
  store <225 x double> %matins, ptr %14, align 8
  ret void
}
define void @matrix_extract_insert_loop(i32 %i, ptr nonnull align 8 dereferenceable(1800) %A, ptr nonnull align 8 dereferenceable(1800) %B) {
; CHECK-LABEL: @matrix_extract_insert_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP210_NOT:%.*]] = icmp eq i32 [[I:%.*]], 0
; CHECK-NEXT:    [[CONV6:%.*]] = zext i32 [[I]] to i64
; CHECK-NEXT:    br i1 [[CMP210_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[I]], 225
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP0]])
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds <225 x double>, ptr [[B:%.*]], i64 0, i64 [[CONV6]]
; CHECK-NEXT:    br label [[FOR_BODY4_US:%.*]]
; CHECK:       for.body4.us:
; CHECK-NEXT:    [[K_011_US:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INC_US:%.*]], [[FOR_BODY4_US]] ]
; CHECK-NEXT:    [[CONV_US:%.*]] = zext i32 [[K_011_US]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[K_011_US]], 225
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds <225 x double>, ptr [[A:%.*]], i64 0, i64 [[CONV_US]]
; CHECK-NEXT:    [[MATRIXEXT_US:%.*]] = load double, ptr [[TMP3]], align 8
; CHECK-NEXT:    [[MATRIXEXT8_US:%.*]] = load double, ptr [[TMP1]], align 8
; CHECK-NEXT:    [[MUL_US:%.*]] = fmul double [[MATRIXEXT_US]], [[MATRIXEXT8_US]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[CONV_US]]
; CHECK-NEXT:    [[MATRIXEXT11_US:%.*]] = load double, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[SUB_US:%.*]] = fsub double [[MATRIXEXT11_US]], [[MUL_US]]
; CHECK-NEXT:    store double [[SUB_US]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[INC_US]] = add nuw nsw i32 [[K_011_US]], 1
; CHECK-NEXT:    [[CMP2_US:%.*]] = icmp ult i32 [[INC_US]], [[I]]
; CHECK-NEXT:    br i1 [[CMP2_US]], label [[FOR_BODY4_US]], label [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US:%.*]]
; CHECK:       for.cond1.for.cond.cleanup3_crit_edge.us:
; CHECK-NEXT:    [[TMP5:%.*]] = add nuw nsw i64 [[CONV6]], 15
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ult i32 [[I]], 210
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP6]])
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP5]]
; CHECK-NEXT:    br label [[FOR_BODY4_US_1:%.*]]
; CHECK:       for.body4.us.1:
; CHECK-NEXT:    [[K_011_US_1:%.*]] = phi i32 [ 0, [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US]] ], [ [[INC_US_1:%.*]], [[FOR_BODY4_US_1]] ]
; CHECK-NEXT:    [[CONV_US_1:%.*]] = zext i32 [[K_011_US_1]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = add nuw nsw i64 [[CONV_US_1]], 15
; CHECK-NEXT:    [[TMP9:%.*]] = icmp ult i32 [[K_011_US_1]], 210
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP9]])
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds <225 x double>, ptr [[A]], i64 0, i64 [[TMP8]]
; CHECK-NEXT:    [[MATRIXEXT_US_1:%.*]] = load double, ptr [[TMP10]], align 8
; CHECK-NEXT:    [[MATRIXEXT8_US_1:%.*]] = load double, ptr [[TMP7]], align 8
; CHECK-NEXT:    [[MUL_US_1:%.*]] = fmul double [[MATRIXEXT_US_1]], [[MATRIXEXT8_US_1]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP8]]
; CHECK-NEXT:    [[MATRIXEXT11_US_1:%.*]] = load double, ptr [[TMP11]], align 8
; CHECK-NEXT:    [[SUB_US_1:%.*]] = fsub double [[MATRIXEXT11_US_1]], [[MUL_US_1]]
; CHECK-NEXT:    store double [[SUB_US_1]], ptr [[TMP11]], align 8
; CHECK-NEXT:    [[INC_US_1]] = add nuw nsw i32 [[K_011_US_1]], 1
; CHECK-NEXT:    [[CMP2_US_1:%.*]] = icmp ult i32 [[INC_US_1]], [[I]]
; CHECK-NEXT:    br i1 [[CMP2_US_1]], label [[FOR_BODY4_US_1]], label [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US_1:%.*]]
; CHECK:       for.cond1.for.cond.cleanup3_crit_edge.us.1:
; CHECK-NEXT:    [[TMP12:%.*]] = add nuw nsw i64 [[CONV6]], 30
; CHECK-NEXT:    [[TMP13:%.*]] = icmp ult i32 [[I]], 195
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP13]])
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP12]]
; CHECK-NEXT:    br label [[FOR_BODY4_US_2:%.*]]
; CHECK:       for.body4.us.2:
; CHECK-NEXT:    [[K_011_US_2:%.*]] = phi i32 [ 0, [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US_1]] ], [ [[INC_US_2:%.*]], [[FOR_BODY4_US_2]] ]
; CHECK-NEXT:    [[CONV_US_2:%.*]] = zext i32 [[K_011_US_2]] to i64
; CHECK-NEXT:    [[TMP15:%.*]] = add nuw nsw i64 [[CONV_US_2]], 30
; CHECK-NEXT:    [[TMP16:%.*]] = icmp ult i32 [[K_011_US_2]], 195
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP16]])
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds <225 x double>, ptr [[A]], i64 0, i64 [[TMP15]]
; CHECK-NEXT:    [[MATRIXEXT_US_2:%.*]] = load double, ptr [[TMP17]], align 8
; CHECK-NEXT:    [[MATRIXEXT8_US_2:%.*]] = load double, ptr [[TMP14]], align 8
; CHECK-NEXT:    [[MUL_US_2:%.*]] = fmul double [[MATRIXEXT_US_2]], [[MATRIXEXT8_US_2]]
; CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP15]]
; CHECK-NEXT:    [[MATRIXEXT11_US_2:%.*]] = load double, ptr [[TMP18]], align 8
; CHECK-NEXT:    [[SUB_US_2:%.*]] = fsub double [[MATRIXEXT11_US_2]], [[MUL_US_2]]
; CHECK-NEXT:    store double [[SUB_US_2]], ptr [[TMP18]], align 8
; CHECK-NEXT:    [[INC_US_2]] = add nuw nsw i32 [[K_011_US_2]], 1
; CHECK-NEXT:    [[CMP2_US_2:%.*]] = icmp ult i32 [[INC_US_2]], [[I]]
; CHECK-NEXT:    br i1 [[CMP2_US_2]], label [[FOR_BODY4_US_2]], label [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US_2:%.*]]
; CHECK:       for.cond1.for.cond.cleanup3_crit_edge.us.2:
; CHECK-NEXT:    [[TMP19:%.*]] = add nuw nsw i64 [[CONV6]], 45
; CHECK-NEXT:    [[TMP20:%.*]] = icmp ult i32 [[I]], 180
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP20]])
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP19]]
; CHECK-NEXT:    br label [[FOR_BODY4_US_3:%.*]]
; CHECK:       for.body4.us.3:
; CHECK-NEXT:    [[K_011_US_3:%.*]] = phi i32 [ 0, [[FOR_COND1_FOR_COND_CLEANUP3_CRIT_EDGE_US_2]] ], [ [[INC_US_3:%.*]], [[FOR_BODY4_US_3]] ]
; CHECK-NEXT:    [[CONV_US_3:%.*]] = zext i32 [[K_011_US_3]] to i64
; CHECK-NEXT:    [[TMP22:%.*]] = add nuw nsw i64 [[CONV_US_3]], 45
; CHECK-NEXT:    [[TMP23:%.*]] = icmp ult i32 [[K_011_US_3]], 180
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP23]])
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds <225 x double>, ptr [[A]], i64 0, i64 [[TMP22]]
; CHECK-NEXT:    [[MATRIXEXT_US_3:%.*]] = load double, ptr [[TMP24]], align 8
; CHECK-NEXT:    [[MATRIXEXT8_US_3:%.*]] = load double, ptr [[TMP21]], align 8
; CHECK-NEXT:    [[MUL_US_3:%.*]] = fmul double [[MATRIXEXT_US_3]], [[MATRIXEXT8_US_3]]
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds <225 x double>, ptr [[B]], i64 0, i64 [[TMP22]]
; CHECK-NEXT:    [[MATRIXEXT11_US_3:%.*]] = load double, ptr [[TMP25]], align 8
; CHECK-NEXT:    [[SUB_US_3:%.*]] = fsub double [[MATRIXEXT11_US_3]], [[MUL_US_3]]
; CHECK-NEXT:    store double [[SUB_US_3]], ptr [[TMP25]], align 8
; CHECK-NEXT:    [[INC_US_3]] = add nuw nsw i32 [[K_011_US_3]], 1
; CHECK-NEXT:    [[CMP2_US_3:%.*]] = icmp ult i32 [[INC_US_3]], [[I]]
; CHECK-NEXT:    br i1 [[CMP2_US_3]], label [[FOR_BODY4_US_3]], label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  %i.addr = alloca i32, align 4
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %j = alloca i32, align 4
  %cleanup.dest.slot = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %i, ptr %i.addr, align 4
  store ptr %A, ptr %A.addr, align 8
  store ptr %B, ptr %B.addr, align 8
  call void @llvm.lifetime.start.p0(i64 4, ptr %j) #3
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc12, %entry
  %0 = load i32, ptr %j, align 4
  %cmp = icmp ult i32 %0, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  store i32 2, ptr %cleanup.dest.slot, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %j) #3
  br label %for.end14

for.body:                                         ; preds = %for.cond
  call void @llvm.lifetime.start.p0(i64 4, ptr %k) #3
  store i32 0, ptr %k, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32, ptr %k, align 4
  %2 = load i32, ptr %i.addr, align 4
  %cmp2 = icmp ult i32 %1, %2
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup3

for.cond.cleanup3:                                ; preds = %for.cond1
  store i32 5, ptr %cleanup.dest.slot, align 4
  call void @llvm.lifetime.end.p0(i64 4, ptr %k) #3
  br label %for.end

for.body4:                                        ; preds = %for.cond1
  %3 = load i32, ptr %k, align 4
  %conv = zext i32 %3 to i64
  %4 = load i32, ptr %j, align 4
  %conv5 = zext i32 %4 to i64
  %5 = mul i64 %conv5, 15
  %6 = add i64 %5, %conv
  %7 = icmp ult i64 %6, 225
  call void @llvm.assume(i1 %7)
  %8 = load ptr, ptr %A.addr, align 8
  %9 = load <225 x double>, ptr %8, align 8
  %matrixext = extractelement <225 x double> %9, i64 %6
  %10 = load i32, ptr %i.addr, align 4
  %conv6 = zext i32 %10 to i64
  %11 = load i32, ptr %j, align 4
  %conv7 = zext i32 %11 to i64
  %12 = mul i64 %conv7, 15
  %13 = add i64 %12, %conv6
  %14 = icmp ult i64 %13, 225
  call void @llvm.assume(i1 %14)
  %15 = load ptr, ptr %B.addr, align 8
  %16 = load <225 x double>, ptr %15, align 8
  %matrixext8 = extractelement <225 x double> %16, i64 %13
  %mul = fmul double %matrixext, %matrixext8
  %17 = load ptr, ptr %B.addr, align 8
  %18 = load i32, ptr %k, align 4
  %conv9 = zext i32 %18 to i64
  %19 = load i32, ptr %j, align 4
  %conv10 = zext i32 %19 to i64
  %20 = mul i64 %conv10, 15
  %21 = add i64 %20, %conv9
  %22 = icmp ult i64 %21, 225
  call void @llvm.assume(i1 %22)
  %23 = load <225 x double>, ptr %17, align 8
  %matrixext11 = extractelement <225 x double> %23, i64 %21
  %sub = fsub double %matrixext11, %mul
  %24 = icmp ult i64 %21, 225
  call void @llvm.assume(i1 %24)
  %25 = load <225 x double>, ptr %17, align 8
  %matins = insertelement <225 x double> %25, double %sub, i64 %21
  store <225 x double> %matins, ptr %17, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body4
  %26 = load i32, ptr %k, align 4
  %inc = add i32 %26, 1
  store i32 %inc, ptr %k, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond.cleanup3
  br label %for.inc12

for.inc12:                                        ; preds = %for.end
  %27 = load i32, ptr %j, align 4
  %inc13 = add i32 %27, 1
  store i32 %inc13, ptr %j, align 4
  br label %for.cond

for.end14:                                        ; preds = %for.cond.cleanup
  ret void
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind ssp uwtable mustprogress

define <4 x float> @reverse_hadd_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @reverse_hadd_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[B:%.*]], <4 x float> [[A:%.*]], <4 x i32> <i32 2, i32 0, i32 6, i32 4>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x float> [[B]], <4 x float> [[A]], <4 x i32> <i32 3, i32 1, i32 7, i32 5>
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <4 x float> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <4 x float> [[TMP3]]
;
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  %vecext6 = extractelement <4 x float> %b, i32 0
  %vecext7 = extractelement <4 x float> %b, i32 1
  %add8 = fadd float %vecext6, %vecext7
  %vecinit9 = insertelement <4 x float> %vecinit5, float %add8, i32 2
  %vecext10 = extractelement <4 x float> %b, i32 2
  %vecext11 = extractelement <4 x float> %b, i32 3
  %add12 = fadd float %vecext10, %vecext11
  %vecinit13 = insertelement <4 x float> %vecinit9, float %add12, i32 3
  %shuffle = shufflevector <4 x float> %vecinit13, <4 x float> %a, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x float> %shuffle
}