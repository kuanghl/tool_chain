// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple x86_64-unknown-unknown -emit-llvm -o - %s | FileCheck %s

typedef double * __attribute__((align_value(64))) aligned_double;

// CHECK-LABEL: @_Z3fooPdS_Rd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[Y_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[Z_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    store ptr [[Y:%.*]], ptr [[Y_ADDR]], align 8
// CHECK-NEXT:    store ptr [[Z:%.*]], ptr [[Z_ADDR]], align 8
// CHECK-NEXT:    ret void
//
void foo(aligned_double x, double * y __attribute__((align_value(32))),
         double & z __attribute__((align_value(128)))) { };

struct ad_struct {
  aligned_double a;
};

// CHECK-LABEL: @_Z3fooR9ad_struct(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[A:%.*]] = getelementptr inbounds [[STRUCT_AD_STRUCT:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[A]], align 8
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[TMP1]], i64 64) ]
// CHECK-NEXT:    ret ptr [[TMP1]]
//
double *foo(ad_struct& x) {

  return x.a;
}

// CHECK-LABEL: @_Z3gooP9ad_struct(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[A:%.*]] = getelementptr inbounds [[STRUCT_AD_STRUCT:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[A]], align 8
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[TMP1]], i64 64) ]
// CHECK-NEXT:    ret ptr [[TMP1]]
//
double *goo(ad_struct *x) {

  return x->a;
}

// CHECK-LABEL: @_Z3barPPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[TMP0]], align 8
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[TMP1]], i64 64) ]
// CHECK-NEXT:    ret ptr [[TMP1]]
//
double *bar(aligned_double *x) {

  return *x;
}

// CHECK-LABEL: @_Z3carRPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[TMP0]], align 8
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[TMP1]], i64 64) ]
// CHECK-NEXT:    ret ptr [[TMP1]]
//
double *car(aligned_double &x) {

  return x;
}

// CHECK-LABEL: @_Z3darPPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds ptr, ptr [[TMP0]], i64 5
// CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[ARRAYIDX]], align 8
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[TMP1]], i64 64) ]
// CHECK-NEXT:    ret ptr [[TMP1]]
//
double *dar(aligned_double *x) {

  return x[5];
}

aligned_double eep();
// CHECK-LABEL: @_Z3retv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[CALL:%.*]] = call noundef ptr @_Z3eepv()
// CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(ptr [[CALL]], i64 64) ]
// CHECK-NEXT:    ret ptr [[CALL]]
//
double *ret() {

  return eep();
}

// CHECK-LABEL: @_Z3no1PPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    ret ptr [[TMP0]]
//
double **no1(aligned_double *x) {
  return x;
}

// CHECK-LABEL: @_Z3no2RPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    ret ptr [[TMP0]]
//
double *&no2(aligned_double &x) {
  return x;
}

// CHECK-LABEL: @_Z3no3RPd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    ret ptr [[TMP0]]
//
double **no3(aligned_double &x) {
  return &x;
}

// CHECK-LABEL: @_Z3no3Pd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = load double, ptr [[TMP0]], align 8
// CHECK-NEXT:    ret double [[TMP1]]
//
double no3(aligned_double x) {
  return *x;
}

// CHECK-LABEL: @_Z3no4Pd(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[X_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[X:%.*]], ptr [[X_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[X_ADDR]], align 8
// CHECK-NEXT:    ret ptr [[TMP0]]
//
double *no4(aligned_double x) {
  return x;
}
