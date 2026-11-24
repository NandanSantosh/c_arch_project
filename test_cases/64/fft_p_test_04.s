# Scalar radix-2 DIT FFT, fp32, N = 64
# Output overwrites x[] in place: x[k] = (re, im) as two .float
.data
x:
    .float -0.157750189, 0.952214658    # x[0]
    .float 0.226560056, 0.386084646    # x[1]
    .float 0.0177256707, -0.624376893    # x[2]
    .float 0.66024375, 0.689848304    # x[3]
    .float -0.580743551, 0.301033974    # x[4]
    .float 0.400663227, 0.430067897    # x[5]
    .float 0.618214488, 0.690395772    # x[6]
    .float -0.260830045, 0.0112299807    # x[7]
    .float 0.441228151, -0.713619709    # x[8]
    .float -0.946605742, -0.693168223    # x[9]
    .float 0.672686458, -0.350732595    # x[10]
    .float -0.394164979, -0.764285982    # x[11]
    .float -0.758106709, 0.936151624    # x[12]
    .float -0.898969173, 0.967420101    # x[13]
    .float 0.104541183, -0.505127907    # x[14]
    .float -0.9681319, 0.763301551    # x[15]
    .float -0.220598117, 0.896798015    # x[16]
    .float -0.882977545, 0.594987273    # x[17]
    .float 0.321813703, 0.617678821    # x[18]
    .float -0.0178642161, 0.436775118    # x[19]
    .float -0.119797334, -0.529765248    # x[20]
    .float -0.736410916, -0.0552891605    # x[21]
    .float 0.472971797, -0.958975792    # x[22]
    .float -0.692558467, 0.837225258    # x[23]
    .float 0.0654501691, 0.108831406    # x[24]
    .float 0.213875815, -0.703964829    # x[25]
    .float -0.119131036, -0.221007228    # x[26]
    .float 0.441985905, -0.0202007685    # x[27]
    .float 0.311864316, 0.837775588    # x[28]
    .float -0.0268540382, 0.594460189    # x[29]
    .float 0.127843931, 0.922033072    # x[30]
    .float -0.0471040085, -0.50241977    # x[31]
    .float 0.89803654, 0.484452009    # x[32]
    .float -0.713270724, -0.282436848    # x[33]
    .float -0.0132341599, -0.892220199    # x[34]
    .float -0.563676715, -0.7792629    # x[35]
    .float -0.7796067, -0.833562791    # x[36]
    .float 0.709686399, 0.675957203    # x[37]
    .float -0.00615087384, -0.323316306    # x[38]
    .float 0.769453406, 0.545414686    # x[39]
    .float -0.1242778, -0.272855252    # x[40]
    .float 0.998625696, -0.977185309    # x[41]
    .float 0.367767066, 0.1555354    # x[42]
    .float -0.440855742, 0.0502749979    # x[43]
    .float -0.60809803, 0.38688612    # x[44]
    .float 0.347762883, 0.373752415    # x[45]
    .float 0.209681556, -0.923525214    # x[46]
    .float -0.984794199, 0.498970211    # x[47]
    .float 0.991804481, 0.350517809    # x[48]
    .float 0.925918043, 0.765659988    # x[49]
    .float -0.133091927, 0.167527124    # x[50]
    .float 0.898095131, -0.93749398    # x[51]
    .float -0.572581112, 0.62475127    # x[52]
    .float 0.943466187, -0.786703467    # x[53]
    .float 0.106262915, 0.903292835    # x[54]
    .float 0.450388372, 0.721327066    # x[55]
    .float -0.517657936, -0.223760277    # x[56]
    .float 0.491104573, -0.504065931    # x[57]
    .float -0.325321883, 0.815831959    # x[58]
    .float 0.807306468, 0.0698783398    # x[59]
    .float 0.250965685, 0.772403836    # x[60]
    .float -0.978146315, -0.6211586    # x[61]
    .float -0.369249314, 0.669797778    # x[62]
    .float 0.779557645, 0.0445725061    # x[63]



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
