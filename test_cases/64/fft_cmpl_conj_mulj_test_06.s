# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float -0.306760073, -0.542717814    # x[0]
    .float -0.975215077, 0.861654043    # x[1]
    .float -0.354970843, -0.998609066    # x[2]
    .float -0.58056587, 0.0359204561    # x[3]
    .float 0.525644422, -0.382056415    # x[4]
    .float -0.697737575, -0.859084547    # x[5]
    .float 0.74501282, -0.385003716    # x[6]
    .float -0.454280466, 0.967692971    # x[7]
    .float 0.477015883, 0.53815645    # x[8]
    .float 0.469555318, -0.919779956    # x[9]
    .float 0.56655246, 0.977815092    # x[10]
    .float 0.97360605, -0.816874206    # x[11]
    .float 0.233960301, 0.805357814    # x[12]
    .float 0.597081482, -0.24474363    # x[13]
    .float -0.290333718, -0.193098128    # x[14]
    .float 0.0498021953, -0.178598419    # x[15]
    .float 0.279352576, 0.289731413    # x[16]
    .float 0.437408894, -0.0786443949    # x[17]
    .float 0.894486487, 0.0961953327    # x[18]
    .float 0.0424874946, 0.994954169    # x[19]
    .float 0.669447303, 0.184067041    # x[20]
    .float 0.0562400967, 0.989429057    # x[21]
    .float -0.238537639, -0.6695081    # x[22]
    .float -0.279449552, -0.838280618    # x[23]
    .float 0.679041028, 0.922814012    # x[24]
    .float -0.828477204, -0.875395894    # x[25]
    .float -0.0338039547, 0.505402207    # x[26]
    .float 0.130654693, -0.713833869    # x[27]
    .float 0.805488586, -0.21648252    # x[28]
    .float -0.910582185, -0.0849341601    # x[29]
    .float -0.111637712, -0.841648638    # x[30]
    .float -0.244590193, -0.50255698    # x[31]
    .float -0.371710926, -0.184998661    # x[32]
    .float -0.655612826, -0.223585561    # x[33]
    .float 0.518473089, -0.555345714    # x[34]
    .float 0.126688197, -0.872283399    # x[35]
    .float -0.016924141, 0.298669636    # x[36]
    .float -0.281526923, -0.977645874    # x[37]
    .float -0.453306556, 0.0711099282    # x[38]
    .float 0.260392904, -0.739573836    # x[39]
    .float -0.480070889, -0.829908311    # x[40]
    .float 0.486600667, -0.635475397    # x[41]
    .float 0.897928536, 0.734615326    # x[42]
    .float -0.443249971, 0.559085429    # x[43]
    .float -0.895136952, 0.0475604087    # x[44]
    .float 0.535179973, 0.0685239509    # x[45]
    .float -0.71292901, 0.417625874    # x[46]
    .float 0.265790582, -0.488179654    # x[47]
    .float -0.715472043, 0.692684948    # x[48]
    .float -0.940133631, 0.490317911    # x[49]
    .float -0.634099364, 0.584896684    # x[50]
    .float 0.505690455, -0.494220197    # x[51]
    .float -0.287374675, -0.616738796    # x[52]
    .float 0.274894744, 0.599202454    # x[53]
    .float -0.0735074729, 0.914989412    # x[54]
    .float 0.666110873, 0.676538408    # x[55]
    .float -0.653801858, 0.863122642    # x[56]
    .float -0.124027856, -0.733179092    # x[57]
    .float 0.540642142, -0.0453048609    # x[58]
    .float 0.47385326, 0.753674924    # x[59]
    .float -0.00403486053, -0.802767038    # x[60]
    .float -0.422795027, -0.614756644    # x[61]
    .float 0.880357087, -0.661475241    # x[62]
    .float 0.633924365, 0.64458406    # x[63]



# Positive-angle Wlen = cos(2*pi/len) + i*sin(2*pi/len), len = 2,4,...,1024.
# vconj turns each into the forward-FFT twiddle cos - i*sin.
wlen_table:
    .float -1.0, 0.0
    .float 0.0, 1.0
    .float 0.7071067812, 0.7071067812
    .float 0.9238795325, 0.3826834324
    .float 0.9807852804, 0.1950903220
    .float 0.9951847267, 0.0980171403
    .float 0.9987954562, 0.0490676743
    .float 0.9996988187, 0.0245412285
    .float 0.9999247018, 0.0122715383
    .float 0.9999811753, 0.0061358846

one_zero:
    .float 1.0, 0.0

.text

main:
    la   s0, x
    li   s1, 64         # Change to 16, 64, 256 or 512
    la   s2, wlen_table
    la   a6, one_zero

# ============================================================
# BIT REVERSAL
# Dynamic mask: N/2
# Each complex number occupies 8 bytes (two FP32 values).
# ============================================================

    li   t0, 1
    li   t1, 0
    srli t2, s1, 1            # Initial bit-reversal mask = N/2

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
    slli t3, t0, 3
    add  t3, s0, t3

    slli t4, t1, 3
    add  t4, s0, t4

    flw  ft0, 0(t3)
    flw  ft1, 4(t3)
    flw  ft2, 0(t4)
    flw  ft3, 4(t4)

    fsw  ft2, 0(t3)
    fsw  ft3, 4(t3)
    fsw  ft0, 0(t4)
    fsw  ft1, 4(t4)

bitrev_next:
    addi t0, t0, 1
    srli t2, s1, 1            # Reset mask for next index
    j    bitrev_i

bitrev_done:
    li   t0, 2                # First FFT stage length

# ============================================================
# ITERATIVE RADIX-2 DIT FFT
#
# T = B * W^j
# A' = A + T,  B' = A - T
#
# vcmpl : complex multiplication
# vconj : complex conjugation
# vmulj : multiplication by +i
# ============================================================

stage_loop:
    blt  s1, t0, fft_done

    srli t3, t0, 1            # half = len/2

    li   t4, 2
    beq  t0, t4, stage2_loop

    li   t4, 4
    beq  t0, t4, stage4_loop

# ============================================================
# GENERAL STAGES: len >= 8
# ============================================================

    vld    v24, 0(s2)         # Positive-angle Wlen
    vconj  v24, v24           # Convert to negative-angle Wlen

    # Precompute Wlen^2, Wlen^3 and Wlen^4
    vcmpl  v25, v24, v24
    vcmpl  v26, v25, v24
    vcmpl  v27, v26, v24

    li   t1, 0                # Block starting index

block_loop:
    bge  t1, s1, stage_done

    # Initialize W^0, W^1, W^2, W^3
    vld    v8, 0(a6)           # W^0 = 1 + 0i
    vcmpl  v9, v8, v24         # W^1
    vcmpl  v10, v9, v24        # W^2
    vcmpl  v11, v10, v24       # W^3

    li   t2, 0                 # Butterfly index j

butterfly_loop:
    bge  t2, t3, butterfly_done

    # A address = x + (block_start + j)*8
    add  a0, t1, t2
    slli a0, a0, 3
    add  a0, s0, a0

    # B address = A + half*8
    slli a1, t3, 3
    add  a1, a0, a1

    # Load four consecutive A and B complex values
    vld  v0,  0(a0)
    vld  v4,  0(a1)

    vld  v1,  8(a0)
    vld  v5,  8(a1)

    vld  v2, 16(a0)
    vld  v6, 16(a1)

    vld  v3, 24(a0)
    vld  v7, 24(a1)

    # T[j] = B[j] * W[j]
    vcmpl v12, v4, v8
    vcmpl v13, v5, v9
    vcmpl v14, v6, v10
    vcmpl v15, v7, v11

    # Anew = A + T
    vadd  v16, v0, v12
    vadd  v17, v1, v13
    vadd  v18, v2, v14
    vadd  v19, v3, v15

    # Bnew = A - T
    vsub  v20, v0, v12
    vsub  v21, v1, v13
    vsub  v22, v2, v14
    vsub  v23, v3, v15

    # Store results
    vsd  v16,  0(a0)
    vsd  v17,  8(a0)
    vsd  v18, 16(a0)
    vsd  v19, 24(a0)

    vsd  v20,  0(a1)
    vsd  v21,  8(a1)
    vsd  v22, 16(a1)
    vsd  v23, 24(a1)

    # Advance twiddles by W^4
    vcmpl v8,  v8,  v27
    vcmpl v9,  v9,  v27
    vcmpl v10, v10, v27
    vcmpl v11, v11, v27

    addi t2, t2, 4
    j    butterfly_loop

butterfly_done:
    add  t1, t1, t0
    j    block_loop

# ============================================================
# STAGE len = 2
# W = 1
# ============================================================

stage2_loop:
    li   t1, 0

stage2_block:
    bge  t1, s1, stage_done

    slli a0, t1, 3
    add  a0, s0, a0
    addi a1, a0, 8

    vld  v0, 0(a0)
    vld  v1, 0(a1)

    vadd v2, v0, v1
    vsub v3, v0, v1

    vsd  v2, 0(a0)
    vsd  v3, 0(a1)

    addi t1, t1, 2
    j    stage2_block

# ============================================================
# STAGE len = 4
# W0 = 1
# W1 = -i
#
# vmulj(a+ib) = i*(a+ib) = -b+ia
# T = B*W1 = -i*B = -vmulj(B), so A+T = A-vmulj(B), A-T = A+vmulj(B)
# ============================================================

stage4_loop:
    li   t1, 0

stage4_block:
    bge  t1, s1, stage_done

    # A0, A1, B0, B1
    slli a0, t1, 3
    add  a0, s0, a0
    addi a1, a0, 16

    vld  v0,  0(a0)           # A0
    vld  v1,  0(a1)           # B0
    vld  v2,  8(a0)           # A1
    vld  v3,  8(a1)           # B1

    # j = 0, W0 = 1
    vadd v4, v0, v1
    vsub v5, v0, v1

    # j = 1, W1 = -i
    vmulj v8, v3               # v8 = i*B1
    vsub  v9, v2, v8           # A1 + T = A1 - i*B1
    vadd  v10, v2, v8          # A1 - T = A1 + i*B1

    # Store results
    vsd v4,  0(a0)
    vsd v5,  0(a1)
    vsd v9,  8(a0)
    vsd v10, 8(a1)

    addi t1, t1, 4
    j    stage4_block

# ============================================================
# NEXT STAGE
# ============================================================

stage_done:
    addi s2, s2, 8            # Next Wlen table entry
    slli t0, t0, 1            # len = len*2
    j    stage_loop

fft_done:
    ebreak
