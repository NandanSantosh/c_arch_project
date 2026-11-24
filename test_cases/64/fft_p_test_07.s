# Scalar radix-2 DIT FFT, fp32, N = 64
# Output overwrites x[] in place: x[k] = (re, im) as two .float
.data
x:
    .float 0.711878777, 0.600967884    # x[0]
    .float 0.187686697, 0.774018645    # x[1]
    .float 0.483116329, 0.619534075    # x[2]
    .float -0.550535202, 0.952363789    # x[3]
    .float 0.267807752, 0.116057128    # x[4]
    .float -0.107294701, -0.433270752    # x[5]
    .float 0.803976059, -0.934629858    # x[6]
    .float -0.127434954, -0.622969151    # x[7]
    .float 0.850018024, 0.802469969    # x[8]
    .float -0.757828772, 0.834803104    # x[9]
    .float 0.267207354, 0.783283055    # x[10]
    .float 0.885507405, 0.294853956    # x[11]
    .float -0.4111965, -0.544302702    # x[12]
    .float -0.946546137, 0.141744807    # x[13]
    .float -0.817132056, 0.945761621    # x[14]
    .float -0.901722848, 0.632610977    # x[15]
    .float -0.757277131, -0.213045046    # x[16]
    .float 0.522512734, -0.466063499    # x[17]
    .float -0.935341716, -0.45867905    # x[18]
    .float 0.741118312, 0.761969447    # x[19]
    .float -0.631805599, -0.596874416    # x[20]
    .float 0.0329831243, -0.00879044179    # x[21]
    .float 0.215459436, 0.800236166    # x[22]
    .float 0.568214834, -0.0387628637    # x[23]
    .float -0.770446837, -0.859510779    # x[24]
    .float -0.362509787, -0.985387444    # x[25]
    .float 0.0410888083, 0.250193626    # x[26]
    .float -0.498888642, 0.231844872    # x[27]
    .float -0.225818574, -0.563704312    # x[28]
    .float 0.746992648, -0.425558388    # x[29]
    .float -0.80721283, 0.509771764    # x[30]
    .float 0.370345473, -0.897651851    # x[31]
    .float -0.642259657, 0.218503118    # x[32]
    .float -0.500316918, -0.263650566    # x[33]
    .float -0.882465124, -0.754780889    # x[34]
    .float -0.0816747546, -0.198145643    # x[35]
    .float -0.0699037611, -0.573580921    # x[36]
    .float 0.249454394, -0.429494888    # x[37]
    .float 0.269681394, 0.66397649    # x[38]
    .float 0.679084241, -0.96077013    # x[39]
    .float 0.0827969685, -0.456240356    # x[40]
    .float -0.103656545, -0.472462833    # x[41]
    .float -0.330090582, 0.0350339338    # x[42]
    .float 0.373196036, -0.749092698    # x[43]
    .float -0.954547167, 0.461782545    # x[44]
    .float -0.53820008, -0.380014539    # x[45]
    .float 0.397078842, 0.439333767    # x[46]
    .float -0.118296362, -0.0176802836    # x[47]
    .float -0.89248848, -0.215138882    # x[48]
    .float 0.349812567, 0.463485301    # x[49]
    .float -0.640454352, 0.381936491    # x[50]
    .float -0.742006004, -0.832024813    # x[51]
    .float -0.0257488173, 0.783516705    # x[52]
    .float 0.108548477, -0.960248709    # x[53]
    .float 0.215607226, 0.132106408    # x[54]
    .float 0.00212771422, 0.734415591    # x[55]
    .float -0.601176023, -0.00204886077    # x[56]
    .float -0.237383679, 0.836274266    # x[57]
    .float -0.74982512, -0.517142475    # x[58]
    .float -0.317677438, -0.669455826    # x[59]
    .float 0.971179903, 0.0505213402    # x[60]
    .float -0.97208041, -0.515979588    # x[61]
    .float -0.767869592, -0.56970048    # x[62]
    .float -0.617912948, 0.440240979    # x[63]



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
