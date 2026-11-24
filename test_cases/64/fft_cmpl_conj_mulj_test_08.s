# Vector radix-2 DIT FFT, fp32 (2 lanes = 1 complex per register), N = 64
# Uses vcmpl / vconj / vmulj. Output overwrites x[] in place.
.data
x:
    .float 0.0396476537, 0.916797757    # x[0]
    .float -0.319408715, 0.416369945    # x[1]
    .float 0.85043788, -0.89934665    # x[2]
    .float 0.322655082, 0.65422821    # x[3]
    .float 0.74699223, 0.182603806    # x[4]
    .float -0.774705529, -0.310444295    # x[5]
    .float -0.977244794, 0.581948578    # x[6]
    .float -0.344407201, -0.555544078    # x[7]
    .float -0.706468523, -0.918702364    # x[8]
    .float -0.713439286, -0.793015957    # x[9]
    .float -0.53997016, -0.300297797    # x[10]
    .float 0.733501613, -0.704823434    # x[11]
    .float -0.552171171, -0.502689123    # x[12]
    .float -0.539973795, 0.658612192    # x[13]
    .float -0.122089453, -0.100612246    # x[14]
    .float -0.317595154, 0.800935864    # x[15]
    .float -0.12074215, -0.0849772245    # x[16]
    .float 0.127840385, 0.345397294    # x[17]
    .float 0.319401026, 0.820437431    # x[18]
    .float 0.153379202, -0.168932468    # x[19]
    .float -0.284846485, 0.0832106099    # x[20]
    .float -0.517172396, -0.712532461    # x[21]
    .float -0.881042004, -0.000489811937    # x[22]
    .float -0.362774044, 0.540034771    # x[23]
    .float -0.0292141959, -0.0744490027    # x[24]
    .float 0.0752632841, 0.81703341    # x[25]
    .float 0.778927803, 0.45914197    # x[26]
    .float -0.796870291, 0.551397264    # x[27]
    .float -0.470653117, -0.829552591    # x[28]
    .float -0.894021094, -0.685215473    # x[29]
    .float -0.136222601, 0.2663306    # x[30]
    .float -0.511214375, 0.797926843    # x[31]
    .float 0.0382694043, 0.362077147    # x[32]
    .float -0.669052899, 0.525709748    # x[33]
    .float -0.371629119, -0.17615582    # x[34]
    .float -0.955187142, 0.252695441    # x[35]
    .float 0.389280349, 0.107574537    # x[36]
    .float -0.712927341, -0.234382242    # x[37]
    .float -0.588983357, 0.684832036    # x[38]
    .float -0.338870853, 0.900692523    # x[39]
    .float 0.467316866, 0.46556747    # x[40]
    .float 0.166631311, -0.472656161    # x[41]
    .float 0.407703429, 0.971999288    # x[42]
    .float -0.314476132, 0.462299854    # x[43]
    .float -0.516385376, 0.611479938    # x[44]
    .float -0.504533112, 0.428776652    # x[45]
    .float 0.628765583, -0.200471193    # x[46]
    .float -0.97449404, 0.238201216    # x[47]
    .float -0.665557146, -0.143967465    # x[48]
    .float -0.597686052, -0.528025389    # x[49]
    .float 0.38877663, -0.0452812947    # x[50]
    .float -0.687250197, -0.913686395    # x[51]
    .float 0.829942405, 0.0429708846    # x[52]
    .float 0.381594837, 0.587513924    # x[53]
    .float 0.917026579, -0.705993176    # x[54]
    .float -0.815760136, 0.44117403    # x[55]
    .float 0.616428614, 0.878487945    # x[56]
    .float 0.614039242, 0.566306531    # x[57]
    .float 0.199605465, -0.304196775    # x[58]
    .float 0.795808196, 0.355858564    # x[59]
    .float -0.425752848, -0.770077109    # x[60]
    .float 0.874767005, -0.638198495    # x[61]
    .float -0.450941652, 0.950683594    # x[62]
    .float 0.216105744, 0.190189496    # x[63]



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
