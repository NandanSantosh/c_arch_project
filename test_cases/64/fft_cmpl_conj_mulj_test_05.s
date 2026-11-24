# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float -0.0337792076, 0.804365993    # x[0]
    .float 0.0749143884, 0.752268195    # x[1]
    .float 0.146313891, 0.989047706    # x[2]
    .float -0.285106868, 0.323459923    # x[3]
    .float -0.0234255474, 0.145282567    # x[4]
    .float -0.352232039, 0.614470899    # x[5]
    .float 0.61746484, 0.321704894    # x[6]
    .float 0.160515457, -0.911827207    # x[7]
    .float 0.545127213, -0.31963703    # x[8]
    .float -0.809879482, -0.535704613    # x[9]
    .float -0.409830838, -0.754459977    # x[10]
    .float -0.0530524813, 0.747872472    # x[11]
    .float 0.188597783, -0.213472649    # x[12]
    .float -0.287475944, 0.68866241    # x[13]
    .float 0.427553624, 0.08329992    # x[14]
    .float -0.468450099, 0.860737324    # x[15]
    .float 0.329407275, 0.696252346    # x[16]
    .float -0.451395392, 0.197571218    # x[17]
    .float -0.0861152038, -0.3357279    # x[18]
    .float 0.625269532, 0.192988306    # x[19]
    .float 0.98957783, 0.657414317    # x[20]
    .float -0.963236988, 0.220127568    # x[21]
    .float -0.424915224, 0.597346544    # x[22]
    .float 0.634900928, -0.621183217    # x[23]
    .float 0.850190282, 0.0746328309    # x[24]
    .float 0.673055589, 0.263382852    # x[25]
    .float -0.696319282, 0.0563325733    # x[26]
    .float -0.0833097398, -0.915387392    # x[27]
    .float -0.748380661, -0.868359327    # x[28]
    .float 0.794839203, -0.0545580275    # x[29]
    .float -0.619929254, -0.314989805    # x[30]
    .float -0.550063014, -0.413206249    # x[31]
    .float -0.249251321, -0.0800527856    # x[32]
    .float -0.0410238095, 0.917146206    # x[33]
    .float -0.93492192, -0.130398959    # x[34]
    .float -0.502396226, 0.868179739    # x[35]
    .float -0.284588784, -0.552135706    # x[36]
    .float 0.734374106, -0.589761913    # x[37]
    .float 0.198535129, 0.357358217    # x[38]
    .float 0.875127554, -0.221817598    # x[39]
    .float 0.257753581, -0.266010582    # x[40]
    .float -0.906199574, 0.698171258    # x[41]
    .float 0.780334771, 0.832357407    # x[42]
    .float -0.773791194, 0.554907441    # x[43]
    .float -0.938080668, -0.920580745    # x[44]
    .float 0.458254904, 0.308185846    # x[45]
    .float 0.198137403, 0.960129678    # x[46]
    .float -0.246298209, 0.254171818    # x[47]
    .float 0.648410916, -0.0567267202    # x[48]
    .float -0.138090059, 0.740287721    # x[49]
    .float -0.344121605, 0.373967469    # x[50]
    .float -0.645842493, 0.430175751    # x[51]
    .float 0.640841961, -0.378710747    # x[52]
    .float 0.446218431, 0.975629985    # x[53]
    .float 0.102577373, -0.848974526    # x[54]
    .float 0.0436789803, 0.776568651    # x[55]
    .float 0.198179737, -0.689170241    # x[56]
    .float 0.284003198, -0.354353815    # x[57]
    .float 0.857843757, -0.775992692    # x[58]
    .float 0.614263177, -0.468347579    # x[59]
    .float 0.291176826, 0.354442656    # x[60]
    .float -0.831965864, -0.477193475    # x[61]
    .float 0.38623777, 0.240782663    # x[62]
    .float -0.142888859, -0.203604698    # x[63]



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
