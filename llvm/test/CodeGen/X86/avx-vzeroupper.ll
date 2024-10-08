; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -x86-use-vzeroupper -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=ALL,VZ
; RUN: llc < %s -x86-use-vzeroupper -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=ALL,VZ
; RUN: llc < %s -x86-use-vzeroupper -mtriple=x86_64-unknown-unknown -mattr=+avx,-vzeroupper | FileCheck %s --check-prefixes=ALL,DISABLE-VZ
; RUN: llc < %s -x86-use-vzeroupper -mtriple=x86_64-unknown-unknown -mcpu=bdver2 | FileCheck %s --check-prefixes=ALL,BDVER2
; RUN: llc < %s -x86-use-vzeroupper -mtriple=x86_64-unknown-unknown -mcpu=btver2 | FileCheck %s --check-prefixes=ALL,BTVER2

declare dso_local i32 @foo()
declare dso_local <4 x float> @do_sse(<4 x float>)
declare dso_local <8 x float> @do_avx(<8 x float>)
declare dso_local <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float>, i8) nounwind readnone
@x = common dso_local global <4 x float> zeroinitializer, align 16
@g = common dso_local global <8 x float> zeroinitializer, align 32

;; Basic checking - don't emit any vzeroupper instruction

define <4 x float> @test00(<4 x float> %a, <4 x float> %b) nounwind {
; ALL-LABEL: test00:
; ALL:       # %bb.0:
; ALL-NEXT:    pushq %rax
; ALL-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; ALL-NEXT:    callq do_sse
; ALL-NEXT:    popq %rax
; ALL-NEXT:    retq
  %add.i = fadd <4 x float> %a, %b
  %call3 = call <4 x float> @do_sse(<4 x float> %add.i) nounwind
  ret <4 x float> %call3
}

;; Check parameter 256-bit parameter passing

define <8 x float> @test01(<4 x float> %a, <4 x float> %b, <8 x float> %c) nounwind {
; VZ-LABEL: test01:
; VZ:       # %bb.0:
; VZ-NEXT:    subq $40, %rsp
; VZ-NEXT:    vmovups %ymm2, (%rsp) # 32-byte Spill
; VZ-NEXT:    vmovaps x(%rip), %xmm0
; VZ-NEXT:    vzeroupper
; VZ-NEXT:    callq do_sse
; VZ-NEXT:    vmovaps %xmm0, x(%rip)
; VZ-NEXT:    callq do_sse
; VZ-NEXT:    vmovaps %xmm0, x(%rip)
; VZ-NEXT:    vmovups (%rsp), %ymm0 # 32-byte Reload
; VZ-NEXT:    addq $40, %rsp
; VZ-NEXT:    retq
;
; DISABLE-VZ-LABEL: test01:
; DISABLE-VZ:       # %bb.0:
; DISABLE-VZ-NEXT:    subq $40, %rsp
; DISABLE-VZ-NEXT:    vmovups %ymm2, (%rsp) # 32-byte Spill
; DISABLE-VZ-NEXT:    vmovaps x(%rip), %xmm0
; DISABLE-VZ-NEXT:    callq do_sse
; DISABLE-VZ-NEXT:    vmovaps %xmm0, x(%rip)
; DISABLE-VZ-NEXT:    callq do_sse
; DISABLE-VZ-NEXT:    vmovaps %xmm0, x(%rip)
; DISABLE-VZ-NEXT:    vmovups (%rsp), %ymm0 # 32-byte Reload
; DISABLE-VZ-NEXT:    addq $40, %rsp
; DISABLE-VZ-NEXT:    retq
;
; BDVER2-LABEL: test01:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    subq $40, %rsp
; BDVER2-NEXT:    vmovaps x(%rip), %xmm0
; BDVER2-NEXT:    vmovups %ymm2, (%rsp) # 32-byte Spill
; BDVER2-NEXT:    vzeroupper
; BDVER2-NEXT:    callq do_sse
; BDVER2-NEXT:    vmovaps %xmm0, x(%rip)
; BDVER2-NEXT:    callq do_sse
; BDVER2-NEXT:    vmovaps %xmm0, x(%rip)
; BDVER2-NEXT:    vmovups (%rsp), %ymm0 # 32-byte Reload
; BDVER2-NEXT:    addq $40, %rsp
; BDVER2-NEXT:    retq
;
; BTVER2-LABEL: test01:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    subq $40, %rsp
; BTVER2-NEXT:    vmovaps x(%rip), %xmm0
; BTVER2-NEXT:    vmovups %ymm2, (%rsp) # 32-byte Spill
; BTVER2-NEXT:    callq do_sse
; BTVER2-NEXT:    vmovaps %xmm0, x(%rip)
; BTVER2-NEXT:    callq do_sse
; BTVER2-NEXT:    vmovaps %xmm0, x(%rip)
; BTVER2-NEXT:    vmovups (%rsp), %ymm0 # 32-byte Reload
; BTVER2-NEXT:    addq $40, %rsp
; BTVER2-NEXT:    retq
  %tmp = load <4 x float>, ptr @x, align 16
  %call = tail call <4 x float> @do_sse(<4 x float> %tmp) nounwind
  store <4 x float> %call, ptr @x, align 16
  %call2 = tail call <4 x float> @do_sse(<4 x float> %call) nounwind
  store <4 x float> %call2, ptr @x, align 16
  ret <8 x float> %c
}

;; Check that vzeroupper is emitted for tail calls.

define <4 x float> @test02(<8 x float> %a, <8 x float> %b) nounwind {
; VZ-LABEL: test02:
; VZ:       # %bb.0:
; VZ-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; VZ-NEXT:    vzeroupper
; VZ-NEXT:    jmp do_sse # TAILCALL
;
; DISABLE-VZ-LABEL: test02:
; DISABLE-VZ:       # %bb.0:
; DISABLE-VZ-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; DISABLE-VZ-NEXT:    jmp do_sse # TAILCALL
;
; BDVER2-LABEL: test02:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; BDVER2-NEXT:    vzeroupper
; BDVER2-NEXT:    jmp do_sse # TAILCALL
;
; BTVER2-LABEL: test02:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; BTVER2-NEXT:    jmp do_sse # TAILCALL
  %add.i = fadd <8 x float> %a, %b
  %add.low = call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %add.i, i8 0)
  %call3 = tail call <4 x float> @do_sse(<4 x float> %add.low) nounwind
  ret <4 x float> %call3
}

;; Test the pass convergence and also that vzeroupper is only issued when necessary,
;; for this function it should be only once

define <4 x float> @test03(<4 x float> %a, <4 x float> %b) nounwind {
; VZ-LABEL: test03:
; VZ:       # %bb.0: # %entry
; VZ-NEXT:    pushq %rbx
; VZ-NEXT:    subq $16, %rsp
; VZ-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; VZ-NEXT:    vmovaps %xmm0, (%rsp) # 16-byte Spill
; VZ-NEXT:    .p2align 4
; VZ-NEXT:  .LBB3_1: # %while.cond
; VZ-NEXT:    # =>This Inner Loop Header: Depth=1
; VZ-NEXT:    callq foo
; VZ-NEXT:    testl %eax, %eax
; VZ-NEXT:    jne .LBB3_1
; VZ-NEXT:  # %bb.2: # %for.body.preheader
; VZ-NEXT:    movl $4, %ebx
; VZ-NEXT:    vmovaps (%rsp), %xmm0 # 16-byte Reload
; VZ-NEXT:    .p2align 4
; VZ-NEXT:  .LBB3_3: # %for.body
; VZ-NEXT:    # =>This Inner Loop Header: Depth=1
; VZ-NEXT:    callq do_sse
; VZ-NEXT:    callq do_sse
; VZ-NEXT:    vmovaps g+16(%rip), %xmm0
; VZ-NEXT:    callq do_sse
; VZ-NEXT:    decl %ebx
; VZ-NEXT:    jne .LBB3_3
; VZ-NEXT:  # %bb.4: # %for.end
; VZ-NEXT:    addq $16, %rsp
; VZ-NEXT:    popq %rbx
; VZ-NEXT:    retq
;
; DISABLE-VZ-LABEL: test03:
; DISABLE-VZ:       # %bb.0: # %entry
; DISABLE-VZ-NEXT:    pushq %rbx
; DISABLE-VZ-NEXT:    subq $16, %rsp
; DISABLE-VZ-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; DISABLE-VZ-NEXT:    vmovaps %xmm0, (%rsp) # 16-byte Spill
; DISABLE-VZ-NEXT:    .p2align 4
; DISABLE-VZ-NEXT:  .LBB3_1: # %while.cond
; DISABLE-VZ-NEXT:    # =>This Inner Loop Header: Depth=1
; DISABLE-VZ-NEXT:    callq foo
; DISABLE-VZ-NEXT:    testl %eax, %eax
; DISABLE-VZ-NEXT:    jne .LBB3_1
; DISABLE-VZ-NEXT:  # %bb.2: # %for.body.preheader
; DISABLE-VZ-NEXT:    movl $4, %ebx
; DISABLE-VZ-NEXT:    vmovaps (%rsp), %xmm0 # 16-byte Reload
; DISABLE-VZ-NEXT:    .p2align 4
; DISABLE-VZ-NEXT:  .LBB3_3: # %for.body
; DISABLE-VZ-NEXT:    # =>This Inner Loop Header: Depth=1
; DISABLE-VZ-NEXT:    callq do_sse
; DISABLE-VZ-NEXT:    callq do_sse
; DISABLE-VZ-NEXT:    vmovaps g+16(%rip), %xmm0
; DISABLE-VZ-NEXT:    callq do_sse
; DISABLE-VZ-NEXT:    decl %ebx
; DISABLE-VZ-NEXT:    jne .LBB3_3
; DISABLE-VZ-NEXT:  # %bb.4: # %for.end
; DISABLE-VZ-NEXT:    addq $16, %rsp
; DISABLE-VZ-NEXT:    popq %rbx
; DISABLE-VZ-NEXT:    retq
;
; BDVER2-LABEL: test03:
; BDVER2:       # %bb.0: # %entry
; BDVER2-NEXT:    pushq %rbx
; BDVER2-NEXT:    subq $16, %rsp
; BDVER2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; BDVER2-NEXT:    vmovaps %xmm0, (%rsp) # 16-byte Spill
; BDVER2-NEXT:    .p2align 4
; BDVER2-NEXT:  .LBB3_1: # %while.cond
; BDVER2-NEXT:    # =>This Inner Loop Header: Depth=1
; BDVER2-NEXT:    callq foo
; BDVER2-NEXT:    testl %eax, %eax
; BDVER2-NEXT:    jne .LBB3_1
; BDVER2-NEXT:  # %bb.2: # %for.body.preheader
; BDVER2-NEXT:    vmovaps (%rsp), %xmm0 # 16-byte Reload
; BDVER2-NEXT:    movl $4, %ebx
; BDVER2-NEXT:    .p2align 4
; BDVER2-NEXT:  .LBB3_3: # %for.body
; BDVER2-NEXT:    # =>This Inner Loop Header: Depth=1
; BDVER2-NEXT:    callq do_sse
; BDVER2-NEXT:    callq do_sse
; BDVER2-NEXT:    vmovaps g+16(%rip), %xmm0
; BDVER2-NEXT:    callq do_sse
; BDVER2-NEXT:    decl %ebx
; BDVER2-NEXT:    jne .LBB3_3
; BDVER2-NEXT:  # %bb.4: # %for.end
; BDVER2-NEXT:    addq $16, %rsp
; BDVER2-NEXT:    popq %rbx
; BDVER2-NEXT:    retq
;
; BTVER2-LABEL: test03:
; BTVER2:       # %bb.0: # %entry
; BTVER2-NEXT:    pushq %rbx
; BTVER2-NEXT:    subq $16, %rsp
; BTVER2-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; BTVER2-NEXT:    vmovaps %xmm0, (%rsp) # 16-byte Spill
; BTVER2-NEXT:    .p2align 4
; BTVER2-NEXT:  .LBB3_1: # %while.cond
; BTVER2-NEXT:    # =>This Inner Loop Header: Depth=1
; BTVER2-NEXT:    callq foo
; BTVER2-NEXT:    testl %eax, %eax
; BTVER2-NEXT:    jne .LBB3_1
; BTVER2-NEXT:  # %bb.2: # %for.body.preheader
; BTVER2-NEXT:    vmovaps (%rsp), %xmm0 # 16-byte Reload
; BTVER2-NEXT:    movl $4, %ebx
; BTVER2-NEXT:    .p2align 4
; BTVER2-NEXT:  .LBB3_3: # %for.body
; BTVER2-NEXT:    # =>This Inner Loop Header: Depth=1
; BTVER2-NEXT:    callq do_sse
; BTVER2-NEXT:    callq do_sse
; BTVER2-NEXT:    vmovaps g+16(%rip), %xmm0
; BTVER2-NEXT:    callq do_sse
; BTVER2-NEXT:    decl %ebx
; BTVER2-NEXT:    jne .LBB3_3
; BTVER2-NEXT:  # %bb.4: # %for.end
; BTVER2-NEXT:    addq $16, %rsp
; BTVER2-NEXT:    popq %rbx
; BTVER2-NEXT:    retq
entry:
  %add.i = fadd <4 x float> %a, %b
  br label %while.cond

while.cond:
  %call = tail call i32 @foo()
  %tobool = icmp eq i32 %call, 0
  br i1 %tobool, label %for.body, label %while.cond

for.body:
  %i.018 = phi i32 [ 0, %while.cond ], [ %1, %for.body ]
  %c.017 = phi <4 x float> [ %add.i, %while.cond ], [ %call14, %for.body ]
  %call5 = tail call <4 x float> @do_sse(<4 x float> %c.017) nounwind
  %call7 = tail call <4 x float> @do_sse(<4 x float> %call5) nounwind
  %tmp11 = load <8 x float>, ptr @g, align 32
  %0 = tail call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %tmp11, i8 1) nounwind
  %call14 = tail call <4 x float> @do_sse(<4 x float> %0) nounwind
  %1 = add nsw i32 %i.018, 1
  %exitcond = icmp eq i32 %1, 4
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret <4 x float> %call14
}

;; Check that we also perform vzeroupper when we return from a function.

define <4 x float> @test04(<4 x float> %a, <4 x float> %b) nounwind {
; VZ-LABEL: test04:
; VZ:       # %bb.0:
; VZ-NEXT:    pushq %rax
; VZ-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; VZ-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; VZ-NEXT:    callq do_avx
; VZ-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; VZ-NEXT:    popq %rax
; VZ-NEXT:    vzeroupper
; VZ-NEXT:    retq
;
; DISABLE-VZ-LABEL: test04:
; DISABLE-VZ:       # %bb.0:
; DISABLE-VZ-NEXT:    pushq %rax
; DISABLE-VZ-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; DISABLE-VZ-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; DISABLE-VZ-NEXT:    callq do_avx
; DISABLE-VZ-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; DISABLE-VZ-NEXT:    popq %rax
; DISABLE-VZ-NEXT:    retq
;
; BDVER2-LABEL: test04:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    pushq %rax
; BDVER2-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; BDVER2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; BDVER2-NEXT:    callq do_avx
; BDVER2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; BDVER2-NEXT:    popq %rax
; BDVER2-NEXT:    vzeroupper
; BDVER2-NEXT:    retq
;
; BTVER2-LABEL: test04:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    pushq %rax
; BTVER2-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; BTVER2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; BTVER2-NEXT:    callq do_avx
; BTVER2-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; BTVER2-NEXT:    popq %rax
; BTVER2-NEXT:    retq
  %shuf = shufflevector <4 x float> %a, <4 x float> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %call = call <8 x float> @do_avx(<8 x float> %shuf) nounwind
  %shuf2 = shufflevector <8 x float> %call, <8 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %shuf2
}

