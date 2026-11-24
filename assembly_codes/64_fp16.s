# Packed-fp16 radix-2 DIT FFT, N = 64
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcompl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0x2E663C00    # x[0] = 1.0 + 0.1i
    .word 0x32664000    # x[1] = 2.0 + 0.2i
    .word 0x34CD4200    # x[2] = 3.0 + 0.3i
    .word 0x36664400    # x[3] = 4.0 + 0.4i
    .word 0x38004500    # x[4] = 5.0 + 0.5i
    .word 0x38CD4600    # x[5] = 6.0 + 0.6i
    .word 0x399A4700    # x[6] = 7.0 + 0.7i
    .word 0x2E664800    # x[7] = 8.0 + 0.1i
    .word 0x32664880    # x[8] = 9.0 + 0.2i
    .word 0x34CD4900    # x[9] = 10.0 + 0.3i
    .word 0x36664980    # x[10] = 11.0 + 0.4i
    .word 0x38004A00    # x[11] = 12.0 + 0.5i
    .word 0x38CD4A80    # x[12] = 13.0 + 0.6i
    .word 0x399A4B00    # x[13] = 14.0 + 0.7i
    .word 0x2E664B80    # x[14] = 15.0 + 0.1i
    .word 0x32664C00    # x[15] = 16.0 + 0.2i
    .word 0x34CD3C00    # x[16] = 1.0 + 0.3i
    .word 0x36664000    # x[17] = 2.0 + 0.4i
    .word 0x38004200    # x[18] = 3.0 + 0.5i
    .word 0x38CD4400    # x[19] = 4.0 + 0.6i
    .word 0x399A4500    # x[20] = 5.0 + 0.7i
    .word 0x2E664600    # x[21] = 6.0 + 0.1i
    .word 0x32664700    # x[22] = 7.0 + 0.2i
    .word 0x34CD4800    # x[23] = 8.0 + 0.3i
    .word 0x36664880    # x[24] = 9.0 + 0.4i
    .word 0x38004900    # x[25] = 10.0 + 0.5i
    .word 0x38CD4980    # x[26] = 11.0 + 0.6i
    .word 0x399A4A00    # x[27] = 12.0 + 0.7i
    .word 0x2E664A80    # x[28] = 13.0 + 0.1i
    .word 0x32664B00    # x[29] = 14.0 + 0.2i
    .word 0x34CD4B80    # x[30] = 15.0 + 0.3i
    .word 0x36664C00    # x[31] = 16.0 + 0.4i
    .word 0x38003C00    # x[32] = 1.0 + 0.5i
    .word 0x38CD4000    # x[33] = 2.0 + 0.6i
    .word 0x399A4200    # x[34] = 3.0 + 0.7i
    .word 0x2E664400    # x[35] = 4.0 + 0.1i
    .word 0x32664500    # x[36] = 5.0 + 0.2i
    .word 0x34CD4600    # x[37] = 6.0 + 0.3i
    .word 0x36664700    # x[38] = 7.0 + 0.4i
    .word 0x38004800    # x[39] = 8.0 + 0.5i
    .word 0x38CD4880    # x[40] = 9.0 + 0.6i
    .word 0x399A4900    # x[41] = 10.0 + 0.7i
    .word 0x2E664980    # x[42] = 11.0 + 0.1i
    .word 0x32664A00    # x[43] = 12.0 + 0.2i
    .word 0x34CD4A80    # x[44] = 13.0 + 0.3i
    .word 0x36664B00    # x[45] = 14.0 + 0.4i
    .word 0x38004B80    # x[46] = 15.0 + 0.5i
    .word 0x38CD4C00    # x[47] = 16.0 + 0.6i
    .word 0x399A3C00    # x[48] = 1.0 + 0.7i
    .word 0x2E664000    # x[49] = 2.0 + 0.1i
    .word 0x32664200    # x[50] = 3.0 + 0.2i
    .word 0x34CD4400    # x[51] = 4.0 + 0.3i
    .word 0x36664500    # x[52] = 5.0 + 0.4i
    .word 0x38004600    # x[53] = 6.0 + 0.5i
    .word 0x38CD4700    # x[54] = 7.0 + 0.6i
    .word 0x399A4800    # x[55] = 8.0 + 0.7i
    .word 0x2E664880    # x[56] = 9.0 + 0.1i
    .word 0x32664900    # x[57] = 10.0 + 0.2i
    .word 0x34CD4980    # x[58] = 11.0 + 0.3i
    .word 0x36664A00    # x[59] = 12.0 + 0.4i
    .word 0x38004A80    # x[60] = 13.0 + 0.5i
    .word 0x38CD4B00    # x[61] = 14.0 + 0.6i
    .word 0x399A4B80    # x[62] = 15.0 + 0.7i
    .word 0x2E664C00    # x[63] = 16.0 + 0.1i

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
    # len = 32
    .word 0x00003C00    # W32^0 = 1.000000 +0.000000i
    .word 0xB23E3BD9    # W32^1 = 0.980785 -0.195090i
    .word 0xB61F3B64    # W32^2 = 0.923880 -0.382683i
    .word 0xB8723AA7    # W32^3 = 0.831470 -0.555570i
    .word 0xB9A839A8    # W32^4 = 0.707107 -0.707107i
    .word 0xBAA73872    # W32^5 = 0.555570 -0.831470i
    .word 0xBB64361F    # W32^6 = 0.382683 -0.923880i
    .word 0xBBD9323E    # W32^7 = 0.195090 -0.980785i
    .word 0xBC000000    # W32^8 = 0.000000 -1.000000i
    .word 0xBBD9B23E    # W32^9 = -0.195090 -0.980785i
    .word 0xBB64B61F    # W32^10 = -0.382683 -0.923880i
    .word 0xBAA7B872    # W32^11 = -0.555570 -0.831470i
    .word 0xB9A8B9A8    # W32^12 = -0.707107 -0.707107i
    .word 0xB872BAA7    # W32^13 = -0.831470 -0.555570i
    .word 0xB61FBB64    # W32^14 = -0.923880 -0.382683i
    .word 0xB23EBBD9    # W32^15 = -0.980785 -0.195090i
    # len = 64
    .word 0x00003C00    # W64^0 = 1.000000 +0.000000i
    .word 0xAE463BF6    # W64^1 = 0.995185 -0.098017i
    .word 0xB23E3BD9    # W64^2 = 0.980785 -0.195090i
    .word 0xB4A53BA8    # W64^3 = 0.956940 -0.290285i
    .word 0xB61F3B64    # W64^4 = 0.923880 -0.382683i
    .word 0xB78B3B0E    # W64^5 = 0.881921 -0.471397i
    .word 0xB8723AA7    # W64^6 = 0.831470 -0.555570i
    .word 0xB9133A2F    # W64^7 = 0.773010 -0.634393i
    .word 0xB9A839A8    # W64^8 = 0.707107 -0.707107i
    .word 0xBA2F3913    # W64^9 = 0.634393 -0.773010i
    .word 0xBAA73872    # W64^10 = 0.555570 -0.831470i
    .word 0xBB0E378B    # W64^11 = 0.471397 -0.881921i
    .word 0xBB64361F    # W64^12 = 0.382683 -0.923880i
    .word 0xBBA834A5    # W64^13 = 0.290285 -0.956940i
    .word 0xBBD9323E    # W64^14 = 0.195090 -0.980785i
    .word 0xBBF62E46    # W64^15 = 0.098017 -0.995185i
    .word 0xBC000000    # W64^16 = 0.000000 -1.000000i
    .word 0xBBF6AE46    # W64^17 = -0.098017 -0.995185i
    .word 0xBBD9B23E    # W64^18 = -0.195090 -0.980785i
    .word 0xBBA8B4A5    # W64^19 = -0.290285 -0.956940i
    .word 0xBB64B61F    # W64^20 = -0.382683 -0.923880i
    .word 0xBB0EB78B    # W64^21 = -0.471397 -0.881921i
    .word 0xBAA7B872    # W64^22 = -0.555570 -0.831470i
    .word 0xBA2FB913    # W64^23 = -0.634393 -0.773010i
    .word 0xB9A8B9A8    # W64^24 = -0.707107 -0.707107i
    .word 0xB913BA2F    # W64^25 = -0.773010 -0.634393i
    .word 0xB872BAA7    # W64^26 = -0.831470 -0.555570i
    .word 0xB78BBB0E    # W64^27 = -0.881921 -0.471397i
    .word 0xB61FBB64    # W64^28 = -0.923880 -0.382683i
    .word 0xB4A5BBA8    # W64^29 = -0.956940 -0.290285i
    .word 0xB23EBBD9    # W64^30 = -0.980785 -0.195090i
    .word 0xAE46BBF6    # W64^31 = -0.995185 -0.098017i

# 32-byte scratch for the len-2 lane shuffle: E @0, O @8, S @16, D @24
scratch: .word 0, 0, 0, 0, 0, 0, 0, 0

.text
main:
    la   s0, x
    li   s1, 64

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

    vcompl.h v12, v4, v8       # T = B * W
    vcompl.h v13, v5, v9
    vcompl.h v14, v6, v10
    vcompl.h v15, v7, v11

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
    vcompl.h v4, v1, v8
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
