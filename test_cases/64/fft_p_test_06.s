# Scalar radix-2 DIT FFT, fp32, N = 64
# Output overwrites x[] in place: x[k] = (re, im) as two .float
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
