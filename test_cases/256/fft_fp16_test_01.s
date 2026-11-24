# Packed-fp16 radix-2 DIT FFT, N = 256
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0xBB1038BF    # x[0]
    .word 0x39CE382A    # x[1]
    .word 0x3A71BA8A    # x[2]
    .word 0xB1F93893    # x[3]
    .word 0x34C5B404    # x[4]
    .word 0x309DB257    # x[5]
    .word 0xBB3032E6    # x[6]
    .word 0x36AC3796    # x[7]
    .word 0x36E13AC1    # x[8]
    .word 0x379634FC    # x[9]
    .word 0x1C0DB900    # x[10]
    .word 0x3AD23A52    # x[11]
    .word 0x3A0BBBB2    # x[12]
    .word 0xB1FA345D    # x[13]
    .word 0x39CEB9ED    # x[14]
    .word 0x31F1B7E1    # x[15]
    .word 0x2F3BBACC    # x[16]
    .word 0xB630B2E9    # x[17]
    .word 0xBB6FB957    # x[18]
    .word 0x32E639F9    # x[19]
    .word 0x3114BBE9    # x[20]
    .word 0xB8CA3844    # x[21]
    .word 0x397A3ADF    # x[22]
    .word 0x3BD02CF4    # x[23]
    .word 0xBB62B883    # x[24]
    .word 0xB916B426    # x[25]
    .word 0xBA293B24    # x[26]
    .word 0x39D0B4B5    # x[27]
    .word 0xBA93BB57    # x[28]
    .word 0xB48028D6    # x[29]
    .word 0x3575BBA8    # x[30]
    .word 0xBB1F3977    # x[31]
    .word 0xBA0FB9F2    # x[32]
    .word 0x34CEAA69    # x[33]
    .word 0x3941B788    # x[34]
    .word 0x3A67BA75    # x[35]
    .word 0xBA25B86A    # x[36]
    .word 0x2F51B8C7    # x[37]
    .word 0xBA463A54    # x[38]
    .word 0x2B51331B    # x[39]
    .word 0x388EAA5E    # x[40]
    .word 0x3A6BB7F0    # x[41]
    .word 0xB2FFB56F    # x[42]
    .word 0x2D4D1CFA    # x[43]
    .word 0x39113699    # x[44]
    .word 0xB9FB3A8A    # x[45]
    .word 0x384CB90E    # x[46]
    .word 0xB7E3388C    # x[47]
    .word 0x39E53A21    # x[48]
    .word 0xBA2BBAFF    # x[49]
    .word 0x39DABA79    # x[50]
    .word 0xB80839E8    # x[51]
    .word 0xB8C93A3F    # x[52]
    .word 0x2B87AC3B    # x[53]
    .word 0xBA0B30DB    # x[54]
    .word 0x3A3EBB0B    # x[55]
    .word 0x15CE3883    # x[56]
    .word 0x38C2352B    # x[57]
    .word 0xB825BAFC    # x[58]
    .word 0x34BF36F5    # x[59]
    .word 0xB9C1AF4E    # x[60]
    .word 0xB708BAFF    # x[61]
    .word 0xAEA7337A    # x[62]
    .word 0x3AD23443    # x[63]
    .word 0xB7C7A818    # x[64]
    .word 0x3B6D3A4A    # x[65]
    .word 0x3A80AC4F    # x[66]
    .word 0xB9FEB012    # x[67]
    .word 0x3AC02A3E    # x[68]
    .word 0xB896360E    # x[69]
    .word 0x3B63BA71    # x[70]
    .word 0x326534A3    # x[71]
    .word 0x3A523717    # x[72]
    .word 0xA8763858    # x[73]
    .word 0xB97AB953    # x[74]
    .word 0xB70D2D6C    # x[75]
    .word 0xB3063A69    # x[76]
    .word 0xBBF73986    # x[77]
    .word 0x39E7BA1B    # x[78]
    .word 0xB64B2DAD    # x[79]
    .word 0xB41E328A    # x[80]
    .word 0x3A372FDD    # x[81]
    .word 0x36BE207B    # x[82]
    .word 0xB272AED0    # x[83]
    .word 0xB87E3209    # x[84]
    .word 0x3A402BC5    # x[85]
    .word 0xB4B63796    # x[86]
    .word 0xBB3BBA04    # x[87]
    .word 0xB8C0B113    # x[88]
    .word 0xB8B5B0F5    # x[89]
    .word 0xBA1637E5    # x[90]
    .word 0xB2223527    # x[91]
    .word 0x3B94364B    # x[92]
    .word 0xBAFEAF17    # x[93]
    .word 0x3A47AEAD    # x[94]
    .word 0x3372AB74    # x[95]
    .word 0xBA54BB42    # x[96]
    .word 0x371BBB2F    # x[97]
    .word 0x3A46B4E4    # x[98]
    .word 0xBAE4338B    # x[99]
    .word 0x31F13BDF    # x[100]
    .word 0xB9D7BB78    # x[101]
    .word 0x3A243924    # x[102]
    .word 0xB94A37B0    # x[103]
    .word 0x32AFB586    # x[104]
    .word 0x359A3A51    # x[105]
    .word 0xB6AA2BC9    # x[106]
    .word 0xB2333013    # x[107]
    .word 0xB8C7B788    # x[108]
    .word 0xAAB3BB86    # x[109]
    .word 0xBA1838EE    # x[110]
    .word 0x382C3BE9    # x[111]
    .word 0xB5C6379A    # x[112]
    .word 0x320E385E    # x[113]
    .word 0xBBAEA2F2    # x[114]
    .word 0x34D5BAC6    # x[115]
    .word 0x3A2BBACB    # x[116]
    .word 0x393FBAA4    # x[117]
    .word 0x33963107    # x[118]
    .word 0xBB9D318F    # x[119]
    .word 0xB5C533B7    # x[120]
    .word 0xB19D399D    # x[121]
    .word 0x2E5CBBC7    # x[122]
    .word 0x386B34F6    # x[123]
    .word 0x3A333B02    # x[124]
    .word 0xBA4CAF0F    # x[125]
    .word 0x35EDB713    # x[126]
    .word 0xB7442B31    # x[127]
    .word 0x38D4BA4D    # x[128]
    .word 0x31B12CEA    # x[129]
    .word 0xB4B6353B    # x[130]
    .word 0x3949B700    # x[131]
    .word 0xB92D3510    # x[132]
    .word 0x3B083B89    # x[133]
    .word 0xBA6D2CFE    # x[134]
    .word 0xBACD366B    # x[135]
    .word 0x30B03861    # x[136]
    .word 0x38983729    # x[137]
    .word 0x3BAC3B0B    # x[138]
    .word 0x377F372A    # x[139]
    .word 0x31AE35FF    # x[140]
    .word 0xAF3F353E    # x[141]
    .word 0xB855AE47    # x[142]
    .word 0x383C37F2    # x[143]
    .word 0xBB49B1B0    # x[144]
    .word 0xB0A931F7    # x[145]
    .word 0xB1413BBE    # x[146]
    .word 0xB858A2B0    # x[147]
    .word 0xBB5439D2    # x[148]
    .word 0x3AD439AE    # x[149]
    .word 0xB523AEDA    # x[150]
    .word 0xBB65B7C7    # x[151]
    .word 0xB8EA37FA    # x[152]
    .word 0xB87B3620    # x[153]
    .word 0xAFD4B78C    # x[154]
    .word 0x38E5351F    # x[155]
    .word 0xB501AA7B    # x[156]
    .word 0x3A7A3B1B    # x[157]
    .word 0x2EBBB495    # x[158]
    .word 0xBAD7BB0B    # x[159]
    .word 0xBA563B47    # x[160]
    .word 0xB95BB690    # x[161]
    .word 0x3024BB87    # x[162]
    .word 0x3BA338F5    # x[163]
    .word 0xB7BBBAB9    # x[164]
    .word 0x3275BBAE    # x[165]
    .word 0xB93FBB25    # x[166]
    .word 0x3AAC35C2    # x[167]
    .word 0xAD07B990    # x[168]
    .word 0x31A1AD25    # x[169]
    .word 0xB8F22B13    # x[170]
    .word 0x3ADFB814    # x[171]
    .word 0xBA73B187    # x[172]
    .word 0xB5CFB987    # x[173]
    .word 0xB8A63605    # x[174]
    .word 0x32F5BA39    # x[175]
    .word 0x375C2FF2    # x[176]
    .word 0x395F3966    # x[177]
    .word 0x37782E22    # x[178]
    .word 0x35763646    # x[179]
    .word 0x9EC5BBAB    # x[180]
    .word 0x396328F6    # x[181]
    .word 0xB9C4BBCB    # x[182]
    .word 0x34A5ABAF    # x[183]
    .word 0xB1592516    # x[184]
    .word 0xBA4B2306    # x[185]
    .word 0xB26638DF    # x[186]
    .word 0xBA5021D7    # x[187]
    .word 0x35BA39E5    # x[188]
    .word 0x369936A7    # x[189]
    .word 0x3B8A2E88    # x[190]
    .word 0xB51EA8BF    # x[191]
    .word 0x3521398E    # x[192]
    .word 0x36B7340B    # x[193]
    .word 0xB907BA9B    # x[194]
    .word 0x2EE83982    # x[195]
    .word 0xB5E7B889    # x[196]
    .word 0x3712AE65    # x[197]
    .word 0x395939A5    # x[198]
    .word 0xBBB63641    # x[199]
    .word 0x3A47B991    # x[200]
    .word 0x3445AF1F    # x[201]
    .word 0x2C37AFC4    # x[202]
    .word 0xBADC3BAF    # x[203]
    .word 0xB90D3383    # x[204]
    .word 0x39533305    # x[205]
    .word 0x341A3816    # x[206]
    .word 0x38AEB508    # x[207]
    .word 0x38BFBA01    # x[208]
    .word 0x3999BAA4    # x[209]
    .word 0x3A2236D7    # x[210]
    .word 0x3881B95B    # x[211]
    .word 0x39B4B24E    # x[212]
    .word 0xB6E9390C    # x[213]
    .word 0xB8572897    # x[214]
    .word 0x3116B669    # x[215]
    .word 0xB88BBAED    # x[216]
    .word 0x1208B647    # x[217]
    .word 0xBAD4B701    # x[218]
    .word 0xB6463B7F    # x[219]
    .word 0x393A1F11    # x[220]
    .word 0x33B8B3C6    # x[221]
    .word 0x37A3B490    # x[222]
    .word 0x3BA13A6F    # x[223]
    .word 0x34E53999    # x[224]
    .word 0x348037A0    # x[225]
    .word 0x32C6B4D5    # x[226]
    .word 0x3AF0B57E    # x[227]
    .word 0xB9BC3BBB    # x[228]
    .word 0x353EBA63    # x[229]
    .word 0x34E22B71    # x[230]
    .word 0x38E6BBA3    # x[231]
    .word 0x37FB2FD6    # x[232]
    .word 0xB7A63248    # x[233]
    .word 0x3767B440    # x[234]
    .word 0x3AE53BD6    # x[235]
    .word 0xB5C5B8F7    # x[236]
    .word 0x3A7CB850    # x[237]
    .word 0x39503901    # x[238]
    .word 0x3777B12D    # x[239]
    .word 0x345B379F    # x[240]
    .word 0xB91136C5    # x[241]
    .word 0x3874B9D9    # x[242]
    .word 0x3B46B5AA    # x[243]
    .word 0x399DB78F    # x[244]
    .word 0x3A8B3B9B    # x[245]
    .word 0xB175356E    # x[246]
    .word 0x3A203837    # x[247]
    .word 0xAC84B7B7    # x[248]
    .word 0x31BC1C00    # x[249]
    .word 0xB8713B5C    # x[250]
    .word 0xB8352F02    # x[251]
    .word 0xB916BBFC    # x[252]
    .word 0xBA31B82C    # x[253]
    .word 0x297C3907    # x[254]
    .word 0xAE74AEEC    # x[255]

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
