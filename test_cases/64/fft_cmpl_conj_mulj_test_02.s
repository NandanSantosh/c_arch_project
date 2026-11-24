# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float 0.0418968126, -0.157499596    # x[0]
    .float -0.558109641, -0.739325821    # x[1]
    .float -0.0320844613, 0.252177924    # x[2]
    .float 0.242243662, 0.414555192    # x[3]
    .float -0.129208192, -0.903804004    # x[4]
    .float -0.549030602, 0.577096105    # x[5]
    .float -0.157822192, 0.130405903    # x[6]
    .float 0.352808535, 0.51366514    # x[7]
    .float -0.674977958, -0.0675413311    # x[8]
    .float 0.305317163, 0.869664729    # x[9]
    .float -0.438123256, 0.800954401    # x[10]
    .float 0.697679162, 0.0489695072    # x[11]
    .float 0.157292843, 0.871170104    # x[12]
    .float -0.119684003, -0.421273023    # x[13]
    .float 0.594759524, -0.797477245    # x[14]
    .float 0.437454134, 0.289912701    # x[15]
    .float -0.217464775, 0.878595054    # x[16]
    .float 0.21847637, -0.690309346    # x[17]
    .float -0.166393772, 0.908508778    # x[18]
    .float -0.829761922, 0.620416462    # x[19]
    .float 0.0980966836, 0.59486264    # x[20]
    .float 0.842509151, -0.831972003    # x[21]
    .float -0.145780295, -0.0345900953    # x[22]
    .float -0.0147503577, 0.676242948    # x[23]
    .float -0.87663275, -0.639928699    # x[24]
    .float 0.502401292, 0.640462995    # x[25]
    .float 0.896453857, -0.816199481    # x[26]
    .float 0.655045807, -0.979552627    # x[27]
    .float 0.583035707, -0.538257003    # x[28]
    .float 0.835284233, 0.267480135    # x[29]
    .float -0.0554970391, -0.686146736    # x[30]
    .float 0.780911267, -0.213125065    # x[31]
    .float 0.887494624, -0.945887625    # x[32]
    .float -0.139291003, -0.920279324    # x[33]
    .float -0.450496584, 0.912981808    # x[34]
    .float -0.32801944, -0.908093929    # x[35]
    .float -0.249022722, 0.420105129    # x[36]
    .float 0.43909055, 0.637780547    # x[37]
    .float -0.766806006, 0.0234812628    # x[38]
    .float -0.154728144, -0.153764158    # x[39]
    .float 0.195195779, -0.799206853    # x[40]
    .float 0.732257664, 0.652492762    # x[41]
    .float 0.176811993, -0.394969076    # x[42]
    .float -0.937409759, 0.151585013    # x[43]
    .float 0.909064293, 0.929953933    # x[44]
    .float 0.68274653, 0.932576835    # x[45]
    .float 0.407726437, -0.394530535    # x[46]
    .float 0.512565494, 0.473634928    # x[47]
    .float 0.336628586, 0.603445649    # x[48]
    .float 0.684451818, 0.845987976    # x[49]
    .float -0.19783327, 0.808879435    # x[50]
    .float -0.831357479, 0.438138932    # x[51]
    .float 0.276663661, -0.373782158    # x[52]
    .float 0.0720704123, -0.241113037    # x[53]
    .float 0.541684091, 0.237285271    # x[54]
    .float 0.325497627, 0.64631325    # x[55]
    .float -0.547411323, -0.843669593    # x[56]
    .float 0.778852999, 0.662515044    # x[57]
    .float -0.534127593, -0.662160337    # x[58]
    .float 0.621865034, -0.644034743    # x[59]
    .float -0.204842359, -0.477507055    # x[60]
    .float -0.659587801, 0.203090951    # x[61]
    .float 0.536904871, -0.128847465    # x[62]
    .float 0.336091608, -0.41090852    # x[63]



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
