; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

declare noalias ptr @malloc(i64) nounwind allockind("alloc,uninitialized") allocsize(0)
declare noalias nonnull ptr @_Znwm(i64)  ; new(unsigned long)
declare i32 @__gxx_personality_v0(...)
declare void @__cxa_call_unexpected(ptr)
declare i64 @llvm.objectsize.i64(ptr, i1) nounwind readonly

define i64 @f1(ptr %esc) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:    [[CALL:%.*]] = call dereferenceable_or_null(4) ptr @malloc(i64 4)
; CHECK-NEXT:    store ptr [[CALL]], ptr [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i64 4
;
  %call = call ptr @malloc(i64 4)
  store ptr %call, ptr %esc
  %size = call i64 @llvm.objectsize.i64(ptr %call, i1 false)
  ret i64 %size
}


define i64 @f2(ptr %esc) nounwind uwtable ssp personality ptr @__gxx_personality_v0 {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = invoke noalias dereferenceable(13) ptr @_Znwm(i64 13)
; CHECK-NEXT:    to label [[INVOKE_CONT:%.*]] unwind label [[LPAD:%.*]]
; CHECK:       invoke.cont:
; CHECK-NEXT:    store ptr [[CALL]], ptr [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i64 13
; CHECK:       lpad:
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad { ptr, i32 }
; CHECK-NEXT:    filter [0 x ptr] zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { ptr, i32 } [[TMP0]], 0
; CHECK-NEXT:    tail call void @__cxa_call_unexpected(ptr [[TMP1]]) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    unreachable
;
entry:
  %call = invoke noalias ptr @_Znwm(i64 13)
  to label %invoke.cont unwind label %lpad

invoke.cont:
  store ptr %call, ptr %esc
  %0 = tail call i64 @llvm.objectsize.i64(ptr %call, i1 false)
  ret i64 %0

lpad:
  %1 = landingpad { ptr, i32 }
  filter [0 x ptr] zeroinitializer
  %2 = extractvalue { ptr, i32 } %1, 0
  tail call void @__cxa_call_unexpected(ptr %2) noreturn nounwind
  unreachable
}