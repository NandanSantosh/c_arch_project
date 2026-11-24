# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float -0.639615178, -0.0252754539    # x[0]
    .float -0.844816625, 0.0451334491    # x[1]
    .float 0.839286685, 0.752501905    # x[2]
    .float 0.00593918236, 0.632053614    # x[3]
    .float 0.611822426, -0.571881771    # x[4]
    .float -0.823883593, -0.593405247    # x[5]
    .float 0.167472184, 0.347466767    # x[6]
    .float -0.678397417, 0.493005335    # x[7]
    .float 0.141343012, -0.0724003613    # x[8]
    .float 0.0214143395, -0.731265187    # x[9]
    .float 0.19116734, 0.941193998    # x[10]
    .float -0.723947942, 0.383009255    # x[11]
    .float -0.0857791156, 0.554186702    # x[12]
    .float -0.142218545, 0.574698448    # x[13]
    .float -0.0928379372, -0.40011844    # x[14]
    .float -0.464281768, -0.172380075    # x[15]
    .float 0.791150093, -0.322014034    # x[16]
    .float -0.112155996, -0.467370659    # x[17]
    .float -0.617574394, 0.684429705    # x[18]
    .float -0.741312385, 0.0914987102    # x[19]
    .float 0.377942652, -0.373382092    # x[20]
    .float 0.562693834, 0.49533692    # x[21]
    .float 0.388677567, -0.979432762    # x[22]
    .float 0.516300142, 0.673132122    # x[23]
    .float 0.793059528, -0.149968266    # x[24]
    .float -0.405468524, -0.621541262    # x[25]
    .float 0.4486489, 0.703950644    # x[26]
    .float -0.796429157, 0.0499626212    # x[27]
    .float -0.261899918, -0.7149598    # x[28]
    .float 0.823323786, 0.0863203108    # x[29]
    .float -0.159219176, 0.632702649    # x[30]
    .float 0.717834234, 0.519246757    # x[31]
    .float 0.770480692, -0.719871342    # x[32]
    .float 0.430618376, -0.193279713    # x[33]
    .float -0.350711465, 0.221011505    # x[34]
    .float 0.887343287, -0.549154162    # x[35]
    .float -0.544142902, -0.359567672    # x[36]
    .float 0.894343257, -0.869653404    # x[37]
    .float 0.0636834204, -0.879083157    # x[38]
    .float -0.886349797, -0.889498472    # x[39]
    .float -0.839182734, -0.0917001739    # x[40]
    .float 0.079641372, 0.924040437    # x[41]
    .float -0.111265972, -0.0113675492    # x[42]
    .float -0.397682369, -0.924710631    # x[43]
    .float -0.349943668, 0.384681076    # x[44]
    .float 0.704648077, -0.910287321    # x[45]
    .float 0.846791744, 0.321202129    # x[46]
    .float -0.581239045, 0.280207992    # x[47]
    .float 0.0203282796, -0.926356912    # x[48]
    .float 0.660855412, -0.343337417    # x[49]
    .float 0.74221015, 0.659986675    # x[50]
    .float -0.045631323, -0.917873025    # x[51]
    .float -0.53737092, -0.982379973    # x[52]
    .float 0.48657757, -0.739145935    # x[53]
    .float 0.558420539, 0.859475017    # x[54]
    .float 0.811206281, -0.81664288    # x[55]
    .float -0.559265494, -0.536151648    # x[56]
    .float 0.320541322, -0.930280149    # x[57]
    .float -0.819607794, -0.236414999    # x[58]
    .float 0.575648308, 0.194566056    # x[59]
    .float -0.721811831, -0.104442075    # x[60]
    .float 0.115392551, -0.972607374    # x[61]
    .float -0.281579375, -0.336317718    # x[62]
    .float 0.259322882, 0.604744613    # x[63]



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
