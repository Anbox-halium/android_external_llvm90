; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-SSE,CHECK-SSE2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-SSE,CHECK-SSE41
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX1
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512vl < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX512VL

; Tests BuildUREMEqFold for 4 x i32 splat vectors with odd divisor.
; See urem-seteq.ll for justification behind constants emitted.
define <4 x i32> @test_urem_odd_vec_i32(<4 x i32> %X) nounwind readnone {
; CHECK-SSE2-LABEL: test_urem_odd_vec_i32:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psrld $2, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [5,5,5,5]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_urem_odd_vec_i32:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-SSE41-NEXT:    pmuludq %xmm2, %xmm1
; CHECK-SSE41-NEXT:    pmuludq %xmm0, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    psrld $2, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_odd_vec_i32:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX1-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_odd_vec_i32:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX2-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX2-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [5,5,5,5]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_odd_vec_i32:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 5, i32 5, i32 5, i32 5>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Like test_urem_odd_vec_i32, but with 4 x i16 vectors.
define <4 x i16> @test_urem_odd_vec_i16(<4 x i16> %X) nounwind readnone {
; CHECK-SSE2-LABEL: test_urem_odd_vec_i16:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psrld $2, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [5,5,5,5]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_urem_odd_vec_i16:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm3 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-SSE41-NEXT:    pmuludq %xmm3, %xmm2
; CHECK-SSE41-NEXT:    pmuludq %xmm0, %xmm3
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1],xmm2[2,3],xmm3[4,5],xmm2[6,7]
; CHECK-SSE41-NEXT:    psrld $2, %xmm3
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm3
; CHECK-SSE41-NEXT:    psubd %xmm3, %xmm0
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_odd_vec_i16:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1],xmm2[2,3],xmm3[4,5],xmm2[6,7]
; CHECK-AVX1-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_odd_vec_i16:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX2-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm2 = xmm3[0],xmm2[1],xmm3[2],xmm2[3]
; CHECK-AVX2-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [5,5,5,5]
; CHECK-AVX2-NEXT:    vpmulld %xmm3, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_odd_vec_i16:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [3435973837,3435973837,3435973837,3435973837]
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm2 = xmm3[0],xmm2[1],xmm3[2],xmm2[3]
; CHECK-AVX512VL-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i16> %X, <i16 5, i16 5, i16 5, i16 5>
  %cmp = icmp eq <4 x i16> %urem, <i16 0, i16 0, i16 0, i16 0>
  %ret = zext <4 x i1> %cmp to <4 x i16>
  ret <4 x i16> %ret
}

; Tests BuildUREMEqFold for 4 x i32 splat vectors with even divisor.
; The expected behavior is that the fold is _not_ applied
; because it requires a ROTR in the even case, which has to be expanded.
define <4 x i32> @test_urem_even_vec_i32(<4 x i32> %X) nounwind readnone {
; CHECK-SSE2-LABEL: test_urem_even_vec_i32:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm1
; CHECK-SSE2-NEXT:    psrld $1, %xmm1
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; CHECK-SSE2-NEXT:    psrld $2, %xmm1
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [14,14,14,14]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; CHECK-SSE2-NEXT:    psubd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_urem_even_vec_i32:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    movdqa %xmm0, %xmm1
; CHECK-SSE41-NEXT:    psrld $1, %xmm1
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm3 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-SSE41-NEXT:    pmuludq %xmm3, %xmm2
; CHECK-SSE41-NEXT:    pmuludq %xmm3, %xmm1
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; CHECK-SSE41-NEXT:    psrld $2, %xmm1
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm1
; CHECK-SSE41-NEXT:    psubd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_even_vec_i32:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpsrld $1, %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpmuludq %xmm3, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; CHECK-AVX1-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_even_vec_i32:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpsrld $1, %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX2-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpmuludq %xmm3, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; CHECK-AVX2-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [14,14,14,14]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_even_vec_i32:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpsrld $1, %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm3, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; CHECK-AVX512VL-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 14, i32 14, i32 14, i32 14>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Like test_urem_even_vec_i32, but with 4 x i16 vectors.
define <4 x i16> @test_urem_even_vec_i16(<4 x i16> %X) nounwind readnone {
; CHECK-SSE2-LABEL: test_urem_even_vec_i16:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm1
; CHECK-SSE2-NEXT:    psrld $1, %xmm1
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; CHECK-SSE2-NEXT:    psrld $2, %xmm1
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [14,14,14,14]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm2, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; CHECK-SSE2-NEXT:    psubd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_urem_even_vec_i16:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-SSE41-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE41-NEXT:    psrld $1, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm4 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-SSE41-NEXT:    pmuludq %xmm4, %xmm3
; CHECK-SSE41-NEXT:    pmuludq %xmm4, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm3[2,3],xmm2[4,5],xmm3[6,7]
; CHECK-SSE41-NEXT:    psrld $2, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_even_vec_i16:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX1-NEXT:    vpsrld $1, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX1-NEXT:    vpmuludq %xmm4, %xmm3, %xmm3
; CHECK-AVX1-NEXT:    vpmuludq %xmm4, %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm3[2,3],xmm2[4,5],xmm3[6,7]
; CHECK-AVX1-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm2, %xmm2
; CHECK-AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_even_vec_i16:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX2-NEXT:    vpsrld $1, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm4 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX2-NEXT:    vpmuludq %xmm4, %xmm3, %xmm3
; CHECK-AVX2-NEXT:    vpmuludq %xmm4, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm3[1],xmm2[2],xmm3[3]
; CHECK-AVX2-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [14,14,14,14]
; CHECK-AVX2-NEXT:    vpmulld %xmm3, %xmm2, %xmm2
; CHECK-AVX2-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_even_vec_i16:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; CHECK-AVX512VL-NEXT:    vpsrld $1, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm3 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm4 = [2454267027,2454267027,2454267027,2454267027]
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm4, %xmm3, %xmm3
; CHECK-AVX512VL-NEXT:    vpmuludq %xmm4, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm3[1],xmm2[2],xmm3[3]
; CHECK-AVX512VL-NEXT:    vpsrld $2, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm2, %xmm2
; CHECK-AVX512VL-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i16> %X, <i16 14, i16 14, i16 14, i16 14>
  %cmp = icmp eq <4 x i16> %urem, <i16 0, i16 0, i16 0, i16 0>
  %ret = zext <4 x i1> %cmp to <4 x i16>
  ret <4 x i16> %ret
}

; We should not proceed with this fold if the divisor is 1 or -1
define <4 x i32> @test_urem_one_vec(<4 x i32> %X) nounwind readnone {
; CHECK-SSE-LABEL: test_urem_one_vec:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_one_vec:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vmovaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_one_vec:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_one_vec:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; BuildUREMEqFold does not work when the only odd factor of the divisor is 1.
; This ensures we don't touch powers of two.
define <4 x i32> @test_urem_pow2_vec(<4 x i32> %X) nounwind readnone {
; CHECK-SSE-LABEL: test_urem_pow2_vec:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE-NEXT:    psrld $31, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_urem_pow2_vec:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_urem_pow2_vec:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [15,15,15,15]
; CHECK-AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_urem_pow2_vec:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpandd {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %urem = urem <4 x i32> %X, <i32 16, i32 16, i32 16, i32 16>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}