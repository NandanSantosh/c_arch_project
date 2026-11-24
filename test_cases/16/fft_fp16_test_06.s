# Packed-fp16 radix-2 DIT FFT, N = 16
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0xB857B4E8    # x[0]
    .word 0x3AE5BBCD    # x[1]
    .word 0xBBFDB5AE    # x[2]
    .word 0x2899B8A5    # x[3]
    .word 0xB61D3835    # x[4]
    .word 0xBADFB995    # x[5]
    .word 0xB62939F6    # x[6]
    .word 0x3BBEB745    # x[7]
    .word 0x384E37A2    # x[8]
    .word 0xBB5C3783    # x[9]
    .word 0x3BD33888    # x[10]
    .word 0xBA893BCA    # x[11]
    .word 0x3A71337D    # x[12]
    .word 0xB3D538C7    # x[13]
    .word 0xB22EB4A5    # x[14]
    .word 0xB1B72A60    # x[15]

# Per-stage twiddle tables, len = 4, 8, ..., N, concatenated:
# W_len^j = cos(-2*pi*j/len) + i*sin(-2*pi*j/len), j = 0 .. len/2-1
tw_table:
    # len = 4
    .word 0x00003C00    # W4^0 = 1.000000 +0.000000i
    .word 0xBC000000    # W4^1 = 0.000000 -1.000000i
    # len = 8
    .word 0x00003C00    # W8^0 = 1.000000 +0.000000i
    .word 0xB9A839A8    # W8^1 = 0.707107 -0.707107i
    .word 0xBC000000    # W8^2 = 0.000000 -1.000000i
    .word 0xB9A8B9A8    # W8^3 = -0.707107 -0.707107i
    # len = 16
    .word 0x00003C00    # W16^0 = 1.000000 +0.000000i
    .word 0xB61F3B64    # W16^1 = 0.923880 -0.382683i
    .word 0xB9A839A8    # W16^2 = 0.707107 -0.707107i
    .word 0xBB64361F    # W16^3 = 0.382683 -0.923880i
    .word 0xBC000000    # W16^4 = 0.000000 -1.000000i
    .word 0xBB64B61F    # W16^5 = -0.382683 -0.923880i
    .word 0xB9A8B9A8    # W16^6 = -0.707107 -0.707107i
    .word 0xB61FBB64    # W16^7 = -0.923880 -0.382683i

# 32-byte scratch for the len-2 lane shuffle: E @0, O @8, S @16, D @24
scratch: .word 0, 0, 0, 0, 0, 0, 0, 0

.text
main:
    la   s0, x
    li   s1, 16

# ============================================================
# BIT REVERSAL (one complex sample = one 32-bit word)
# ============================================================
    li   t0, 1
    li   t1, 0
    srli t2, s1, 1            # mask = N/2
bitrev_i:
    bge  t0, s1, bitrev_done
bitrev_carry:
    blt  t1, t2, bitrev_carry_done
    sub  t1, t1, t2
    srli t2, t2, 1
    j    bitrev_carry
bitrev_carry_done:
    add  t1, t1, t2
    blt  t0, t1, bitrev_swap
    j    bitrev_next
bitrev_swap:
    slli t3, t0, 2
    add  t3, s0, t3
    slli t4, t1, 2
    add  t4, s0, t4
    lw   t5, 0(t3)
    lw   t6, 0(t4)
    sw   t6, 0(t3)
    sw   t5, 0(t4)
bitrev_next:
    addi t0, t0, 1
    srli t2, s1, 1
    j    bitrev_i

bitrev_done:
# ============================================================
# STAGE len = 2 (W = 1). Partners share a register, so regroup
# via scratch: E=(x0,x2), O=(x1,x3) -> S=E+O=(y0,y2), D=E-O=(y1,y3)
# ============================================================
    la   a7, scratch
    li   t1, 0
len2_loop:
    bge  t1, s1, len2_done
    slli a0, t1, 2
    add  a0, s0, a0
    lw   t2, 0(a0)             # x0
    lw   t3, 4(a0)             # x1
    lw   t4, 8(a0)             # x2
    lw   t5, 12(a0)            # x3
    sw   t2, 0(a7)             # E = (x0, x2)
    sw   t4, 4(a7)
    sw   t3, 8(a7)             # O = (x1, x3)
    sw   t5, 12(a7)
    vld    v0, 0(a7)
    vld    v1, 8(a7)
    vadd.h v2, v0, v1
    vsub.h v3, v0, v1
    vsd    v2, 16(a7)
    vsd    v3, 24(a7)
    lw   t2, 16(a7)            # y0
    lw   t3, 20(a7)            # y2
    lw   t4, 24(a7)            # y1
    lw   t5, 28(a7)            # y3
    sw   t2, 0(a0)
    sw   t4, 4(a0)
    sw   t3, 8(a0)
    sw   t5, 12(a0)
    addi t1, t1, 4
    j    len2_loop

len2_done:
    li   t0, 4                 # stage length
    la   s2, tw_table

stage_loop:
    blt  s1, t0, fft_done
    srli t3, t0, 1             # half
    li   t1, 0
    li   t4, 8
    blt  t3, t4, mid_stage     # half = 2 or 4

# ============================================================
# half >= 8: 8 butterflies per iteration (4 regs x 2 complex)
# ============================================================
block_loop8:
    bge  t1, s1, stage_done
    li   t2, 0
butterfly_loop8:
    bge  t2, t3, butterfly_done8
    add  a0, t1, t2            # a0 = &x[i+j]
    slli a0, a0, 2
    add  a0, s0, a0
    slli a1, t3, 2             # a1 = &x[i+j+half]
    add  a1, a0, a1
    slli a2, t2, 2             # a2 = &W_len[j]
    add  a2, s2, a2

    vld  v0,  0(a0)
    vld  v1,  8(a0)
    vld  v2, 16(a0)
    vld  v3, 24(a0)
    vld  v4,  0(a1)
    vld  v5,  8(a1)
    vld  v6, 16(a1)
    vld  v7, 24(a1)
    vld  v8,  0(a2)
    vld  v9,  8(a2)
    vld  v10, 16(a2)
    vld  v11, 24(a2)

    vcmpl.h v12, v4, v8       # T = B * W
    vcmpl.h v13, v5, v9
    vcmpl.h v14, v6, v10
    vcmpl.h v15, v7, v11

    vadd.h v16, v0, v12        # A' = A + T
    vadd.h v17, v1, v13
    vadd.h v18, v2, v14
    vadd.h v19, v3, v15
    vsub.h v20, v0, v12        # B' = A - T
    vsub.h v21, v1, v13
    vsub.h v22, v2, v14
    vsub.h v23, v3, v15

    vsd  v16,  0(a0)
    vsd  v17,  8(a0)
    vsd  v18, 16(a0)
    vsd  v19, 24(a0)
    vsd  v20,  0(a1)
    vsd  v21,  8(a1)
    vsd  v22, 16(a1)
    vsd  v23, 24(a1)

    addi t2, t2, 8
    j    butterfly_loop8
butterfly_done8:
    add  t1, t1, t0
    j    block_loop8

# ============================================================
# half = 2 or 4 (len 4, 8): 2 butterflies per iteration
# ============================================================
mid_stage:
mid_block:
    bge  t1, s1, stage_done
    li   t2, 0
mid_butterfly:
    bge  t2, t3, mid_butterfly_done
    add  a0, t1, t2
    slli a0, a0, 2
    add  a0, s0, a0
    slli a1, t3, 2
    add  a1, a0, a1
    slli a2, t2, 2
    add  a2, s2, a2
    vld      v0, 0(a0)
    vld      v1, 0(a1)
    vld      v8, 0(a2)
    vcmpl.h v4, v1, v8
    vadd.h   v5, v0, v4
    vsub.h   v6, v0, v4
    vsd      v5, 0(a0)
    vsd      v6, 0(a1)
    addi t2, t2, 2
    j    mid_butterfly
mid_butterfly_done:
    add  t1, t1, t0
    j    mid_block

stage_done:
    slli t4, t3, 2             # skip half*4 bytes of twiddles
    add  s2, s2, t4
    slli t0, t0, 1
    j    stage_loop

fft_done:
    ebreak
