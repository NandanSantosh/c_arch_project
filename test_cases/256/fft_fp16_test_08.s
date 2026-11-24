# Packed-fp16 radix-2 DIT FFT, N = 256
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0x3B562913    # x[0]
    .word 0x36A9B51C    # x[1]
    .word 0xBB323ACE    # x[2]
    .word 0x393C352A    # x[3]
    .word 0x31D839FA    # x[4]
    .word 0xB4F8BA33    # x[5]
    .word 0x38A8BBD1    # x[6]
    .word 0xB872B583    # x[7]
    .word 0xBB5AB9A7    # x[8]
    .word 0xBA58B9B5    # x[9]
    .word 0xB4CEB852    # x[10]
    .word 0xB9A339DE    # x[11]
    .word 0xB806B86B    # x[12]
    .word 0x3945B852    # x[13]
    .word 0xAE70AFD0    # x[14]
    .word 0x3A68B515    # x[15]
    .word 0xAD70AFBA    # x[16]
    .word 0x35873017    # x[17]
    .word 0x3A90351C    # x[18]
    .word 0xB16830E8    # x[19]
    .word 0x2D53B48F    # x[20]
    .word 0xB9B3B823    # x[21]
    .word 0x9003BB0C    # x[22]
    .word 0x3852B5CE    # x[23]
    .word 0xACC4A77B    # x[24]
    .word 0x3A892CD1    # x[25]
    .word 0x37593A3B    # x[26]
    .word 0x3869BA60    # x[27]
    .word 0xBAA3B788    # x[28]
    .word 0xB97BBB27    # x[29]
    .word 0x3443B05C    # x[30]
    .word 0x3A62B817    # x[31]
    .word 0x35CB28E6    # x[32]
    .word 0x3835B95A    # x[33]
    .word 0xB1A3B5F2    # x[34]
    .word 0x340BBBA4    # x[35]
    .word 0x2EE3363A    # x[36]
    .word 0xB380B9B4    # x[37]
    .word 0x397BB8B6    # x[38]
    .word 0x3B35B56C    # x[39]
    .word 0x3773377A    # x[40]
    .word 0xB7903155    # x[41]
    .word 0x3BC73686    # x[42]
    .word 0x3766B508    # x[43]
    .word 0x38E4B822    # x[44]
    .word 0x36DCB809    # x[45]
    .word 0xB26A3908    # x[46]
    .word 0x339FBBCC    # x[47]
    .word 0xB09BB953    # x[48]
    .word 0xB839B8C8    # x[49]
    .word 0xA9CC3638    # x[50]
    .word 0xBB4FB97F    # x[51]
    .word 0x29803AA4    # x[52]
    .word 0x38B3361B    # x[53]
    .word 0xB9A63B56    # x[54]
    .word 0x370FBA87    # x[55]
    .word 0x3B0738EE    # x[56]
    .word 0x388838EA    # x[57]
    .word 0xB4DE3263    # x[58]
    .word 0x35B23A5E    # x[59]
    .word 0xBA29B6D0    # x[60]
    .word 0xB91B3B00    # x[61]
    .word 0x3B9BB737    # x[62]
    .word 0x321632EA    # x[63]
    .word 0xB5A8AEE5    # x[64]
    .word 0xBB453874    # x[65]
    .word 0x3BC8B1C8    # x[66]
    .word 0xB21DBA49    # x[67]
    .word 0xB66324FD    # x[68]
    .word 0xB991BB72    # x[69]
    .word 0x3A2DBB3A    # x[70]
    .word 0x19F0B65B    # x[71]
    .word 0xB90C385A    # x[72]
    .word 0xB6E2B77A    # x[73]
    .word 0x399AB9F5    # x[74]
    .word 0x3905B9CC    # x[75]
    .word 0xB465B90F    # x[76]
    .word 0x30D33B91    # x[77]
    .word 0xBB323B8F    # x[78]
    .word 0x357736D9    # x[79]
    .word 0x2968B80E    # x[80]
    .word 0xB802353E    # x[81]
    .word 0xBBB73A60    # x[82]
    .word 0xB778B8A2    # x[83]
    .word 0xB284B612    # x[84]
    .word 0xB94EA34A    # x[85]
    .word 0xB8B7B9E4    # x[86]
    .word 0xA85CBB24    # x[87]
    .word 0xADFE35C8    # x[88]
    .word 0x321939C9    # x[89]
    .word 0xB9B3AF2C    # x[90]
    .word 0x3534377F    # x[91]
    .word 0xB034BB96    # x[92]
    .word 0xB89CB812    # x[93]
    .word 0x3541B92C    # x[94]
    .word 0xB950BBB2    # x[95]
    .word 0xB0E7BB22    # x[96]
    .word 0x35F6A31F    # x[97]
    .word 0xB5F72EAA    # x[98]
    .word 0x3A2A2BAD    # x[99]
    .word 0xBA193528    # x[100]
    .word 0xAE6FB6A8    # x[101]
    .word 0x2F7B382B    # x[102]
    .word 0x37D5BA8A    # x[103]
    .word 0xB9643B3D    # x[104]
    .word 0xBB49B3CF    # x[105]
    .word 0xB047B8BA    # x[106]
    .word 0xB1673A4C    # x[107]
    .word 0xB9F5BB3A    # x[108]
    .word 0xB859B5CE    # x[109]
    .word 0x37B8B946    # x[110]
    .word 0x34AD3346    # x[111]
    .word 0x39AF34B2    # x[112]
    .word 0x3774BBD3    # x[113]
    .word 0xAD9DA81B    # x[114]
    .word 0xB83FB8E6    # x[115]
    .word 0xB01C3980    # x[116]
    .word 0x366338D6    # x[117]
    .word 0x3765B8C6    # x[118]
    .word 0x37AA302B    # x[119]
    .word 0xBBB2B69D    # x[120]
    .word 0xB5EFB9AA    # x[121]
    .word 0x3419B5A5    # x[122]
    .word 0x3688AC5C    # x[123]
    .word 0x1977B974    # x[124]
    .word 0x384B374F    # x[125]
    .word 0x3631B845    # x[126]
    .word 0x3B18B55A    # x[127]
    .word 0x3AC63099    # x[128]
    .word 0xB09BB60C    # x[129]
    .word 0x3A9EAC50    # x[130]
    .word 0xB77BA8EF    # x[131]
    .word 0x3B123950    # x[132]
    .word 0x369B3973    # x[133]
    .word 0x3A2A345B    # x[134]
    .word 0xB1643A9F    # x[135]
    .word 0xB8B62070    # x[136]
    .word 0xB6FE3600    # x[137]
    .word 0x32452C02    # x[138]
    .word 0x37D7348F    # x[139]
    .word 0x3B963A30    # x[140]
    .word 0x320D3851    # x[141]
    .word 0x39B03B32    # x[142]
    .word 0x3828B907    # x[143]
    .word 0x35FA3805    # x[144]
    .word 0x378D34B2    # x[145]
    .word 0xB922B992    # x[146]
    .word 0xBBA6B866    # x[147]
    .word 0x2F3039F2    # x[148]
    .word 0x35223843    # x[149]
    .word 0x3420353D    # x[150]
    .word 0x231E3794    # x[151]
    .word 0xBAD3B816    # x[152]
    .word 0xB3A5B780    # x[153]
    .word 0xB8D3B74E    # x[154]
    .word 0x3BF02E57    # x[155]
    .word 0xB726B1A9    # x[156]
    .word 0x38D9BA66    # x[157]
    .word 0x3875397A    # x[158]
    .word 0xB8CE3706    # x[159]
    .word 0xB6F8BAFB    # x[160]
    .word 0x3484BBC4    # x[161]
    .word 0xBAFA3233    # x[162]
    .word 0x2F15390D    # x[163]
    .word 0x342CB458    # x[164]
    .word 0xB57E327C    # x[165]
    .word 0x33E6BA88    # x[166]
    .word 0x37B93513    # x[167]
    .word 0xBA3CB9AB    # x[168]
    .word 0xB6B839DA    # x[169]
    .word 0x3630AF0A    # x[170]
    .word 0xB4272E31    # x[171]
    .word 0x30B13962    # x[172]
    .word 0xBADB330B    # x[173]
    .word 0x3415342F    # x[174]
    .word 0x36A3B664    # x[175]
    .word 0xB95AB9CD    # x[176]
    .word 0xB0A0328A    # x[177]
    .word 0x3BCAAD16    # x[178]
    .word 0xB211B83A    # x[179]
    .word 0x3A00BA94    # x[180]
    .word 0x329836D3    # x[181]
    .word 0xB28A3B5B    # x[182]
    .word 0xAC68388E    # x[183]
    .word 0xBB5634DB    # x[184]
    .word 0xBB42BB81    # x[185]
    .word 0xBB48AF5F    # x[186]
    .word 0xBB49B534    # x[187]
    .word 0xB4DFB89C    # x[188]
    .word 0x3AC2B468    # x[189]
    .word 0xB24E3B0E    # x[190]
    .word 0xB598B934    # x[191]
    .word 0xA27EA73B    # x[192]
    .word 0x3A472EEE    # x[193]
    .word 0x3A7DB5C2    # x[194]
    .word 0xB4213067    # x[195]
    .word 0x3BEE3991    # x[196]
    .word 0x3A1BB43A    # x[197]
    .word 0x3B44B700    # x[198]
    .word 0x2F0CB82E    # x[199]
    .word 0xB50F3530    # x[200]
    .word 0xB8C2B80F    # x[201]
    .word 0xB6F4BB94    # x[202]
    .word 0xBB7A32D0    # x[203]
    .word 0xB8B439B1    # x[204]
    .word 0xB5A93417    # x[205]
    .word 0x3766B2E2    # x[206]
    .word 0x35882DDB    # x[207]
    .word 0x340AB412    # x[208]
    .word 0x3BFB310A    # x[209]
    .word 0x2CE0ADFE    # x[210]
    .word 0x397ABA9D    # x[211]
    .word 0xB848BB66    # x[212]
    .word 0x25BCB8A1    # x[213]
    .word 0xBB7B3AD5    # x[214]
    .word 0x392AB66E    # x[215]
    .word 0xB5D4B64D    # x[216]
    .word 0x33F7380C    # x[217]
    .word 0x34272EE0    # x[218]
    .word 0x39A430AA    # x[219]
    .word 0x34A2B647    # x[220]
    .word 0xB8323B09    # x[221]
    .word 0x30CD30E4    # x[222]
    .word 0x3AA9B8B2    # x[223]
    .word 0x39413AC8    # x[224]
    .word 0xB6213227    # x[225]
    .word 0x36FB3AD3    # x[226]
    .word 0x29D3392C    # x[227]
    .word 0xB0502691    # x[228]
    .word 0x39DB9E99    # x[229]
    .word 0xB95BAD25    # x[230]
    .word 0x3A7D3521    # x[231]
    .word 0xB28A3B17    # x[232]
    .word 0x38FEA1AE    # x[233]
    .word 0xB493BA53    # x[234]
    .word 0x3AC2BA41    # x[235]
    .word 0xAD31B18C    # x[236]
    .word 0x34A13A84    # x[237]
    .word 0x3A6B389B    # x[238]
    .word 0x3B7CBA78    # x[239]
    .word 0x3BF83651    # x[240]
    .word 0x3BA1B794    # x[241]
    .word 0xB777B5B0    # x[242]
    .word 0xB1443B6B    # x[243]
    .word 0xB6C33240    # x[244]
    .word 0xB4DB39C6    # x[245]
    .word 0xB8A1BBEC    # x[246]
    .word 0x388D38F4    # x[247]
    .word 0x3656B482    # x[248]
    .word 0xB822388D    # x[249]
    .word 0x3905B370    # x[250]
    .word 0x3BA8B580    # x[251]
    .word 0x332A3983    # x[252]
    .word 0x3A4FAA6B    # x[253]
    .word 0x34113B67    # x[254]
    .word 0x3A77AD8A    # x[255]

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

    vcmpl.h v12, v4, v8       # T = B * W
    vcmpl.h v13, v5, v9
    vcmpl.h v14, v6, v10
    vcmpl.h v15, v7, v11

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
    vcmpl.h v4, v1, v8
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
