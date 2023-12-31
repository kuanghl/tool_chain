//===-- RISCVInstructionSelector.cpp -----------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// RISC-V.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/RISCVMatInt.h"
#include "RISCVRegisterBankInfo.h"
#include "RISCVSubtarget.h"
#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/GIMatchTableExecutorImpl.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/MachineIRBuilder.h"
#include "llvm/IR/IntrinsicsRISCV.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "riscv-isel"

using namespace llvm;

#define GET_GLOBALISEL_PREDICATE_BITSET
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATE_BITSET

namespace {

class RISCVInstructionSelector : public InstructionSelector {
public:
  RISCVInstructionSelector(const RISCVTargetMachine &TM,
                           const RISCVSubtarget &STI,
                           const RISCVRegisterBankInfo &RBI);

  bool select(MachineInstr &MI) override;
  static const char *getName() { return DEBUG_TYPE; }

private:
  const TargetRegisterClass *
  getRegClassForTypeOnBank(LLT Ty, const RegisterBank &RB) const;

  // tblgen-erated 'select' implementation, used as the initial selector for
  // the patterns that don't require complex C++.
  bool selectImpl(MachineInstr &I, CodeGenCoverage &CoverageInfo) const;

  // Custom selection methods
  bool selectCopy(MachineInstr &MI, MachineRegisterInfo &MRI) const;
  bool selectConstant(MachineInstr &MI, MachineIRBuilder &MIB,
                      MachineRegisterInfo &MRI) const;
  bool selectSExtInreg(MachineInstr &MI, MachineIRBuilder &MIB) const;
  bool selectSelect(MachineInstr &MI, MachineIRBuilder &MIB,
                    MachineRegisterInfo &MRI) const;

  bool earlySelectShift(unsigned Opc, MachineInstr &I, MachineIRBuilder &MIB,
                        const MachineRegisterInfo &MRI);

  ComplexRendererFns selectShiftMask(MachineOperand &Root) const;

  // Custom renderers for tablegen
  void renderNegImm(MachineInstrBuilder &MIB, const MachineInstr &MI,
                    int OpIdx) const;

  const RISCVSubtarget &STI;
  const RISCVInstrInfo &TII;
  const RISCVRegisterInfo &TRI;
  const RISCVRegisterBankInfo &RBI;

  // FIXME: This is necessary because DAGISel uses "Subtarget->" and GlobalISel
  // uses "STI." in the code generated by TableGen. We need to unify the name of
  // Subtarget variable.
  const RISCVSubtarget *Subtarget = &STI;

#define GET_GLOBALISEL_PREDICATES_DECL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_DECL

#define GET_GLOBALISEL_TEMPORARIES_DECL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_DECL
};

} // end anonymous namespace

#define GET_GLOBALISEL_IMPL
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_IMPL

RISCVInstructionSelector::RISCVInstructionSelector(
    const RISCVTargetMachine &TM, const RISCVSubtarget &STI,
    const RISCVRegisterBankInfo &RBI)
    : STI(STI), TII(*STI.getInstrInfo()), TRI(*STI.getRegisterInfo()), RBI(RBI),

#define GET_GLOBALISEL_PREDICATES_INIT
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_INIT
#define GET_GLOBALISEL_TEMPORARIES_INIT
#include "RISCVGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_INIT
{
}

InstructionSelector::ComplexRendererFns
RISCVInstructionSelector::selectShiftMask(MachineOperand &Root) const {
  // TODO: Also check if we are seeing the result of an AND operation which
  // could be bypassed since we only check the lower log2(xlen) bits.
  return {{[=](MachineInstrBuilder &MIB) { MIB.add(Root); }}};
}

// Tablegen doesn't allow us to write SRLIW/SRAIW/SLLIW patterns because the
// immediate Operand has type XLenVT. GlobalISel wants it to be i32.
bool RISCVInstructionSelector::earlySelectShift(
    unsigned Opc, MachineInstr &I, MachineIRBuilder &MIB,
    const MachineRegisterInfo &MRI) {
  if (!Subtarget->is64Bit())
    return false;

  LLT Ty = MRI.getType(I.getOperand(0).getReg());
  if (!Ty.isScalar() || Ty.getSizeInBits() != 32)
    return false;

  std::optional<int64_t> CstVal =
      getIConstantVRegSExtVal(I.getOperand(2).getReg(), MRI);
  if (!CstVal || !isUInt<5>(*CstVal))
    return false;

  auto NewI = MIB.buildInstr(Opc, {I.getOperand(0).getReg()},
                             {I.getOperand(1).getReg()})
                  .addImm(*CstVal);
  I.eraseFromParent();
  return constrainSelectedInstRegOperands(*NewI, TII, TRI, RBI);
}

bool RISCVInstructionSelector::select(MachineInstr &MI) {
  unsigned Opc = MI.getOpcode();
  MachineBasicBlock &MBB = *MI.getParent();
  MachineFunction &MF = *MBB.getParent();
  MachineRegisterInfo &MRI = MF.getRegInfo();
  MachineIRBuilder MIB(MI);

  if (!isPreISelGenericOpcode(Opc) || Opc == TargetOpcode::G_PHI) {
    if (Opc == TargetOpcode::PHI || Opc == TargetOpcode::G_PHI) {
      const Register DefReg = MI.getOperand(0).getReg();
      const LLT DefTy = MRI.getType(DefReg);

      const RegClassOrRegBank &RegClassOrBank =
          MRI.getRegClassOrRegBank(DefReg);

      const TargetRegisterClass *DefRC =
          RegClassOrBank.dyn_cast<const TargetRegisterClass *>();
      if (!DefRC) {
        if (!DefTy.isValid()) {
          LLVM_DEBUG(dbgs() << "PHI operand has no type, not a gvreg?\n");
          return false;
        }

        const RegisterBank &RB = *RegClassOrBank.get<const RegisterBank *>();
        DefRC = getRegClassForTypeOnBank(DefTy, RB);
        if (!DefRC) {
          LLVM_DEBUG(dbgs() << "PHI operand has unexpected size/bank\n");
          return false;
        }
      }

      MI.setDesc(TII.get(TargetOpcode::PHI));
      return RBI.constrainGenericRegister(DefReg, *DefRC, MRI);
    }

    // Certain non-generic instructions also need some special handling.
    if (MI.isCopy())
      return selectCopy(MI, MRI);

    return true;
  }

  switch (Opc) {
  case TargetOpcode::G_ADD: {
    // Tablegen doesn't pick up the ADDIW pattern because i32 isn't a legal
    // type for RV64 in SelectionDAG. Manually select it here.
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    if (Subtarget->is64Bit() && Ty.isScalar() && Ty.getSizeInBits() == 32) {
      std::optional<int64_t> CstVal =
          getIConstantVRegSExtVal(MI.getOperand(2).getReg(), MRI);
      if (CstVal && isInt<12>(*CstVal)) {
        auto NewI = MIB.buildInstr(RISCV::ADDIW, {MI.getOperand(0).getReg()},
                                   {MI.getOperand(1).getReg()})
                        .addImm(*CstVal);
        MI.eraseFromParent();
        return constrainSelectedInstRegOperands(*NewI, TII, TRI, RBI);
      }
    }
    break;
  }
  case TargetOpcode::G_SUB: {
    // Tablegen doesn't pick up the ADDIW pattern because i32 isn't a legal
    // type for RV64 in SelectionDAG. Manually select it here.
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    if (Subtarget->is64Bit() && Ty.isScalar() && Ty.getSizeInBits() == 32) {
      std::optional<int64_t> CstVal =
          getIConstantVRegSExtVal(MI.getOperand(2).getReg(), MRI);
      if (CstVal && ((isInt<12>(*CstVal) && *CstVal != -2048) || *CstVal == 2048)) {
        auto NewI = MIB.buildInstr(RISCV::ADDIW, {MI.getOperand(0).getReg()},
                                   {MI.getOperand(1).getReg()})
                        .addImm(-*CstVal);
        MI.eraseFromParent();
        return constrainSelectedInstRegOperands(*NewI, TII, TRI, RBI);
      }
    }
    break;
  }
  case TargetOpcode::G_ASHR:
    if (earlySelectShift(RISCV::SRAIW, MI, MIB, MRI))
      return true;
    break;
  case TargetOpcode::G_LSHR:
    if (earlySelectShift(RISCV::SRLIW, MI, MIB, MRI))
      return true;
    break;
  case TargetOpcode::G_SHL:
    if (earlySelectShift(RISCV::SLLIW, MI, MIB, MRI))
      return true;
    break;
  }

  if (selectImpl(MI, *CoverageInfo))
    return true;

  switch (Opc) {
  case TargetOpcode::G_ANYEXT:
  case TargetOpcode::G_TRUNC:
    return selectCopy(MI, MRI);
  case TargetOpcode::G_CONSTANT:
    return selectConstant(MI, MIB, MRI);
  case TargetOpcode::G_BRCOND: {
    // TODO: Fold with G_ICMP.
    auto Bcc =
        MIB.buildInstr(RISCV::BNE, {}, {MI.getOperand(0), Register(RISCV::X0)})
            .addMBB(MI.getOperand(1).getMBB());
    MI.eraseFromParent();
    return constrainSelectedInstRegOperands(*Bcc, TII, TRI, RBI);
  }
  case TargetOpcode::G_SEXT_INREG:
    return selectSExtInreg(MI, MIB);
  case TargetOpcode::G_SELECT:
    return selectSelect(MI, MIB, MRI);
  default:
    return false;
  }
}

void RISCVInstructionSelector::renderNegImm(MachineInstrBuilder &MIB,
                                            const MachineInstr &MI,
                                            int OpIdx) const {
  assert(MI.getOpcode() == TargetOpcode::G_CONSTANT && OpIdx == -1 &&
         "Expected G_CONSTANT");
  int64_t CstVal = MI.getOperand(1).getCImm()->getSExtValue();
  MIB.addImm(-CstVal);
}

const TargetRegisterClass *RISCVInstructionSelector::getRegClassForTypeOnBank(
    LLT Ty, const RegisterBank &RB) const {
  if (RB.getID() == RISCV::GPRRegBankID) {
    if (Ty.getSizeInBits() <= 32 || (STI.is64Bit() && Ty.getSizeInBits() == 64))
      return &RISCV::GPRRegClass;
  }

  // TODO: Non-GPR register classes.
  return nullptr;
}

bool RISCVInstructionSelector::selectCopy(MachineInstr &MI,
                                          MachineRegisterInfo &MRI) const {
  Register DstReg = MI.getOperand(0).getReg();

  if (DstReg.isPhysical())
    return true;

  const TargetRegisterClass *DstRC = getRegClassForTypeOnBank(
      MRI.getType(DstReg), *RBI.getRegBank(DstReg, MRI, TRI));
  assert(DstRC &&
         "Register class not available for LLT, register bank combination");

  // No need to constrain SrcReg. It will get constrained when
  // we hit another of its uses or its defs.
  // Copies do not have constraints.
  if (!RBI.constrainGenericRegister(DstReg, *DstRC, MRI)) {
    LLVM_DEBUG(dbgs() << "Failed to constrain " << TII.getName(MI.getOpcode())
                      << " operand\n");
    return false;
  }

  MI.setDesc(TII.get(RISCV::COPY));
  return true;
}

bool RISCVInstructionSelector::selectConstant(MachineInstr &MI,
                                              MachineIRBuilder &MIB,
                                              MachineRegisterInfo &MRI) const {
  assert(MI.getOpcode() == TargetOpcode::G_CONSTANT);
  Register FinalReg = MI.getOperand(0).getReg();
  int64_t Imm = MI.getOperand(1).getCImm()->getSExtValue();

  if (Imm == 0) {
    MI.getOperand(1).ChangeToRegister(RISCV::X0, false);
    RBI.constrainGenericRegister(FinalReg, RISCV::GPRRegClass, MRI);
    MI.setDesc(TII.get(TargetOpcode::COPY));
    return true;
  }

  RISCVMatInt::InstSeq Seq =
      RISCVMatInt::generateInstSeq(Imm, Subtarget->getFeatureBits());
  unsigned NumInsts = Seq.size();
  Register SrcReg = RISCV::X0;

  for (unsigned i = 0; i < NumInsts; i++) {
    Register DstReg = i < NumInsts - 1
                          ? MRI.createVirtualRegister(&RISCV::GPRRegClass)
                          : FinalReg;
    const RISCVMatInt::Inst &I = Seq[i];
    MachineInstr *Result;

    switch (I.getOpndKind()) {
    case RISCVMatInt::Imm:
      // clang-format off
      Result = MIB.buildInstr(I.getOpcode())
                   .addDef(DstReg)
                   .addImm(I.getImm());
      // clang-format on
      break;
    case RISCVMatInt::RegX0:
      Result = MIB.buildInstr(I.getOpcode())
                   .addDef(DstReg)
                   .addReg(SrcReg)
                   .addReg(RISCV::X0);
      break;
    case RISCVMatInt::RegReg:
      Result = MIB.buildInstr(I.getOpcode())
                   .addDef(DstReg)
                   .addReg(SrcReg)
                   .addReg(SrcReg);
      break;
    case RISCVMatInt::RegImm:
      Result = MIB.buildInstr(I.getOpcode())
                   .addDef(DstReg)
                   .addReg(SrcReg)
                   .addImm(I.getImm());
      break;
    }

    if (!constrainSelectedInstRegOperands(*Result, TII, TRI, RBI))
      return false;

    SrcReg = DstReg;
  }

  MI.eraseFromParent();
  return true;
}

bool RISCVInstructionSelector::selectSExtInreg(MachineInstr &MI,
                                               MachineIRBuilder &MIB) const {
  if (!STI.isRV64())
    return false;

  const MachineOperand &Size = MI.getOperand(2);
  // Only Size == 32 (i.e. shift by 32 bits) is acceptable at this point.
  if (!Size.isImm() || Size.getImm() != 32)
    return false;

  const MachineOperand &Src = MI.getOperand(1);
  const MachineOperand &Dst = MI.getOperand(0);
  // addiw rd, rs, 0 (i.e. sext.w rd, rs)
  MachineInstr *NewMI =
      MIB.buildInstr(RISCV::ADDIW, {Dst.getReg()}, {Src.getReg()}).addImm(0U);

  if (!constrainSelectedInstRegOperands(*NewMI, TII, TRI, RBI))
    return false;

  MI.eraseFromParent();
  return true;
}

bool RISCVInstructionSelector::selectSelect(MachineInstr &MI,
                                            MachineIRBuilder &MIB,
                                            MachineRegisterInfo &MRI) const {
  // TODO: Currently we check that the conditional code passed to G_SELECT is
  // not equal to zero; however, in the future, we might want to try and check
  // if the conditional code comes from a G_ICMP. If it does, we can directly
  // use G_ICMP to get the first three input operands of the
  // Select_GPR_Using_CC_GPR. This might be done here, or in the appropriate
  // combiner.
  assert(MI.getOpcode() == TargetOpcode::G_SELECT);
  MachineInstr *Result = MIB.buildInstr(RISCV::Select_GPR_Using_CC_GPR)
                             .addDef(MI.getOperand(0).getReg())
                             .addReg(MI.getOperand(1).getReg())
                             .addReg(RISCV::X0)
                             .addImm(RISCVCC::COND_NE)
                             .addReg(MI.getOperand(2).getReg())
                             .addReg(MI.getOperand(3).getReg());
  MI.eraseFromParent();
  return constrainSelectedInstRegOperands(*Result, TII, TRI, RBI);
}

namespace llvm {
InstructionSelector *
createRISCVInstructionSelector(const RISCVTargetMachine &TM,
                               RISCVSubtarget &Subtarget,
                               RISCVRegisterBankInfo &RBI) {
  return new RISCVInstructionSelector(TM, Subtarget, RBI);
}
} // end namespace llvm
