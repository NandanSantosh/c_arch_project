# Scalar radix-2 DIT FFT, fp32, N = 64
# Output overwrites x[] in place: x[k] = (re, im) as two .float
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
