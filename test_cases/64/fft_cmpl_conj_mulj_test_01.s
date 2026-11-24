# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float 0.593301952, -0.882747531    # x[0]
    .float 0.52047956, 0.725407481    # x[1]
    .float -0.817451954, 0.804984868    # x[2]
    .float 0.571792126, -0.186640665    # x[3]
    .float -0.251054704, 0.29805246    # x[4]
    .float -0.198150665, 0.144221842    # x[5]
    .float 0.215586126, -0.898552179    # x[6]
    .float 0.474176019, 0.416972756    # x[7]
    .float 0.844344914, 0.429878056    # x[8]
    .float 0.311544985, 0.474214315    # x[9]
    .float -0.62491554, 0.00395567296    # x[10]
    .float 0.790059686, 0.852716625    # x[11]
    .float -0.962016881, 0.755462945    # x[12]
    .float 0.272584945, -0.186730683    # x[13]
    .float -0.740842819, 0.725375712    # x[14]
    .float -0.492407084, 0.185718    # x[15]
    .float -0.849435747, 0.112970829    # x[16]
    .float -0.215972543, -0.386776    # x[17]
    .float -0.667712092, -0.929035842    # x[18]
    .float 0.746816218, 0.215586796    # x[19]
    .float -0.988675356, 0.158750281    # x[20]
    .float 0.532997489, -0.598832726    # x[21]
    .float 0.858645201, 0.684527218    # x[22]
    .float 0.0774083212, 0.976678073    # x[23]
    .float -0.563945949, -0.92301321    # x[24]
    .float -0.259357721, -0.635545909    # x[25]
    .float 0.892472029, -0.769815922    # x[26]
    .float -0.294150412, 0.726390243    # x[27]
    .float -0.917542219, -0.821580708    # x[28]
    .float 0.0377784595, -0.281249702    # x[29]
    .float -0.957243025, 0.341125965    # x[30]
    .float 0.683003783, -0.890069067    # x[31]
    .float -0.743051708, -0.757326961    # x[32]
    .float -0.0500764847, 0.300288051    # x[33]
    .float -0.470655382, 0.656790853    # x[34]
    .float -0.80734992, 0.800298512    # x[35]
    .float -0.551589906, -0.76797694    # x[36]
    .float -0.597221375, 0.114340894    # x[37]
    .float 0.790861785, -0.784328282    # x[38]
    .float 0.222039372, 0.0571492799    # x[39]
    .float -0.049752146, 0.5693326    # x[40]
    .float -0.49605763, 0.802312493    # x[41]
    .float -0.339691132, -0.218582481    # x[42]
    .float 0.00485981815, 0.0828017816    # x[43]
    .float 0.412346512, 0.633512139    # x[44]
    .float 0.817267835, -0.747627437    # x[45]
    .float -0.631888509, 0.537065089    # x[46]
    .float 0.568150938, -0.49289155    # x[47]
    .float 0.765908122, 0.736984551    # x[48]
    .float -0.874559343, -0.771028161    # x[49]
    .float -0.809246123, 0.731290936    # x[50]
    .float 0.738424957, -0.504074156    # x[51]
    .float 0.780517995, -0.597909331    # x[52]
    .float -0.0660812333, 0.058812663    # x[53]
    .float 0.151724279, -0.755314648    # x[54]
    .float -0.880381823, 0.780161202    # x[55]
    .float 0.563747168, 0.00141704141    # x[56]
    .float 0.323084891, 0.594728529    # x[57]
    .float -0.873062313, -0.518265188    # x[58]
    .float 0.434746057, 0.296616286    # x[59]
    .float -0.114164233, -0.71939081    # x[60]
    .float -0.874394119, -0.43955335    # x[61]
    .float 0.233609498, -0.103915408    # x[62]
    .float 0.266304433, 0.852541029    # x[63]



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
