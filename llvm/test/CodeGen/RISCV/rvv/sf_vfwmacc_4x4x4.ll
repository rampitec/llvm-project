; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+v,+zvfbfmin,+xsfvfwmaccqqq \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+v,+zvfbfmin,+xsfvfwmaccqqq \
; RUN:   -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK

declare <vscale x 1 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv1f32.nxv4bf16.nxv1bf16.iXLen(
  <vscale x 1 x float>,
  <vscale x 4 x bfloat>,
  <vscale x 1 x bfloat>,
  iXLen, iXLen);

define <vscale x 1 x float> @intrinsic_vfwmacc_4x4x4_tu_f32mf2(<vscale x 1 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 1 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_tu_f32mf2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, tu, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv1f32.nxv4bf16.nxv1bf16.iXLen(
    <vscale x 1 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 1 x bfloat> %2,
    iXLen %3, iXLen 2)

  ret <vscale x 1 x float> %a
}

define <vscale x 1 x float> @intrinsic_vfwmacc_4x4x4_ta_f32mf2(<vscale x 1 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 1 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_ta_f32mf2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv1f32.nxv4bf16.nxv1bf16.iXLen(
    <vscale x 1 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 1 x bfloat> %2,
    iXLen %3, iXLen 3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv2f32.nxv4bf16.nxv2bf16.iXLen(
  <vscale x 2 x float>,
  <vscale x 4 x bfloat>,
  <vscale x 2 x bfloat>,
  iXLen, iXLen);

define <vscale x 2 x float> @intrinsic_vfwmacc_4x4x4_tu_f32m1(<vscale x 2 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 2 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_tu_f32m1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, tu, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv2f32.nxv4bf16.nxv2bf16.iXLen(
    <vscale x 2 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 2 x bfloat> %2,
    iXLen %3, iXLen 2)

  ret <vscale x 2 x float> %a
}

define <vscale x 2 x float> @intrinsic_vfwmacc_4x4x4_ta_f32m1(<vscale x 2 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 2 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_ta_f32m1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v9, v10
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv2f32.nxv4bf16.nxv2bf16.iXLen(
    <vscale x 2 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 2 x bfloat> %2,
    iXLen %3, iXLen 3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv4f32.nxv4bf16.nxv4bf16.iXLen(
  <vscale x 4 x float>,
  <vscale x 4 x bfloat>,
  <vscale x 4 x bfloat>,
  iXLen, iXLen);

define <vscale x 4 x float> @intrinsic_vfwmacc_4x4x4_tu_f32m2(<vscale x 4 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 4 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_tu_f32m2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v10, v11
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv4f32.nxv4bf16.nxv4bf16.iXLen(
    <vscale x 4 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 4 x bfloat> %2,
    iXLen %3, iXLen 2)

  ret <vscale x 4 x float> %a
}

define <vscale x 4 x float> @intrinsic_vfwmacc_4x4x4_ta_f32m2(<vscale x 4 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 4 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_ta_f32m2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v10, v11
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv4f32.nxv4bf16.nxv4bf16.iXLen(
    <vscale x 4 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 4 x bfloat> %2,
    iXLen %3, iXLen 3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv8f32.nxv4bf16.nxv8bf16.iXLen(
  <vscale x 8 x float>,
  <vscale x 4 x bfloat>,
  <vscale x 8 x bfloat>,
  iXLen, iXLen);

define <vscale x 8 x float> @intrinsic_vfwmacc_4x4x4_tu_f32m4(<vscale x 8 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 8 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_tu_f32m4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, tu, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v12, v14
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv8f32.nxv4bf16.nxv8bf16.iXLen(
    <vscale x 8 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 8 x bfloat> %2,
    iXLen %3, iXLen 2)

  ret <vscale x 8 x float> %a
}

define <vscale x 8 x float> @intrinsic_vfwmacc_4x4x4_ta_f32m4(<vscale x 8 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 8 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_ta_f32m4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v12, v14
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv8f32.nxv4bf16.nxv8bf16.iXLen(
    <vscale x 8 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 8 x bfloat> %2,
    iXLen %3, iXLen 3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv16f32.nxv4bf16.nxv16bf16.iXLen(
  <vscale x 16 x float>,
  <vscale x 4 x bfloat>,
  <vscale x 16 x bfloat>,
  iXLen, iXLen);

define <vscale x 16 x float> @intrinsic_vfwmacc_4x4x4_tu_f32m8(<vscale x 16 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 16 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_tu_f32m8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v16, v20
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv16f32.nxv4bf16.nxv16bf16.iXLen(
    <vscale x 16 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 16 x bfloat> %2,
    iXLen %3, iXLen 2)

  ret <vscale x 16 x float> %a
}

define <vscale x 16 x float> @intrinsic_vfwmacc_4x4x4_ta_f32m8(<vscale x 16 x float> %0, <vscale x 4 x bfloat> %1, <vscale x 16 x bfloat> %2, iXLen %3) nounwind {
; CHECK-LABEL: intrinsic_vfwmacc_4x4x4_ta_f32m8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, ma
; CHECK-NEXT:    sf.vfwmacc.4x4x4 v8, v16, v20
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.sf.vfwmacc.4x4x4.nxv16f32.nxv4bf16.nxv16bf16.iXLen(
    <vscale x 16 x float> %0,
    <vscale x 4 x bfloat> %1,
    <vscale x 16 x bfloat> %2,
    iXLen %3, iXLen 3)

  ret <vscale x 16 x float> %a
}
