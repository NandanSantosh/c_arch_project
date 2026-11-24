# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float -0.00531715807, -0.280019075    # x[0]
    .float 0.444123507, -0.106557466    # x[1]
    .float -0.0932806954, -0.948148668    # x[2]
    .float -0.330198199, -0.0489119515    # x[3]
    .float -0.0973528698, -0.824220538    # x[4]
    .float -0.409806579, -0.32273531    # x[5]
    .float 0.804191828, 0.434694737    # x[6]
    .float 0.797231853, -0.934005678    # x[7]
    .float -0.543063581, 0.0762941316    # x[8]
    .float -0.877449811, -0.541288674    # x[9]
    .float 0.11963246, -0.998305619    # x[10]
    .float -0.215929449, -0.937329531    # x[11]
    .float -0.518862605, 0.790757596    # x[12]
    .float -0.226684839, -0.464287102    # x[13]
    .float 0.822734535, 0.712337852    # x[14]
    .float -0.490273118, -0.145642892    # x[15]
    .float -0.605610371, 0.528963387    # x[16]
    .float -0.0915789008, 0.540288508    # x[17]
    .float 0.508991361, -0.734125972    # x[18]
    .float -0.727831781, 0.484398603    # x[19]
    .float 0.742067039, -0.637637019    # x[20]
    .float 0.716312647, -0.594510138    # x[21]
    .float -0.317941844, 0.27445814    # x[22]
    .float -0.701894462, 0.021819992    # x[23]
    .float -0.129413694, -0.804785371    # x[24]
    .float -0.881161392, -0.138989121    # x[25]
    .float 0.00498880865, 0.0159464665    # x[26]
    .float -0.871860862, -0.136610821    # x[27]
    .float 0.954807401, 0.416748613    # x[28]
    .float -0.352682829, 0.389668286    # x[29]
    .float -0.20805046, 0.140404016    # x[30]
    .float -0.745233893, -0.995575786    # x[31]
    .float 0.416476786, -0.0778990239    # x[32]
    .float -0.902551293, 0.999228299    # x[33]
    .float 0.254764289, -0.530275106    # x[34]
    .float 0.0082297679, 0.607881904    # x[35]
    .float -0.0413582996, 0.415914625    # x[36]
    .float -0.984889984, 0.601431787    # x[37]
    .float 0.142929122, -0.289296597    # x[38]
    .float -0.178099841, 0.748245835    # x[39]
    .float 0.884042084, -0.394390255    # x[40]
    .float 0.656826437, -0.339071274    # x[41]
    .float 0.0690981671, -0.88307482    # x[42]
    .float -0.271878272, -0.0162125248    # x[43]
    .float -0.894525468, 0.816410124    # x[44]
    .float 0.518018901, 0.808611393    # x[45]
    .float 0.0116918953, -0.626033187    # x[46]
    .float -0.24321869, -0.860912621    # x[47]
    .float 0.0133923758, -0.055975195    # x[48]
    .float -0.465332061, 0.556845248    # x[49]
    .float 0.358857542, 0.962870955    # x[50]
    .float -0.189136207, 0.21800302    # x[51]
    .float -0.703615546, -0.221519575    # x[52]
    .float 0.426722527, -0.378274143    # x[53]
    .float 0.574510515, 0.0337795615    # x[54]
    .float -0.652382076, -0.799008012    # x[55]
    .float -0.875032127, 0.217993438    # x[56]
    .float -0.490768373, -0.340999633    # x[57]
    .float 0.775421917, -0.928950489    # x[58]
    .float -0.0517761707, 0.351798087    # x[59]
    .float -0.551608622, 0.931450546    # x[60]
    .float 0.775650084, 0.280301064    # x[61]
    .float -0.632200062, -0.400532991    # x[62]
    .float -0.502420962, -0.519836247    # x[63]



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
