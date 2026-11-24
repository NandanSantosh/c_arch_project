# Scalar radix-2 DIT FFT, fp32, N = 256
# Output overwrites x[] in place: x[k] = (re, im) as two .float
.data
x:
    .float 1.0, 0.1    # x[0]
    .float 2.0, 0.2    # x[1]
    .float 3.0, 0.3    # x[2]
    .float 4.0, 0.4    # x[3]
    .float 5.0, 0.5    # x[4]
    .float 6.0, 0.6    # x[5]
    .float 7.0, 0.7    # x[6]
    .float 8.0, 0.1    # x[7]
    .float 9.0, 0.2    # x[8]
    .float 10.0, 0.3   # x[9]
    .float 11.0, 0.4   # x[10]
    .float 12.0, 0.5   # x[11]
    .float 13.0, 0.6   # x[12]
    .float 14.0, 0.7   # x[13]
    .float 15.0, 0.1   # x[14]
    .float 16.0, 0.2   # x[15]
    .float 1.0, 0.3    # x[16]
    .float 2.0, 0.4    # x[17]
    .float 3.0, 0.5    # x[18]
    .float 4.0, 0.6    # x[19]
    .float 5.0, 0.7    # x[20]
    .float 6.0, 0.1    # x[21]
    .float 7.0, 0.2    # x[22]
    .float 8.0, 0.3    # x[23]
    .float 9.0, 0.4    # x[24]
    .float 10.0, 0.5   # x[25]
    .float 11.0, 0.6   # x[26]
    .float 12.0, 0.7   # x[27]
    .float 13.0, 0.1   # x[28]
    .float 14.0, 0.2   # x[29]
    .float 15.0, 0.3   # x[30]
    .float 16.0, 0.4   # x[31]
    .float 1.0, 0.5    # x[32]
    .float 2.0, 0.6    # x[33]
    .float 3.0, 0.7    # x[34]
    .float 4.0, 0.1    # x[35]
    .float 5.0, 0.2    # x[36]
    .float 6.0, 0.3    # x[37]
    .float 7.0, 0.4    # x[38]
    .float 8.0, 0.5    # x[39]
    .float 9.0, 0.6    # x[40]
    .float 10.0, 0.7   # x[41]
    .float 11.0, 0.1   # x[42]
    .float 12.0, 0.2   # x[43]
    .float 13.0, 0.3   # x[44]
    .float 14.0, 0.4   # x[45]
    .float 15.0, 0.5   # x[46]
    .float 16.0, 0.6   # x[47]
    .float 1.0, 0.7    # x[48]
    .float 2.0, 0.1    # x[49]
    .float 3.0, 0.2    # x[50]
    .float 4.0, 0.3    # x[51]
    .float 5.0, 0.4    # x[52]
    .float 6.0, 0.5    # x[53]
    .float 7.0, 0.6    # x[54]
    .float 8.0, 0.7    # x[55]
    .float 9.0, 0.1    # x[56]
    .float 10.0, 0.2   # x[57]
    .float 11.0, 0.3   # x[58]
    .float 12.0, 0.4   # x[59]
    .float 13.0, 0.5   # x[60]
    .float 14.0, 0.6   # x[61]
    .float 15.0, 0.7   # x[62]
    .float 16.0, 0.1   # x[63]
    .float 1.0, 0.2    # x[64]
    .float 2.0, 0.3    # x[65]
    .float 3.0, 0.4    # x[66]
    .float 4.0, 0.5    # x[67]
    .float 5.0, 0.6    # x[68]
    .float 6.0, 0.7    # x[69]
    .float 7.0, 0.1    # x[70]
    .float 8.0, 0.2    # x[71]
    .float 9.0, 0.3    # x[72]
    .float 10.0, 0.4   # x[73]
    .float 11.0, 0.5   # x[74]
    .float 12.0, 0.6   # x[75]
    .float 13.0, 0.7   # x[76]
    .float 14.0, 0.1   # x[77]
    .float 15.0, 0.2   # x[78]
    .float 16.0, 0.3   # x[79]
    .float 1.0, 0.4    # x[80]
    .float 2.0, 0.5    # x[81]
    .float 3.0, 0.6    # x[82]
    .float 4.0, 0.7    # x[83]
    .float 5.0, 0.1    # x[84]
    .float 6.0, 0.2    # x[85]
    .float 7.0, 0.3    # x[86]
    .float 8.0, 0.4    # x[87]
    .float 9.0, 0.5    # x[88]
    .float 10.0, 0.6   # x[89]
    .float 11.0, 0.7   # x[90]
    .float 12.0, 0.1   # x[91]
    .float 13.0, 0.2   # x[92]
    .float 14.0, 0.3   # x[93]
    .float 15.0, 0.4   # x[94]
    .float 16.0, 0.5   # x[95]
    .float 1.0, 0.6    # x[96]
    .float 2.0, 0.7    # x[97]
    .float 3.0, 0.1    # x[98]
    .float 4.0, 0.2    # x[99]
    .float 5.0, 0.3    # x[100]
    .float 6.0, 0.4    # x[101]
    .float 7.0, 0.5    # x[102]
    .float 8.0, 0.6    # x[103]
    .float 9.0, 0.7    # x[104]
    .float 10.0, 0.1   # x[105]
    .float 11.0, 0.2   # x[106]
    .float 12.0, 0.3   # x[107]
    .float 13.0, 0.4   # x[108]
    .float 14.0, 0.5   # x[109]
    .float 15.0, 0.6   # x[110]
    .float 16.0, 0.7   # x[111]
    .float 1.0, 0.1    # x[112]
    .float 2.0, 0.2    # x[113]
    .float 3.0, 0.3    # x[114]
    .float 4.0, 0.4    # x[115]
    .float 5.0, 0.5    # x[116]
    .float 6.0, 0.6    # x[117]
    .float 7.0, 0.7    # x[118]
    .float 8.0, 0.1    # x[119]
    .float 9.0, 0.2    # x[120]
    .float 10.0, 0.3   # x[121]
    .float 11.0, 0.4   # x[122]
    .float 12.0, 0.5   # x[123]
    .float 13.0, 0.6   # x[124]
    .float 14.0, 0.7   # x[125]
    .float 15.0, 0.1   # x[126]
    .float 16.0, 0.2   # x[127]
    .float 1.0, 0.3    # x[128]
    .float 2.0, 0.4    # x[129]
    .float 3.0, 0.5    # x[130]
    .float 4.0, 0.6    # x[131]
    .float 5.0, 0.7    # x[132]
    .float 6.0, 0.1    # x[133]
    .float 7.0, 0.2    # x[134]
    .float 8.0, 0.3    # x[135]
    .float 9.0, 0.4    # x[136]
    .float 10.0, 0.5   # x[137]
    .float 11.0, 0.6   # x[138]
    .float 12.0, 0.7   # x[139]
    .float 13.0, 0.1   # x[140]
    .float 14.0, 0.2   # x[141]
    .float 15.0, 0.3   # x[142]
    .float 16.0, 0.4   # x[143]
    .float 1.0, 0.5    # x[144]
    .float 2.0, 0.6    # x[145]
    .float 3.0, 0.7    # x[146]
    .float 4.0, 0.1    # x[147]
    .float 5.0, 0.2    # x[148]
    .float 6.0, 0.3    # x[149]
    .float 7.0, 0.4    # x[150]
    .float 8.0, 0.5    # x[151]
    .float 9.0, 0.6    # x[152]
    .float 10.0, 0.7   # x[153]
    .float 11.0, 0.1   # x[154]
    .float 12.0, 0.2   # x[155]
    .float 13.0, 0.3   # x[156]
    .float 14.0, 0.4   # x[157]
    .float 15.0, 0.5   # x[158]
    .float 16.0, 0.6   # x[159]
    .float 1.0, 0.7    # x[160]
    .float 2.0, 0.1    # x[161]
    .float 3.0, 0.2    # x[162]
    .float 4.0, 0.3    # x[163]
    .float 5.0, 0.4    # x[164]
    .float 6.0, 0.5    # x[165]
    .float 7.0, 0.6    # x[166]
    .float 8.0, 0.7    # x[167]
    .float 9.0, 0.1    # x[168]
    .float 10.0, 0.2   # x[169]
    .float 11.0, 0.3   # x[170]
    .float 12.0, 0.4   # x[171]
    .float 13.0, 0.5   # x[172]
    .float 14.0, 0.6   # x[173]
    .float 15.0, 0.7   # x[174]
    .float 16.0, 0.1   # x[175]
    .float 1.0, 0.2    # x[176]
    .float 2.0, 0.3    # x[177]
    .float 3.0, 0.4    # x[178]
    .float 4.0, 0.5    # x[179]
    .float 5.0, 0.6    # x[180]
    .float 6.0, 0.7    # x[181]
    .float 7.0, 0.1    # x[182]
    .float 8.0, 0.2    # x[183]
    .float 9.0, 0.3    # x[184]
    .float 10.0, 0.4   # x[185]
    .float 11.0, 0.5   # x[186]
    .float 12.0, 0.6   # x[187]
    .float 13.0, 0.7   # x[188]
    .float 14.0, 0.1   # x[189]
    .float 15.0, 0.2   # x[190]
    .float 16.0, 0.3   # x[191]
    .float 1.0, 0.4    # x[192]
    .float 2.0, 0.5    # x[193]
    .float 3.0, 0.6    # x[194]
    .float 4.0, 0.7    # x[195]
    .float 5.0, 0.1    # x[196]
    .float 6.0, 0.2    # x[197]
    .float 7.0, 0.3    # x[198]
    .float 8.0, 0.4    # x[199]
    .float 9.0, 0.5    # x[200]
    .float 10.0, 0.6   # x[201]
    .float 11.0, 0.7   # x[202]
    .float 12.0, 0.1   # x[203]
    .float 13.0, 0.2   # x[204]
    .float 14.0, 0.3   # x[205]
    .float 15.0, 0.4   # x[206]
    .float 16.0, 0.5   # x[207]
    .float 1.0, 0.6    # x[208]
    .float 2.0, 0.7    # x[209]
    .float 3.0, 0.1    # x[210]
    .float 4.0, 0.2    # x[211]
    .float 5.0, 0.3    # x[212]
    .float 6.0, 0.4    # x[213]
    .float 7.0, 0.5    # x[214]
    .float 8.0, 0.6    # x[215]
    .float 9.0, 0.7    # x[216]
    .float 10.0, 0.1   # x[217]
    .float 11.0, 0.2   # x[218]
    .float 12.0, 0.3   # x[219]
    .float 13.0, 0.4   # x[220]
    .float 14.0, 0.5   # x[221]
    .float 15.0, 0.6   # x[222]
    .float 16.0, 0.7   # x[223]
    .float 1.0, 0.1    # x[224]
    .float 2.0, 0.2    # x[225]
    .float 3.0, 0.3    # x[226]
    .float 4.0, 0.4    # x[227]
    .float 5.0, 0.5    # x[228]
    .float 6.0, 0.6    # x[229]
    .float 7.0, 0.7    # x[230]
    .float 8.0, 0.1    # x[231]
    .float 9.0, 0.2    # x[232]
    .float 10.0, 0.3   # x[233]
    .float 11.0, 0.4   # x[234]
    .float 12.0, 0.5   # x[235]
    .float 13.0, 0.6   # x[236]
    .float 14.0, 0.7   # x[237]
    .float 15.0, 0.1   # x[238]
    .float 16.0, 0.2   # x[239]
    .float 1.0, 0.3    # x[240]
    .float 2.0, 0.4    # x[241]
    .float 3.0, 0.5    # x[242]
    .float 4.0, 0.6    # x[243]
    .float 5.0, 0.7    # x[244]
    .float 6.0, 0.1    # x[245]
    .float 7.0, 0.2    # x[246]
    .float 8.0, 0.3    # x[247]
    .float 9.0, 0.4    # x[248]
    .float 10.0, 0.5   # x[249]
    .float 11.0, 0.6   # x[250]
    .float 12.0, 0.7   # x[251]
    .float 13.0, 0.1   # x[252]
    .float 14.0, 0.2   # x[253]
    .float 15.0, 0.3   # x[254]
    .float 16.0, 0.4   # x[255]



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
    li   s1, 256

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