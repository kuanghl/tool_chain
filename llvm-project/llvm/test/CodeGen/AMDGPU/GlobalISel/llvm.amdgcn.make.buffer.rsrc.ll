; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py UTC_ARGS: --version 2
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 -verify-machineinstrs -stop-after=instruction-select < %s | FileCheck %s

define amdgpu_ps ptr addrspace(8) @basic_raw_buffer(ptr inreg %p) {
  ; CHECK-LABEL: name: basic_raw_buffer
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 5678
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 1234
  ; CHECK-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_2]], implicit-def dead $scc
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY2]], implicit $exec
  ; CHECK-NEXT:   $sgpr0 = COPY [[V_READFIRSTLANE_B32_]]
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[S_AND_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY3]], implicit $exec
  ; CHECK-NEXT:   $sgpr1 = COPY [[V_READFIRSTLANE_B32_1]]
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY4]], implicit $exec
  ; CHECK-NEXT:   $sgpr2 = COPY [[V_READFIRSTLANE_B32_2]]
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; CHECK-NEXT:   $sgpr3 = COPY [[V_READFIRSTLANE_B32_3]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $sgpr0, implicit $sgpr1, implicit $sgpr2, implicit $sgpr3
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 0, i32 1234, i32 5678)
  ret ptr addrspace(8) %rsrc
}

define amdgpu_ps float @read_raw_buffer(ptr addrspace(1) inreg %p) {
  ; CHECK-LABEL: name: read_raw_buffer
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[S_AND_B32_]], %subreg.sub1, [[S_MOV_B32_]], %subreg.sub2, [[S_MOV_B32_]], %subreg.sub3
  ; CHECK-NEXT:   [[BUFFER_LOAD_DWORD_OFFSET:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_OFFSET [[REG_SEQUENCE]], [[S_MOV_B32_]], 4, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_OFFSET]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) %p, i16 0, i32 0, i32 0)
  %loaded = call float @llvm.amdgcn.raw.ptr.buffer.load(ptr addrspace(8) %rsrc, i32 4, i32 0, i32 0)
  ret float %loaded
}

define amdgpu_ps ptr addrspace(8) @basic_struct_buffer(ptr inreg %p) {
  ; CHECK-LABEL: name: basic_struct_buffer
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 5678
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 1234
  ; CHECK-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_2]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_MOV_B32_3:%[0-9]+]]:sreg_32 = S_MOV_B32 262144
  ; CHECK-NEXT:   [[S_OR_B32_:%[0-9]+]]:sreg_32 = S_OR_B32 [[S_AND_B32_]], [[S_MOV_B32_3]], implicit-def dead $scc
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY2]], implicit $exec
  ; CHECK-NEXT:   $sgpr0 = COPY [[V_READFIRSTLANE_B32_]]
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[S_OR_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY3]], implicit $exec
  ; CHECK-NEXT:   $sgpr1 = COPY [[V_READFIRSTLANE_B32_1]]
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY4]], implicit $exec
  ; CHECK-NEXT:   $sgpr2 = COPY [[V_READFIRSTLANE_B32_2]]
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; CHECK-NEXT:   $sgpr3 = COPY [[V_READFIRSTLANE_B32_3]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $sgpr0, implicit $sgpr1, implicit $sgpr2, implicit $sgpr3
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 4, i32 1234, i32 5678)
  ret ptr addrspace(8) %rsrc
}

define amdgpu_ps ptr addrspace(8) @variable_top_half(ptr inreg %p, i32 inreg %numVals, i32 inreg %flags) {
  ; CHECK-LABEL: name: variable_top_half
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1, $sgpr2, $sgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 262144
  ; CHECK-NEXT:   [[S_OR_B32_:%[0-9]+]]:sreg_32 = S_OR_B32 [[S_AND_B32_]], [[S_MOV_B32_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY4]], implicit $exec
  ; CHECK-NEXT:   $sgpr0 = COPY [[V_READFIRSTLANE_B32_]]
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[S_OR_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; CHECK-NEXT:   $sgpr1 = COPY [[V_READFIRSTLANE_B32_1]]
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY2]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; CHECK-NEXT:   $sgpr2 = COPY [[V_READFIRSTLANE_B32_2]]
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY3]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY7]], implicit $exec
  ; CHECK-NEXT:   $sgpr3 = COPY [[V_READFIRSTLANE_B32_3]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $sgpr0, implicit $sgpr1, implicit $sgpr2, implicit $sgpr3
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 4, i32 %numVals, i32 %flags)
  ret ptr addrspace(8) %rsrc
}

define amdgpu_ps ptr addrspace(8) @general_case(ptr inreg %p, i16 inreg %stride, i32 inreg %numVals, i32 inreg %flags) {
  ; CHECK-LABEL: name: general_case
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1, $sgpr2, $sgpr3, $sgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; CHECK-NEXT:   [[S_LSHL_B32_:%[0-9]+]]:sreg_32 = S_LSHL_B32 [[COPY2]], [[S_MOV_B32_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_OR_B32_:%[0-9]+]]:sreg_32 = S_OR_B32 [[S_AND_B32_]], [[S_LSHL_B32_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; CHECK-NEXT:   $sgpr0 = COPY [[V_READFIRSTLANE_B32_]]
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[S_OR_B32_]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; CHECK-NEXT:   $sgpr1 = COPY [[V_READFIRSTLANE_B32_1]]
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY3]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY7]], implicit $exec
  ; CHECK-NEXT:   $sgpr2 = COPY [[V_READFIRSTLANE_B32_2]]
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY8]], implicit $exec
  ; CHECK-NEXT:   $sgpr3 = COPY [[V_READFIRSTLANE_B32_3]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $sgpr0, implicit $sgpr1, implicit $sgpr2, implicit $sgpr3
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 %stride, i32 %numVals, i32 %flags)
  ret ptr addrspace(8) %rsrc
}

define amdgpu_ps float @general_case_load(ptr inreg %p, i16 inreg %stride, i32 inreg %numVals, i32 inreg %flags) {
  ; CHECK-LABEL: name: general_case_load
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr0, $sgpr1, $sgpr2, $sgpr3, $sgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[COPY1]], [[S_MOV_B32_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; CHECK-NEXT:   [[S_LSHL_B32_:%[0-9]+]]:sreg_32 = S_LSHL_B32 [[COPY2]], [[S_MOV_B32_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_OR_B32_:%[0-9]+]]:sreg_32 = S_OR_B32 [[S_AND_B32_]], [[S_LSHL_B32_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[S_OR_B32_]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_2]]
  ; CHECK-NEXT:   [[BUFFER_LOAD_DWORD_IDXEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_IDXEN [[COPY5]], [[REG_SEQUENCE]], [[S_MOV_B32_2]], 0, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_IDXEN]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 %stride, i32 %numVals, i32 %flags)
  %value = call float @llvm.amdgcn.struct.ptr.buffer.load(ptr addrspace(8) %rsrc, i32 0, i32 0, i32 0, i32 0)
  ret float %value
}

; None of the components are uniform due to the lack of an inreg
define amdgpu_ps float @general_case_load_with_waterfall(ptr %p, i16 %stride, i32 %numVals, i32 %flags) {
  ; CHECK-LABEL: name: general_case_load_with_waterfall
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x80000000)
  ; CHECK-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; CHECK-NEXT:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY6]], [[COPY2]], implicit $exec
  ; CHECK-NEXT:   [[V_AND_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_OR_B32_e64 [[COPY1]], [[COPY5]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; CHECK-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[V_AND_OR_B32_e64_]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_2]]
  ; CHECK-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[V_AND_OR_B32_e64_]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY3]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY4]], implicit $exec
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub0_sub1
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub2_sub3
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY10]], [[COPY8]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY11]], [[COPY9]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_]], [[V_CMP_EQ_U64_e64_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3:
  ; CHECK-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[BUFFER_LOAD_DWORD_IDXEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_IDXEN [[COPY7]], [[REG_SEQUENCE1]], [[S_MOV_B32_2]], 0, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.4:
  ; CHECK-NEXT:   successors: %bb.5(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.5:
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_IDXEN]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %rsrc = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr %p, i16 %stride, i32 %numVals, i32 %flags)
  %value = call float @llvm.amdgcn.struct.ptr.buffer.load(ptr addrspace(8) %rsrc, i32 0, i32 0, i32 0, i32 0)
  ret float %value
}

declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p0(ptr nocapture readnone, i16, i32, i32)
declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) nocapture readnone, i16, i32, i32)
declare float @llvm.amdgcn.raw.ptr.buffer.load(ptr addrspace(8) nocapture readonly, i32, i32, i32 immarg)
declare float @llvm.amdgcn.struct.ptr.buffer.load(ptr addrspace(8) nocapture readonly, i32, i32, i32, i32 immarg)