# Scalar radix-2 DIT FFT, fp32, N = 64
# Output overwrites x[] in place: x[k] = (re, im) as two .float
.data
x:
    .float 0.554713309, 0.339651108    # x[0]
    .float -0.801720798, -0.294058979    # x[1]
    .float -0.0641845167, 0.0693674833    # x[2]
    .float 0.95661813, -0.739369273    # x[3]
    .float 0.342486948, -0.271541178    # x[4]
    .float -0.0223285854, -0.593975604    # x[5]
    .float 0.332396746, -0.54467392    # x[6]
    .float -0.0838718861, -0.9185552    # x[7]
    .float 0.948579609, -0.0250478517    # x[8]
    .float -0.0767722726, 0.428294301    # x[9]
    .float -0.168543696, 0.776023388    # x[10]
    .float -0.953413129, 0.667012513    # x[11]
    .float -0.0630105212, 0.622959614    # x[12]
    .float 0.891182959, 0.966176748    # x[13]
    .float -0.647635877, 0.397311509    # x[14]
    .float -0.782288551, -0.679472506    # x[15]
    .float -0.814279437, -0.371875852    # x[16]
    .float -0.966922641, 0.708098233    # x[17]
    .float -0.417967916, 0.560095191    # x[18]
    .float 0.0961930305, -0.611338675    # x[19]
    .float -0.415923446, -0.361094445    # x[20]
    .float 0.317196459, -0.53695792    # x[21]
    .float 0.238860667, 0.79067719    # x[22]
    .float 0.738868415, -0.412386119    # x[23]
    .float -0.0835903808, -0.0300404038    # x[24]
    .float -0.439223468, -0.342086107    # x[25]
    .float 0.968484819, -0.97611171    # x[26]
    .float -0.71419847, 0.303954422    # x[27]
    .float -0.850013614, -0.415842593    # x[28]
    .float 0.586885929, 0.823186219    # x[29]
    .float -0.259216428, -0.589435577    # x[30]
    .float 0.760162652, 0.265132904    # x[31]
    .float 0.00702865189, -0.338312894    # x[32]
    .float -0.305199623, -0.415176839    # x[33]
    .float 0.530794859, -0.0431133993    # x[34]
    .float -0.596925318, 0.743125439    # x[35]
    .float 0.510357082, 0.735116899    # x[36]
    .float 0.864647388, -0.516573489    # x[37]
    .float 0.784900963, 0.53191334    # x[38]
    .float -0.170634612, -0.352634788    # x[39]
    .float 0.12261048, 0.181671962    # x[40]
    .float -0.668834448, -0.0276058707    # x[41]
    .float 0.898043394, -0.0636178032    # x[42]
    .float -0.206740588, 0.837613225    # x[43]
    .float 0.971455276, 0.878401339    # x[44]
    .float -0.904729724, 0.720751822    # x[45]
    .float -0.597908318, -0.3127819    # x[46]
    .float 0.765065432, -0.803170443    # x[47]
    .float -0.733475447, -0.464620858    # x[48]
    .float -0.581374168, -0.318668187    # x[49]
    .float 0.453188896, 0.263572931    # x[50]
    .float -0.682438612, 0.532427132    # x[51]
    .float 0.847771764, 0.182156861    # x[52]
    .float -0.662929296, -0.0226261429    # x[53]
    .float 0.436668873, -0.567624509    # x[54]
    .float 0.224287465, 0.240681022    # x[55]
    .float -0.52496171, -0.712024689    # x[56]
    .float 0.544427812, 0.0611490831    # x[57]
    .float -0.122615144, -0.0442004614    # x[58]
    .float 0.568210661, 0.673726797    # x[59]
    .float -0.187478364, 0.548371077    # x[60]
    .float -0.993745446, 0.753103793    # x[61]
    .float -0.936641276, 0.963496625    # x[62]
    .float 0.990429342, 0.212060183    # x[63]



wlen_table:
    .float -1.0, 0.0
    .float 0.0, -1.0
    .float 0.7071067812, -0.7071067812
    .float 0.9238795325, -0.3826834324
    .float 0.9807852804, -0.1950903220
    .float 0.9951847267, -0.0980171403
    .float 0.9987954562, -0.0490676743
    .float 0.9996988187, -0.0245412285
    .float 0.9999247018, -0.0122715383
    .float 0.9999811753, -0.0061358846

one_zero:
    .float 1.0, 0.0

.text
main:
    la   s0, x
    li   s1, 64

# Bit reversal permutation (N-bit carry algorithm)
    li   t0, 1
    li   t1, 0
    srli t2, s1, 1

bitrev_i:
    bge  t0, s1, bitrev_done

bitrev_carry:
    and  t5, t1, t2
    beq  t5, zero, bitrev_toggle
    xor  t1, t1, t2
    srli t2, t2, 1
    j    bitrev_carry

bitrev_toggle:
    xor  t1, t1, t2
    srli t2, s1, 1
    bge  t0, t1, bitrev_next

    # Address of complex x[i] and x[j] (8 bytes per sample)
    slli t3, t0, 3
    add  t3, s0, t3
    slli t4, t1, 3
    add  t4, s0, t4

    # Swap real and imaginary components
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
    li   t2, 0
    srli t2, s1, 1
    j    bitrev_i

bitrev_done:
    li   t0, 2
    la   s2, wlen_table
    la   a6, one_zero

# Iterative radix-2 forward FFT
stage_loop:
    blt  s1, t0, fft_done

    flw  ft10, 0(s2)
    flw  ft11, 4(s2)

    li   t1, 0

block_loop:
    bge  t1, s1, stage_done

    flw  ft4, 0(a6)
    flw  ft5, 4(a6)

    li   t2, 0
    srli t3, t0, 1

butterfly_loop:
    bge  t2, t3, butterfly_done

    # a0 = &x[i+j], a1 = &x[i+j+half]
    add  a0, t1, t2
    slli a0, a0, 3
    add  a0, s0, a0

    add  a1, t1, t2
    add  a1, a1, t3
    slli a1, a1, 3
    add  a1, s0, a1

    # Load A and B
    flw  ft0, 0(a0)
    flw  ft1, 4(a0)
    flw  ft2, 0(a1)
    flw  ft3, 4(a1)

    # T = B * W
    fmul.s ft6, ft2, ft4
    fmul.s ft7, ft3, ft5
    fsub.s ft8, ft6, ft7

    fmul.s ft6, ft2, ft5
    fmul.s ft7, ft3, ft4
    fadd.s ft9, ft6, ft7

    # X0 = A + T
    fadd.s ft6, ft0, ft8
    fadd.s ft7, ft1, ft9
    fsw  ft6, 0(a0)
    fsw  ft7, 4(a0)

    # X1 = A - T
    fsub.s ft6, ft0, ft8
    fsub.s ft7, ft1, ft9
    fsw  ft6, 0(a1)
    fsw  ft7, 4(a1)

    # W = W * Wlen
    fmul.s ft6, ft4, ft10
    fmul.s ft7, ft5, ft11
    fsub.s ft8, ft6, ft7

    fmul.s ft6, ft4, ft11
    fmul.s ft7, ft5, ft10
    fadd.s ft9, ft6, ft7

    fsgnj.s ft4, ft8, ft8
    fsgnj.s ft5, ft9, ft9

    addi t2, t2, 1
    j    butterfly_loop

butterfly_done:
    add  t1, t1, t0
    j    block_loop

stage_done:
    addi s2, s2, 8
    slli t0, t0, 1
    j    stage_loop

fft_done:
    ebreak
