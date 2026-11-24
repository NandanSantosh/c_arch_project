# Packed-fp16 radix-2 DIT FFT, N = 256
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcompl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0x2E663C00    # x[0] = 1.0 + 0.1i
    .word 0x32664000    # x[1] = 2.0 + 0.2i
    .word 0x34CD4200    # x[2] = 3.0 + 0.3i
    .word 0x36664400    # x[3] = 4.0 + 0.4i
    .word 0x38004500    # x[4] = 5.0 + 0.5i
    .word 0x38CD4600    # x[5] = 6.0 + 0.6i
    .word 0x399A4700    # x[6] = 7.0 + 0.7i
    .word 0x2E664800    # x[7] = 8.0 + 0.1i
    .word 0x32664880    # x[8] = 9.0 + 0.2i
    .word 0x34CD4900    # x[9] = 10.0 + 0.3i
    .word 0x36664980    # x[10] = 11.0 + 0.4i
    .word 0x38004A00    # x[11] = 12.0 + 0.5i
    .word 0x38CD4A80    # x[12] = 13.0 + 0.6i
    .word 0x399A4B00    # x[13] = 14.0 + 0.7i
    .word 0x2E664B80    # x[14] = 15.0 + 0.1i
    .word 0x32664C00    # x[15] = 16.0 + 0.2i
    .word 0x34CD3C00    # x[16] = 1.0 + 0.3i
    .word 0x36664000    # x[17] = 2.0 + 0.4i
    .word 0x38004200    # x[18] = 3.0 + 0.5i
    .word 0x38CD4400    # x[19] = 4.0 + 0.6i
    .word 0x399A4500    # x[20] = 5.0 + 0.7i
    .word 0x2E664600    # x[21] = 6.0 + 0.1i
    .word 0x32664700    # x[22] = 7.0 + 0.2i
    .word 0x34CD4800    # x[23] = 8.0 + 0.3i
    .word 0x36664880    # x[24] = 9.0 + 0.4i
    .word 0x38004900    # x[25] = 10.0 + 0.5i
    .word 0x38CD4980    # x[26] = 11.0 + 0.6i
    .word 0x399A4A00    # x[27] = 12.0 + 0.7i
    .word 0x2E664A80    # x[28] = 13.0 + 0.1i
    .word 0x32664B00    # x[29] = 14.0 + 0.2i
    .word 0x34CD4B80    # x[30] = 15.0 + 0.3i
    .word 0x36664C00    # x[31] = 16.0 + 0.4i
    .word 0x38003C00    # x[32] = 1.0 + 0.5i
    .word 0x38CD4000    # x[33] = 2.0 + 0.6i
    .word 0x399A4200    # x[34] = 3.0 + 0.7i
    .word 0x2E664400    # x[35] = 4.0 + 0.1i
    .word 0x32664500    # x[36] = 5.0 + 0.2i
    .word 0x34CD4600    # x[37] = 6.0 + 0.3i
    .word 0x36664700    # x[38] = 7.0 + 0.4i
    .word 0x38004800    # x[39] = 8.0 + 0.5i
    .word 0x38CD4880    # x[40] = 9.0 + 0.6i
    .word 0x399A4900    # x[41] = 10.0 + 0.7i
    .word 0x2E664980    # x[42] = 11.0 + 0.1i
    .word 0x32664A00    # x[43] = 12.0 + 0.2i
    .word 0x34CD4A80    # x[44] = 13.0 + 0.3i
    .word 0x36664B00    # x[45] = 14.0 + 0.4i
    .word 0x38004B80    # x[46] = 15.0 + 0.5i
    .word 0x38CD4C00    # x[47] = 16.0 + 0.6i
    .word 0x399A3C00    # x[48] = 1.0 + 0.7i
    .word 0x2E664000    # x[49] = 2.0 + 0.1i
    .word 0x32664200    # x[50] = 3.0 + 0.2i
    .word 0x34CD4400    # x[51] = 4.0 + 0.3i
    .word 0x36664500    # x[52] = 5.0 + 0.4i
    .word 0x38004600    # x[53] = 6.0 + 0.5i
    .word 0x38CD4700    # x[54] = 7.0 + 0.6i
    .word 0x399A4800    # x[55] = 8.0 + 0.7i
    .word 0x2E664880    # x[56] = 9.0 + 0.1i
    .word 0x32664900    # x[57] = 10.0 + 0.2i
    .word 0x34CD4980    # x[58] = 11.0 + 0.3i
    .word 0x36664A00    # x[59] = 12.0 + 0.4i
    .word 0x38004A80    # x[60] = 13.0 + 0.5i
    .word 0x38CD4B00    # x[61] = 14.0 + 0.6i
    .word 0x399A4B80    # x[62] = 15.0 + 0.7i
    .word 0x2E664C00    # x[63] = 16.0 + 0.1i
    .word 0x32663C00    # x[64] = 1.0 + 0.2i
    .word 0x34CD4000    # x[65] = 2.0 + 0.3i
    .word 0x36664200    # x[66] = 3.0 + 0.4i
    .word 0x38004400    # x[67] = 4.0 + 0.5i
    .word 0x38CD4500    # x[68] = 5.0 + 0.6i
    .word 0x399A4600    # x[69] = 6.0 + 0.7i
    .word 0x2E664700    # x[70] = 7.0 + 0.1i
    .word 0x32664800    # x[71] = 8.0 + 0.2i
    .word 0x34CD4880    # x[72] = 9.0 + 0.3i
    .word 0x36664900    # x[73] = 10.0 + 0.4i
    .word 0x38004980    # x[74] = 11.0 + 0.5i
    .word 0x38CD4A00    # x[75] = 12.0 + 0.6i
    .word 0x399A4A80    # x[76] = 13.0 + 0.7i
    .word 0x2E664B00    # x[77] = 14.0 + 0.1i
    .word 0x32664B80    # x[78] = 15.0 + 0.2i
    .word 0x34CD4C00    # x[79] = 16.0 + 0.3i
    .word 0x36663C00    # x[80] = 1.0 + 0.4i
    .word 0x38004000    # x[81] = 2.0 + 0.5i
    .word 0x38CD4200    # x[82] = 3.0 + 0.6i
    .word 0x399A4400    # x[83] = 4.0 + 0.7i
    .word 0x2E664500    # x[84] = 5.0 + 0.1i
    .word 0x32664600    # x[85] = 6.0 + 0.2i
    .word 0x34CD4700    # x[86] = 7.0 + 0.3i
    .word 0x36664800    # x[87] = 8.0 + 0.4i
    .word 0x38004880    # x[88] = 9.0 + 0.5i
    .word 0x38CD4900    # x[89] = 10.0 + 0.6i
    .word 0x399A4980    # x[90] = 11.0 + 0.7i
    .word 0x2E664A00    # x[91] = 12.0 + 0.1i
    .word 0x32664A80    # x[92] = 13.0 + 0.2i
    .word 0x34CD4B00    # x[93] = 14.0 + 0.3i
    .word 0x36664B80    # x[94] = 15.0 + 0.4i
    .word 0x38004C00    # x[95] = 16.0 + 0.5i
    .word 0x38CD3C00    # x[96] = 1.0 + 0.6i
    .word 0x399A4000    # x[97] = 2.0 + 0.7i
    .word 0x2E664200    # x[98] = 3.0 + 0.1i
    .word 0x32664400    # x[99] = 4.0 + 0.2i
    .word 0x34CD4500    # x[100] = 5.0 + 0.3i
    .word 0x36664600    # x[101] = 6.0 + 0.4i
    .word 0x38004700    # x[102] = 7.0 + 0.5i
    .word 0x38CD4800    # x[103] = 8.0 + 0.6i
    .word 0x399A4880    # x[104] = 9.0 + 0.7i
    .word 0x2E664900    # x[105] = 10.0 + 0.1i
    .word 0x32664980    # x[106] = 11.0 + 0.2i
    .word 0x34CD4A00    # x[107] = 12.0 + 0.3i
    .word 0x36664A80    # x[108] = 13.0 + 0.4i
    .word 0x38004B00    # x[109] = 14.0 + 0.5i
    .word 0x38CD4B80    # x[110] = 15.0 + 0.6i
    .word 0x399A4C00    # x[111] = 16.0 + 0.7i
    .word 0x2E663C00    # x[112] = 1.0 + 0.1i
    .word 0x32664000    # x[113] = 2.0 + 0.2i
    .word 0x34CD4200    # x[114] = 3.0 + 0.3i
    .word 0x36664400    # x[115] = 4.0 + 0.4i
    .word 0x38004500    # x[116] = 5.0 + 0.5i
    .word 0x38CD4600    # x[117] = 6.0 + 0.6i
    .word 0x399A4700    # x[118] = 7.0 + 0.7i
    .word 0x2E664800    # x[119] = 8.0 + 0.1i
    .word 0x32664880    # x[120] = 9.0 + 0.2i
    .word 0x34CD4900    # x[121] = 10.0 + 0.3i
    .word 0x36664980    # x[122] = 11.0 + 0.4i
    .word 0x38004A00    # x[123] = 12.0 + 0.5i
    .word 0x38CD4A80    # x[124] = 13.0 + 0.6i
    .word 0x399A4B00    # x[125] = 14.0 + 0.7i
    .word 0x2E664B80    # x[126] = 15.0 + 0.1i
    .word 0x32664C00    # x[127] = 16.0 + 0.2i
    .word 0x34CD3C00    # x[128] = 1.0 + 0.3i
    .word 0x36664000    # x[129] = 2.0 + 0.4i
    .word 0x38004200    # x[130] = 3.0 + 0.5i
    .word 0x38CD4400    # x[131] = 4.0 + 0.6i
    .word 0x399A4500    # x[132] = 5.0 + 0.7i
    .word 0x2E664600    # x[133] = 6.0 + 0.1i
    .word 0x32664700    # x[134] = 7.0 + 0.2i
    .word 0x34CD4800    # x[135] = 8.0 + 0.3i
    .word 0x36664880    # x[136] = 9.0 + 0.4i
    .word 0x38004900    # x[137] = 10.0 + 0.5i
    .word 0x38CD4980    # x[138] = 11.0 + 0.6i
    .word 0x399A4A00    # x[139] = 12.0 + 0.7i
    .word 0x2E664A80    # x[140] = 13.0 + 0.1i
    .word 0x32664B00    # x[141] = 14.0 + 0.2i
    .word 0x34CD4B80    # x[142] = 15.0 + 0.3i
    .word 0x36664C00    # x[143] = 16.0 + 0.4i
    .word 0x38003C00    # x[144] = 1.0 + 0.5i
    .word 0x38CD4000    # x[145] = 2.0 + 0.6i
    .word 0x399A4200    # x[146] = 3.0 + 0.7i
    .word 0x2E664400    # x[147] = 4.0 + 0.1i
    .word 0x32664500    # x[148] = 5.0 + 0.2i
    .word 0x34CD4600    # x[149] = 6.0 + 0.3i
    .word 0x36664700    # x[150] = 7.0 + 0.4i
    .word 0x38004800    # x[151] = 8.0 + 0.5i
    .word 0x38CD4880    # x[152] = 9.0 + 0.6i
    .word 0x399A4900    # x[153] = 10.0 + 0.7i
    .word 0x2E664980    # x[154] = 11.0 + 0.1i
    .word 0x32664A00    # x[155] = 12.0 + 0.2i
    .word 0x34CD4A80    # x[156] = 13.0 + 0.3i
    .word 0x36664B00    # x[157] = 14.0 + 0.4i
    .word 0x38004B80    # x[158] = 15.0 + 0.5i
    .word 0x38CD4C00    # x[159] = 16.0 + 0.6i
    .word 0x399A3C00    # x[160] = 1.0 + 0.7i
    .word 0x2E664000    # x[161] = 2.0 + 0.1i
    .word 0x32664200    # x[162] = 3.0 + 0.2i
    .word 0x34CD4400    # x[163] = 4.0 + 0.3i
    .word 0x36664500    # x[164] = 5.0 + 0.4i
    .word 0x38004600    # x[165] = 6.0 + 0.5i
    .word 0x38CD4700    # x[166] = 7.0 + 0.6i
    .word 0x399A4800    # x[167] = 8.0 + 0.7i
    .word 0x2E664880    # x[168] = 9.0 + 0.1i
    .word 0x32664900    # x[169] = 10.0 + 0.2i
    .word 0x34CD4980    # x[170] = 11.0 + 0.3i
    .word 0x36664A00    # x[171] = 12.0 + 0.4i
    .word 0x38004A80    # x[172] = 13.0 + 0.5i
    .word 0x38CD4B00    # x[173] = 14.0 + 0.6i
    .word 0x399A4B80    # x[174] = 15.0 + 0.7i
    .word 0x2E664C00    # x[175] = 16.0 + 0.1i
    .word 0x32663C00    # x[176] = 1.0 + 0.2i
    .word 0x34CD4000    # x[177] = 2.0 + 0.3i
    .word 0x36664200    # x[178] = 3.0 + 0.4i
    .word 0x38004400    # x[179] = 4.0 + 0.5i
    .word 0x38CD4500    # x[180] = 5.0 + 0.6i
    .word 0x399A4600    # x[181] = 6.0 + 0.7i
    .word 0x2E664700    # x[182] = 7.0 + 0.1i
    .word 0x32664800    # x[183] = 8.0 + 0.2i
    .word 0x34CD4880    # x[184] = 9.0 + 0.3i
    .word 0x36664900    # x[185] = 10.0 + 0.4i
    .word 0x38004980    # x[186] = 11.0 + 0.5i
    .word 0x38CD4A00    # x[187] = 12.0 + 0.6i
    .word 0x399A4A80    # x[188] = 13.0 + 0.7i
    .word 0x2E664B00    # x[189] = 14.0 + 0.1i
    .word 0x32664B80    # x[190] = 15.0 + 0.2i
    .word 0x34CD4C00    # x[191] = 16.0 + 0.3i
    .word 0x36663C00    # x[192] = 1.0 + 0.4i
    .word 0x38004000    # x[193] = 2.0 + 0.5i
    .word 0x38CD4200    # x[194] = 3.0 + 0.6i
    .word 0x399A4400    # x[195] = 4.0 + 0.7i
    .word 0x2E664500    # x[196] = 5.0 + 0.1i
    .word 0x32664600    # x[197] = 6.0 + 0.2i
    .word 0x34CD4700    # x[198] = 7.0 + 0.3i
    .word 0x36664800    # x[199] = 8.0 + 0.4i
    .word 0x38004880    # x[200] = 9.0 + 0.5i
    .word 0x38CD4900    # x[201] = 10.0 + 0.6i
    .word 0x399A4980    # x[202] = 11.0 + 0.7i
    .word 0x2E664A00    # x[203] = 12.0 + 0.1i
    .word 0x32664A80    # x[204] = 13.0 + 0.2i
    .word 0x34CD4B00    # x[205] = 14.0 + 0.3i
    .word 0x36664B80    # x[206] = 15.0 + 0.4i
    .word 0x38004C00    # x[207] = 16.0 + 0.5i
    .word 0x38CD3C00    # x[208] = 1.0 + 0.6i
    .word 0x399A4000    # x[209] = 2.0 + 0.7i
    .word 0x2E664200    # x[210] = 3.0 + 0.1i
    .word 0x32664400    # x[211] = 4.0 + 0.2i
    .word 0x34CD4500    # x[212] = 5.0 + 0.3i
    .word 0x36664600    # x[213] = 6.0 + 0.4i
    .word 0x38004700    # x[214] = 7.0 + 0.5i
    .word 0x38CD4800    # x[215] = 8.0 + 0.6i
    .word 0x399A4880    # x[216] = 9.0 + 0.7i
    .word 0x2E664900    # x[217] = 10.0 + 0.1i
    .word 0x32664980    # x[218] = 11.0 + 0.2i
    .word 0x34CD4A00    # x[219] = 12.0 + 0.3i
    .word 0x36664A80    # x[220] = 13.0 + 0.4i
    .word 0x38004B00    # x[221] = 14.0 + 0.5i
    .word 0x38CD4B80    # x[222] = 15.0 + 0.6i
    .word 0x399A4C00    # x[223] = 16.0 + 0.7i
    .word 0x2E663C00    # x[224] = 1.0 + 0.1i
    .word 0x32664000    # x[225] = 2.0 + 0.2i
    .word 0x34CD4200    # x[226] = 3.0 + 0.3i
    .word 0x36664400    # x[227] = 4.0 + 0.4i
    .word 0x38004500    # x[228] = 5.0 + 0.5i
    .word 0x38CD4600    # x[229] = 6.0 + 0.6i
    .word 0x399A4700    # x[230] = 7.0 + 0.7i
    .word 0x2E664800    # x[231] = 8.0 + 0.1i
    .word 0x32664880    # x[232] = 9.0 + 0.2i
    .word 0x34CD4900    # x[233] = 10.0 + 0.3i
    .word 0x36664980    # x[234] = 11.0 + 0.4i
    .word 0x38004A00    # x[235] = 12.0 + 0.5i
    .word 0x38CD4A80    # x[236] = 13.0 + 0.6i
    .word 0x399A4B00    # x[237] = 14.0 + 0.7i
    .word 0x2E664B80    # x[238] = 15.0 + 0.1i
    .word 0x32664C00    # x[239] = 16.0 + 0.2i
    .word 0x34CD3C00    # x[240] = 1.0 + 0.3i
    .word 0x36664000    # x[241] = 2.0 + 0.4i
    .word 0x38004200    # x[242] = 3.0 + 0.5i
    .word 0x38CD4400    # x[243] = 4.0 + 0.6i
    .word 0x399A4500    # x[244] = 5.0 + 0.7i
    .word 0x2E664600    # x[245] = 6.0 + 0.1i
    .word 0x32664700    # x[246] = 7.0 + 0.2i
    .word 0x34CD4800    # x[247] = 8.0 + 0.3i
    .word 0x36664880    # x[248] = 9.0 + 0.4i
    .word 0x38004900    # x[249] = 10.0 + 0.5i
    .word 0x38CD4980    # x[250] = 11.0 + 0.6i
    .word 0x399A4A00    # x[251] = 12.0 + 0.7i
    .word 0x2E664A80    # x[252] = 13.0 + 0.1i
    .word 0x32664B00    # x[253] = 14.0 + 0.2i
    .word 0x34CD4B80    # x[254] = 15.0 + 0.3i
    .word 0x36664C00    # x[255] = 16.0 + 0.4i

# Per-stage twiddle tables, len = 4, 8, ..., N, concatenated:
# W_len^j = cos(-2*pi*j/len) + i*sin(-2*pi*j/len), j = 0 .. len/2-1
tw_table:
    # len = 4
    .word 0x00003C00    # W4^0 = 1.000000 +0.000000i
    .word 0xBC000000    # W4^1 = 0.000000 -1.000000i
    # len = 8
    .word 0x00003C00    # W8^0 = 1.000000 +0.000000i
    .word 0xB9A839A8    # W8^1 = 0.707107 -0.707107i
    .word 0xBC000000    # W8^2 = 0.000000 -1.000000i
    .word 0xB9A8B9A8    # W8^3 = -0.707107 -0.707107i
    # len = 16
    .word 0x00003C00    # W16^0 = 1.000000 +0.000000i
    .word 0xB61F3B64    # W16^1 = 0.923880 -0.382683i
    .word 0xB9A839A8    # W16^2 = 0.707107 -0.707107i
    .word 0xBB64361F    # W16^3 = 0.382683 -0.923880i
    .word 0xBC000000    # W16^4 = 0.000000 -1.000000i
    .word 0xBB64B61F    # W16^5 = -0.382683 -0.923880i
    .word 0xB9A8B9A8    # W16^6 = -0.707107 -0.707107i
    .word 0xB61FBB64    # W16^7 = -0.923880 -0.382683i
    # len = 32
    .word 0x00003C00    # W32^0 = 1.000000 +0.000000i
    .word 0xB23E3BD9    # W32^1 = 0.980785 -0.195090i
    .word 0xB61F3B64    # W32^2 = 0.923880 -0.382683i
    .word 0xB8723AA7    # W32^3 = 0.831470 -0.555570i
    .word 0xB9A839A8    # W32^4 = 0.707107 -0.707107i
    .word 0xBAA73872    # W32^5 = 0.555570 -0.831470i
    .word 0xBB64361F    # W32^6 = 0.382683 -0.923880i
    .word 0xBBD9323E    # W32^7 = 0.195090 -0.980785i
    .word 0xBC000000    # W32^8 = 0.000000 -1.000000i
    .word 0xBBD9B23E    # W32^9 = -0.195090 -0.980785i
    .word 0xBB64B61F    # W32^10 = -0.382683 -0.923880i
    .word 0xBAA7B872    # W32^11 = -0.555570 -0.831470i
    .word 0xB9A8B9A8    # W32^12 = -0.707107 -0.707107i
    .word 0xB872BAA7    # W32^13 = -0.831470 -0.555570i
    .word 0xB61FBB64    # W32^14 = -0.923880 -0.382683i
    .word 0xB23EBBD9    # W32^15 = -0.980785 -0.195090i
    # len = 64
    .word 0x00003C00    # W64^0 = 1.000000 +0.000000i
    .word 0xAE463BF6    # W64^1 = 0.995185 -0.098017i
    .word 0xB23E3BD9    # W64^2 = 0.980785 -0.195090i
    .word 0xB4A53BA8    # W64^3 = 0.956940 -0.290285i
    .word 0xB61F3B64    # W64^4 = 0.923880 -0.382683i
    .word 0xB78B3B0E    # W64^5 = 0.881921 -0.471397i
    .word 0xB8723AA7    # W64^6 = 0.831470 -0.555570i
    .word 0xB9133A2F    # W64^7 = 0.773010 -0.634393i
    .word 0xB9A839A8    # W64^8 = 0.707107 -0.707107i
    .word 0xBA2F3913    # W64^9 = 0.634393 -0.773010i
    .word 0xBAA73872    # W64^10 = 0.555570 -0.831470i
    .word 0xBB0E378B    # W64^11 = 0.471397 -0.881921i
    .word 0xBB64361F    # W64^12 = 0.382683 -0.923880i
    .word 0xBBA834A5    # W64^13 = 0.290285 -0.956940i
    .word 0xBBD9323E    # W64^14 = 0.195090 -0.980785i
    .word 0xBBF62E46    # W64^15 = 0.098017 -0.995185i
    .word 0xBC000000    # W64^16 = 0.000000 -1.000000i
    .word 0xBBF6AE46    # W64^17 = -0.098017 -0.995185i
    .word 0xBBD9B23E    # W64^18 = -0.195090 -0.980785i
    .word 0xBBA8B4A5    # W64^19 = -0.290285 -0.956940i
    .word 0xBB64B61F    # W64^20 = -0.382683 -0.923880i
    .word 0xBB0EB78B    # W64^21 = -0.471397 -0.881921i
    .word 0xBAA7B872    # W64^22 = -0.555570 -0.831470i
    .word 0xBA2FB913    # W64^23 = -0.634393 -0.773010i
    .word 0xB9A8B9A8    # W64^24 = -0.707107 -0.707107i
    .word 0xB913BA2F    # W64^25 = -0.773010 -0.634393i
    .word 0xB872BAA7    # W64^26 = -0.831470 -0.555570i
    .word 0xB78BBB0E    # W64^27 = -0.881921 -0.471397i
    .word 0xB61FBB64    # W64^28 = -0.923880 -0.382683i
    .word 0xB4A5BBA8    # W64^29 = -0.956940 -0.290285i
    .word 0xB23EBBD9    # W64^30 = -0.980785 -0.195090i
    .word 0xAE46BBF6    # W64^31 = -0.995185 -0.098017i
    # len = 128
    .word 0x00003C00    # W128^0 = 1.000000 +0.000000i
    .word 0xAA483BFE    # W128^1 = 0.998795 -0.049068i
    .word 0xAE463BF6    # W128^2 = 0.995185 -0.098017i
    .word 0xB0B23BEA    # W128^3 = 0.989177 -0.146730i
    .word 0xB23E3BD9    # W128^4 = 0.980785 -0.195090i
    .word 0xB3C63BC3    # W128^5 = 0.970031 -0.242980i
    .word 0xB4A53BA8    # W128^6 = 0.956940 -0.290285i
    .word 0xB5643B88    # W128^7 = 0.941544 -0.336890i
    .word 0xB61F3B64    # W128^8 = 0.923880 -0.382683i
    .word 0xB6D73B3B    # W128^9 = 0.903989 -0.427555i
    .word 0xB78B3B0E    # W128^10 = 0.881921 -0.471397i
    .word 0xB81D3ADD    # W128^11 = 0.857729 -0.514103i
    .word 0xB8723AA7    # W128^12 = 0.831470 -0.555570i
    .word 0xB8C43A6D    # W128^13 = 0.803208 -0.595699i
    .word 0xB9133A2F    # W128^14 = 0.773010 -0.634393i
    .word 0xB95F39ED    # W128^15 = 0.740951 -0.671559i
    .word 0xB9A839A8    # W128^16 = 0.707107 -0.707107i
    .word 0xB9ED395F    # W128^17 = 0.671559 -0.740951i
    .word 0xBA2F3913    # W128^18 = 0.634393 -0.773010i
    .word 0xBA6D38C4    # W128^19 = 0.595699 -0.803208i
    .word 0xBAA73872    # W128^20 = 0.555570 -0.831470i
    .word 0xBADD381D    # W128^21 = 0.514103 -0.857729i
    .word 0xBB0E378B    # W128^22 = 0.471397 -0.881921i
    .word 0xBB3B36D7    # W128^23 = 0.427555 -0.903989i
    .word 0xBB64361F    # W128^24 = 0.382683 -0.923880i
    .word 0xBB883564    # W128^25 = 0.336890 -0.941544i
    .word 0xBBA834A5    # W128^26 = 0.290285 -0.956940i
    .word 0xBBC333C6    # W128^27 = 0.242980 -0.970031i
    .word 0xBBD9323E    # W128^28 = 0.195090 -0.980785i
    .word 0xBBEA30B2    # W128^29 = 0.146730 -0.989177i
    .word 0xBBF62E46    # W128^30 = 0.098017 -0.995185i
    .word 0xBBFE2A48    # W128^31 = 0.049068 -0.998795i
    .word 0xBC000000    # W128^32 = 0.000000 -1.000000i
    .word 0xBBFEAA48    # W128^33 = -0.049068 -0.998795i
    .word 0xBBF6AE46    # W128^34 = -0.098017 -0.995185i
    .word 0xBBEAB0B2    # W128^35 = -0.146730 -0.989177i
    .word 0xBBD9B23E    # W128^36 = -0.195090 -0.980785i
    .word 0xBBC3B3C6    # W128^37 = -0.242980 -0.970031i
    .word 0xBBA8B4A5    # W128^38 = -0.290285 -0.956940i
    .word 0xBB88B564    # W128^39 = -0.336890 -0.941544i
    .word 0xBB64B61F    # W128^40 = -0.382683 -0.923880i
    .word 0xBB3BB6D7    # W128^41 = -0.427555 -0.903989i
    .word 0xBB0EB78B    # W128^42 = -0.471397 -0.881921i
    .word 0xBADDB81D    # W128^43 = -0.514103 -0.857729i
    .word 0xBAA7B872    # W128^44 = -0.555570 -0.831470i
    .word 0xBA6DB8C4    # W128^45 = -0.595699 -0.803208i
    .word 0xBA2FB913    # W128^46 = -0.634393 -0.773010i
    .word 0xB9EDB95F    # W128^47 = -0.671559 -0.740951i
    .word 0xB9A8B9A8    # W128^48 = -0.707107 -0.707107i
    .word 0xB95FB9ED    # W128^49 = -0.740951 -0.671559i
    .word 0xB913BA2F    # W128^50 = -0.773010 -0.634393i
    .word 0xB8C4BA6D    # W128^51 = -0.803208 -0.595699i
    .word 0xB872BAA7    # W128^52 = -0.831470 -0.555570i
    .word 0xB81DBADD    # W128^53 = -0.857729 -0.514103i
    .word 0xB78BBB0E    # W128^54 = -0.881921 -0.471397i
    .word 0xB6D7BB3B    # W128^55 = -0.903989 -0.427555i
    .word 0xB61FBB64    # W128^56 = -0.923880 -0.382683i
    .word 0xB564BB88    # W128^57 = -0.941544 -0.336890i
    .word 0xB4A5BBA8    # W128^58 = -0.956940 -0.290285i
    .word 0xB3C6BBC3    # W128^59 = -0.970031 -0.242980i
    .word 0xB23EBBD9    # W128^60 = -0.980785 -0.195090i
    .word 0xB0B2BBEA    # W128^61 = -0.989177 -0.146730i
    .word 0xAE46BBF6    # W128^62 = -0.995185 -0.098017i
    .word 0xAA48BBFE    # W128^63 = -0.998795 -0.049068i
    # len = 256
    .word 0x00003C00    # W256^0 = 1.000000 +0.000000i
    .word 0xA6483BFF    # W256^1 = 0.999699 -0.024541i
    .word 0xAA483BFE    # W256^2 = 0.998795 -0.049068i
    .word 0xACB53BFA    # W256^3 = 0.997290 -0.073565i
    .word 0xAE463BF6    # W256^4 = 0.995185 -0.098017i
    .word 0xAFD63BF1    # W256^5 = 0.992480 -0.122411i
    .word 0xB0B23BEA    # W256^6 = 0.989177 -0.146730i
    .word 0xB1793BE2    # W256^7 = 0.985278 -0.170962i
    .word 0xB23E3BD9    # W256^8 = 0.980785 -0.195090i
    .word 0xB3033BCE    # W256^9 = 0.975702 -0.219101i
    .word 0xB3C63BC3    # W256^10 = 0.970031 -0.242980i
    .word 0xB4443BB6    # W256^11 = 0.963776 -0.266713i
    .word 0xB4A53BA8    # W256^12 = 0.956940 -0.290285i
    .word 0xB5053B99    # W256^13 = 0.949528 -0.313682i
    .word 0xB5643B88    # W256^14 = 0.941544 -0.336890i
    .word 0xB5C23B77    # W256^15 = 0.932993 -0.359895i
    .word 0xB61F3B64    # W256^16 = 0.923880 -0.382683i
    .word 0xB67C3B50    # W256^17 = 0.914210 -0.405241i
    .word 0xB6D73B3B    # W256^18 = 0.903989 -0.427555i
    .word 0xB7323B25    # W256^19 = 0.893224 -0.449611i
    .word 0xB78B3B0E    # W256^20 = 0.881921 -0.471397i
    .word 0xB7E33AF6    # W256^21 = 0.870087 -0.492898i
    .word 0xB81D3ADD    # W256^22 = 0.857729 -0.514103i
    .word 0xB8483AC2    # W256^23 = 0.844854 -0.534998i
    .word 0xB8723AA7    # W256^24 = 0.831470 -0.555570i
    .word 0xB89B3A8A    # W256^25 = 0.817585 -0.575808i
    .word 0xB8C43A6D    # W256^26 = 0.803208 -0.595699i
    .word 0xB8EC3A4F    # W256^27 = 0.788346 -0.615232i
    .word 0xB9133A2F    # W256^28 = 0.773010 -0.634393i
    .word 0xB93A3A0F    # W256^29 = 0.757209 -0.653173i
    .word 0xB95F39ED    # W256^30 = 0.740951 -0.671559i
    .word 0xB98439CB    # W256^31 = 0.724247 -0.689541i
    .word 0xB9A839A8    # W256^32 = 0.707107 -0.707107i
    .word 0xB9CB3984    # W256^33 = 0.689541 -0.724247i
    .word 0xB9ED395F    # W256^34 = 0.671559 -0.740951i
    .word 0xBA0F393A    # W256^35 = 0.653173 -0.757209i
    .word 0xBA2F3913    # W256^36 = 0.634393 -0.773010i
    .word 0xBA4F38EC    # W256^37 = 0.615232 -0.788346i
    .word 0xBA6D38C4    # W256^38 = 0.595699 -0.803208i
    .word 0xBA8A389B    # W256^39 = 0.575808 -0.817585i
    .word 0xBAA73872    # W256^40 = 0.555570 -0.831470i
    .word 0xBAC23848    # W256^41 = 0.534998 -0.844854i
    .word 0xBADD381D    # W256^42 = 0.514103 -0.857729i
    .word 0xBAF637E3    # W256^43 = 0.492898 -0.870087i
    .word 0xBB0E378B    # W256^44 = 0.471397 -0.881921i
    .word 0xBB253732    # W256^45 = 0.449611 -0.893224i
    .word 0xBB3B36D7    # W256^46 = 0.427555 -0.903989i
    .word 0xBB50367C    # W256^47 = 0.405241 -0.914210i
    .word 0xBB64361F    # W256^48 = 0.382683 -0.923880i
    .word 0xBB7735C2    # W256^49 = 0.359895 -0.932993i
    .word 0xBB883564    # W256^50 = 0.336890 -0.941544i
    .word 0xBB993505    # W256^51 = 0.313682 -0.949528i
    .word 0xBBA834A5    # W256^52 = 0.290285 -0.956940i
    .word 0xBBB63444    # W256^53 = 0.266713 -0.963776i
    .word 0xBBC333C6    # W256^54 = 0.242980 -0.970031i
    .word 0xBBCE3303    # W256^55 = 0.219101 -0.975702i
    .word 0xBBD9323E    # W256^56 = 0.195090 -0.980785i
    .word 0xBBE23179    # W256^57 = 0.170962 -0.985278i
    .word 0xBBEA30B2    # W256^58 = 0.146730 -0.989177i
    .word 0xBBF12FD6    # W256^59 = 0.122411 -0.992480i
    .word 0xBBF62E46    # W256^60 = 0.098017 -0.995185i
    .word 0xBBFA2CB5    # W256^61 = 0.073565 -0.997290i
    .word 0xBBFE2A48    # W256^62 = 0.049068 -0.998795i
    .word 0xBBFF2648    # W256^63 = 0.024541 -0.999699i
    .word 0xBC000000    # W256^64 = 0.000000 -1.000000i
    .word 0xBBFFA648    # W256^65 = -0.024541 -0.999699i
    .word 0xBBFEAA48    # W256^66 = -0.049068 -0.998795i
    .word 0xBBFAACB5    # W256^67 = -0.073565 -0.997290i
    .word 0xBBF6AE46    # W256^68 = -0.098017 -0.995185i
    .word 0xBBF1AFD6    # W256^69 = -0.122411 -0.992480i
    .word 0xBBEAB0B2    # W256^70 = -0.146730 -0.989177i
    .word 0xBBE2B179    # W256^71 = -0.170962 -0.985278i
    .word 0xBBD9B23E    # W256^72 = -0.195090 -0.980785i
    .word 0xBBCEB303    # W256^73 = -0.219101 -0.975702i
    .word 0xBBC3B3C6    # W256^74 = -0.242980 -0.970031i
    .word 0xBBB6B444    # W256^75 = -0.266713 -0.963776i
    .word 0xBBA8B4A5    # W256^76 = -0.290285 -0.956940i
    .word 0xBB99B505    # W256^77 = -0.313682 -0.949528i
    .word 0xBB88B564    # W256^78 = -0.336890 -0.941544i
    .word 0xBB77B5C2    # W256^79 = -0.359895 -0.932993i
    .word 0xBB64B61F    # W256^80 = -0.382683 -0.923880i
    .word 0xBB50B67C    # W256^81 = -0.405241 -0.914210i
    .word 0xBB3BB6D7    # W256^82 = -0.427555 -0.903989i
    .word 0xBB25B732    # W256^83 = -0.449611 -0.893224i
    .word 0xBB0EB78B    # W256^84 = -0.471397 -0.881921i
    .word 0xBAF6B7E3    # W256^85 = -0.492898 -0.870087i
    .word 0xBADDB81D    # W256^86 = -0.514103 -0.857729i
    .word 0xBAC2B848    # W256^87 = -0.534998 -0.844854i
    .word 0xBAA7B872    # W256^88 = -0.555570 -0.831470i
    .word 0xBA8AB89B    # W256^89 = -0.575808 -0.817585i
    .word 0xBA6DB8C4    # W256^90 = -0.595699 -0.803208i
    .word 0xBA4FB8EC    # W256^91 = -0.615232 -0.788346i
    .word 0xBA2FB913    # W256^92 = -0.634393 -0.773010i
    .word 0xBA0FB93A    # W256^93 = -0.653173 -0.757209i
    .word 0xB9EDB95F    # W256^94 = -0.671559 -0.740951i
    .word 0xB9CBB984    # W256^95 = -0.689541 -0.724247i
    .word 0xB9A8B9A8    # W256^96 = -0.707107 -0.707107i
    .word 0xB984B9CB    # W256^97 = -0.724247 -0.689541i
    .word 0xB95FB9ED    # W256^98 = -0.740951 -0.671559i
    .word 0xB93ABA0F    # W256^99 = -0.757209 -0.653173i
    .word 0xB913BA2F    # W256^100 = -0.773010 -0.634393i
    .word 0xB8ECBA4F    # W256^101 = -0.788346 -0.615232i
    .word 0xB8C4BA6D    # W256^102 = -0.803208 -0.595699i
    .word 0xB89BBA8A    # W256^103 = -0.817585 -0.575808i
    .word 0xB872BAA7    # W256^104 = -0.831470 -0.555570i
    .word 0xB848BAC2    # W256^105 = -0.844854 -0.534998i
    .word 0xB81DBADD    # W256^106 = -0.857729 -0.514103i
    .word 0xB7E3BAF6    # W256^107 = -0.870087 -0.492898i
    .word 0xB78BBB0E    # W256^108 = -0.881921 -0.471397i
    .word 0xB732BB25    # W256^109 = -0.893224 -0.449611i
    .word 0xB6D7BB3B    # W256^110 = -0.903989 -0.427555i
    .word 0xB67CBB50    # W256^111 = -0.914210 -0.405241i
    .word 0xB61FBB64    # W256^112 = -0.923880 -0.382683i
    .word 0xB5C2BB77    # W256^113 = -0.932993 -0.359895i
    .word 0xB564BB88    # W256^114 = -0.941544 -0.336890i
    .word 0xB505BB99    # W256^115 = -0.949528 -0.313682i
    .word 0xB4A5BBA8    # W256^116 = -0.956940 -0.290285i
    .word 0xB444BBB6    # W256^117 = -0.963776 -0.266713i
    .word 0xB3C6BBC3    # W256^118 = -0.970031 -0.242980i
    .word 0xB303BBCE    # W256^119 = -0.975702 -0.219101i
    .word 0xB23EBBD9    # W256^120 = -0.980785 -0.195090i
    .word 0xB179BBE2    # W256^121 = -0.985278 -0.170962i
    .word 0xB0B2BBEA    # W256^122 = -0.989177 -0.146730i
    .word 0xAFD6BBF1    # W256^123 = -0.992480 -0.122411i
    .word 0xAE46BBF6    # W256^124 = -0.995185 -0.098017i
    .word 0xACB5BBFA    # W256^125 = -0.997290 -0.073565i
    .word 0xAA48BBFE    # W256^126 = -0.998795 -0.049068i
    .word 0xA648BBFF    # W256^127 = -0.999699 -0.024541i

# 32-byte scratch for the len-2 lane shuffle: E @0, O @8, S @16, D @24
scratch: .word 0, 0, 0, 0, 0, 0, 0, 0

.text
main:
    la   s0, x
    li   s1, 256

# ============================================================
# BIT REVERSAL (one complex sample = one 32-bit word)
# ============================================================
    li   t0, 1
    li   t1, 0
    srli t2, s1, 1            # mask = N/2
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
    slli t3, t0, 2
    add  t3, s0, t3
    slli t4, t1, 2
    add  t4, s0, t4
    lw   t5, 0(t3)
    lw   t6, 0(t4)
    sw   t6, 0(t3)
    sw   t5, 0(t4)
bitrev_next:
    addi t0, t0, 1
    srli t2, s1, 1
    j    bitrev_i

bitrev_done:
# ============================================================
# STAGE len = 2 (W = 1). Partners share a register, so regroup
# via scratch: E=(x0,x2), O=(x1,x3) -> S=E+O=(y0,y2), D=E-O=(y1,y3)
# ============================================================
    la   a7, scratch
    li   t1, 0
len2_loop:
    bge  t1, s1, len2_done
    slli a0, t1, 2
    add  a0, s0, a0
    lw   t2, 0(a0)             # x0
    lw   t3, 4(a0)             # x1
    lw   t4, 8(a0)             # x2
    lw   t5, 12(a0)            # x3
    sw   t2, 0(a7)             # E = (x0, x2)
    sw   t4, 4(a7)
    sw   t3, 8(a7)             # O = (x1, x3)
    sw   t5, 12(a7)
    vld    v0, 0(a7)
    vld    v1, 8(a7)
    vadd.h v2, v0, v1
    vsub.h v3, v0, v1
    vsd    v2, 16(a7)
    vsd    v3, 24(a7)
    lw   t2, 16(a7)            # y0
    lw   t3, 20(a7)            # y2
    lw   t4, 24(a7)            # y1
    lw   t5, 28(a7)            # y3
    sw   t2, 0(a0)
    sw   t4, 4(a0)
    sw   t3, 8(a0)
    sw   t5, 12(a0)
    addi t1, t1, 4
    j    len2_loop

len2_done:
    li   t0, 4                 # stage length
    la   s2, tw_table

stage_loop:
    blt  s1, t0, fft_done
    srli t3, t0, 1             # half
    li   t1, 0
    li   t4, 8
    blt  t3, t4, mid_stage     # half = 2 or 4

# ============================================================
# half >= 8: 8 butterflies per iteration (4 regs x 2 complex)
# ============================================================
block_loop8:
    bge  t1, s1, stage_done
    li   t2, 0
butterfly_loop8:
    bge  t2, t3, butterfly_done8
    add  a0, t1, t2            # a0 = &x[i+j]
    slli a0, a0, 2
    add  a0, s0, a0
    slli a1, t3, 2             # a1 = &x[i+j+half]
    add  a1, a0, a1
    slli a2, t2, 2             # a2 = &W_len[j]
    add  a2, s2, a2

    vld  v0,  0(a0)
    vld  v1,  8(a0)
    vld  v2, 16(a0)
    vld  v3, 24(a0)
    vld  v4,  0(a1)
    vld  v5,  8(a1)
    vld  v6, 16(a1)
    vld  v7, 24(a1)
    vld  v8,  0(a2)
    vld  v9,  8(a2)
    vld  v10, 16(a2)
    vld  v11, 24(a2)

    vcompl.h v12, v4, v8       # T = B * W
    vcompl.h v13, v5, v9
    vcompl.h v14, v6, v10
    vcompl.h v15, v7, v11

    vadd.h v16, v0, v12        # A' = A + T
    vadd.h v17, v1, v13
    vadd.h v18, v2, v14
    vadd.h v19, v3, v15
    vsub.h v20, v0, v12        # B' = A - T
    vsub.h v21, v1, v13
    vsub.h v22, v2, v14
    vsub.h v23, v3, v15

    vsd  v16,  0(a0)
    vsd  v17,  8(a0)
    vsd  v18, 16(a0)
    vsd  v19, 24(a0)
    vsd  v20,  0(a1)
    vsd  v21,  8(a1)
    vsd  v22, 16(a1)
    vsd  v23, 24(a1)

    addi t2, t2, 8
    j    butterfly_loop8
butterfly_done8:
    add  t1, t1, t0
    j    block_loop8

# ============================================================
# half = 2 or 4 (len 4, 8): 2 butterflies per iteration
# ============================================================
mid_stage:
mid_block:
    bge  t1, s1, stage_done
    li   t2, 0
mid_butterfly:
    bge  t2, t3, mid_butterfly_done
    add  a0, t1, t2
    slli a0, a0, 2
    add  a0, s0, a0
    slli a1, t3, 2
    add  a1, a0, a1
    slli a2, t2, 2
    add  a2, s2, a2
    vld      v0, 0(a0)
    vld      v1, 0(a1)
    vld      v8, 0(a2)
    vcompl.h v4, v1, v8
    vadd.h   v5, v0, v4
    vsub.h   v6, v0, v4
    vsd      v5, 0(a0)
    vsd      v6, 0(a1)
    addi t2, t2, 2
    j    mid_butterfly
mid_butterfly_done:
    add  t1, t1, t0
    j    mid_block

stage_done:
    slli t4, t3, 2             # skip half*4 bytes of twiddles
    add  s2, s2, t4
    slli t0, t0, 1
    j    stage_loop

fft_done:
    ebreak
