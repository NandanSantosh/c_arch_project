# Packed-fp16 radix-2 DIT FFT, N = 256
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0xB10A295D    # x[0]
    .word 0xB9EAB877    # x[1]
    .word 0x3409A81B    # x[2]
    .word 0x36A233C0    # x[3]
    .word 0xBB3BB022    # x[4]
    .word 0x389EB864    # x[5]
    .word 0x302CB10D    # x[6]
    .word 0x381C35A5    # x[7]
    .word 0xAC53B966    # x[8]
    .word 0x3AF534E3    # x[9]
    .word 0x3A68B703    # x[10]
    .word 0x2A453995    # x[11]
    .word 0x3AF83109    # x[12]
    .word 0xB6BEAFA9    # x[13]
    .word 0xBA6138C2    # x[14]
    .word 0x34A33700    # x[15]
    .word 0x3B07B2F5    # x[16]
    .word 0xB98632FE    # x[17]
    .word 0x3B45B153    # x[18]
    .word 0x38F7BAA3    # x[19]
    .word 0x38C22E47    # x[20]
    .word 0xBAA83ABD    # x[21]
    .word 0xA86DB0AA    # x[22]
    .word 0x3969A38D    # x[23]
    .word 0xB91FBB03    # x[24]
    .word 0x39203805    # x[25]
    .word 0xBA883B2C    # x[26]
    .word 0xBBD6393E    # x[27]
    .word 0xB84E38AA    # x[28]
    .word 0x34483AAF    # x[29]
    .word 0xB97DAB1B    # x[30]
    .word 0xB2D23A3F    # x[31]
    .word 0xBB913B1A    # x[32]
    .word 0xBB5DB075    # x[33]
    .word 0x3B4EB735    # x[34]
    .word 0xBB44B540    # x[35]
    .word 0x36B9B3F8    # x[36]
    .word 0x391A3707    # x[37]
    .word 0x2603BA22    # x[38]
    .word 0xB0ECB0F4    # x[39]
    .word 0xBA65323F    # x[40]
    .word 0x393839DC    # x[41]
    .word 0xB65231A8    # x[42]
    .word 0x30DABB80    # x[43]
    .word 0x3B713B46    # x[44]
    .word 0x3B763976    # x[45]
    .word 0xB6503686    # x[46]
    .word 0x3794381A    # x[47]
    .word 0x38D43563    # x[48]
    .word 0x3AC5397A    # x[49]
    .word 0x3A79B255    # x[50]
    .word 0x3703BAA7    # x[51]
    .word 0xB5FB346D    # x[52]
    .word 0xB3B72C9D    # x[53]
    .word 0x33983855    # x[54]
    .word 0x392C3535    # x[55]
    .word 0xBAC0B861    # x[56]
    .word 0x394D3A3B    # x[57]
    .word 0xB94CB846    # x[58]
    .word 0xB92738FA    # x[59]
    .word 0xB7A4B28E    # x[60]
    .word 0x3280B947    # x[61]
    .word 0xB020384C    # x[62]
    .word 0xB6933561    # x[63]
    .word 0x2A51B897    # x[64]
    .word 0x3B37BA62    # x[65]
    .word 0x3965B831    # x[66]
    .word 0x303BB2B1    # x[67]
    .word 0xB81BB779    # x[68]
    .word 0xAC9AB03C    # x[69]
    .word 0x35C5BBF5    # x[70]
    .word 0x358AB5FB    # x[71]
    .word 0x3AF73873    # x[72]
    .word 0xB529A9FE    # x[73]
    .word 0x310EB9F2    # x[74]
    .word 0xAC99B09F    # x[75]
    .word 0xB941B1FB    # x[76]
    .word 0xB9FCAFE9    # x[77]
    .word 0xBBB33B9E    # x[78]
    .word 0xB61FB5C5    # x[79]
    .word 0x3064B94E    # x[80]
    .word 0xBBF4B873    # x[81]
    .word 0xAE49B9A6    # x[82]
    .word 0xBB64B4D6    # x[83]
    .word 0xBAFCB8CB    # x[84]
    .word 0xB44F399C    # x[85]
    .word 0x3809399F    # x[86]
    .word 0x366AB72B    # x[87]
    .word 0x348A2410    # x[88]
    .word 0xB6343B0C    # x[89]
    .word 0xB73134C0    # x[90]
    .word 0xB35BB652    # x[91]
    .word 0x3B903B43    # x[92]
    .word 0x3AE3353D    # x[93]
    .word 0x24D9B871    # x[94]
    .word 0xB8343B7B    # x[95]
    .word 0xB35B3252    # x[96]
    .word 0xBA48B8A8    # x[97]
    .word 0x321FBB08    # x[98]
    .word 0x3B19BAB9    # x[99]
    .word 0x383BB7D2    # x[100]
    .word 0x3B402957    # x[101]
    .word 0x3A6AB912    # x[102]
    .word 0x3A2C3879    # x[103]
    .word 0xB7F33311    # x[104]
    .word 0xBB8AB0CA    # x[105]
    .word 0x3689BAFB    # x[106]
    .word 0xAE81BB83    # x[107]
    .word 0x36AEBB22    # x[108]
    .word 0xB8C73782    # x[109]
    .word 0xBBF7BA0E    # x[110]
    .word 0xBB57AB11    # x[111]
    .word 0xB58AB9AE    # x[112]
    .word 0x36223A54    # x[113]
    .word 0x3982399D    # x[114]
    .word 0x1CB4BA0C    # x[115]
    .word 0xBB5D39B0    # x[116]
    .word 0x36C338A0    # x[117]
    .word 0x371734EB    # x[118]
    .word 0x3966A5DD    # x[119]
    .word 0x3AE9324E    # x[120]
    .word 0x2CF9B04B    # x[121]
    .word 0xB6D13109    # x[122]
    .word 0xB6343570    # x[123]
    .word 0xB368268B    # x[124]
    .word 0x33F43A51    # x[125]
    .word 0x369C3949    # x[126]
    .word 0x3BAA3BC4    # x[127]
    .word 0xB964BAC2    # x[128]
    .word 0x2DA23988    # x[129]
    .word 0x34CD2C14    # x[130]
    .word 0x3859B564    # x[131]
    .word 0xA8A2B995    # x[132]
    .word 0xBAA63B4B    # x[133]
    .word 0x34FDBAC7    # x[134]
    .word 0xB4603A2B    # x[135]
    .word 0x3580310C    # x[136]
    .word 0x38D13763    # x[137]
    .word 0xB78B3B23    # x[138]
    .word 0x3A24BB45    # x[139]
    .word 0x287533D2    # x[140]
    .word 0xB8AAB4C6    # x[141]
    .word 0xB458BBCA    # x[142]
    .word 0xBA64B6AF    # x[143]
    .word 0xAD223B0B    # x[144]
    .word 0xB1D43AFC    # x[145]
    .word 0x33F73424    # x[146]
    .word 0x3795B4E6    # x[147]
    .word 0x3BD4B516    # x[148]
    .word 0xA047BB7D    # x[149]
    .word 0x2FE0B709    # x[150]
    .word 0x3511B807    # x[151]
    .word 0x32AEB74D    # x[152]
    .word 0x2CDF3BB7    # x[153]
    .word 0xBB72B305    # x[154]
    .word 0xB8D92AC2    # x[155]
    .word 0xBB752E11    # x[156]
    .word 0xBAF4351B    # x[157]
    .word 0xAB7D3A25    # x[158]
    .word 0x3A5633C0    # x[159]
    .word 0x3A4234E8    # x[160]
    .word 0x36FDB19E    # x[161]
    .word 0xB9F9ACCA    # x[162]
    .word 0x34D631BC    # x[163]
    .word 0x39CCB7D7    # x[164]
    .word 0xB95E3686    # x[165]
    .word 0xB19A35D7    # x[166]
    .word 0x334ABACC    # x[167]
    .word 0x356E25C0    # x[168]
    .word 0xBB401A7C    # x[169]
    .word 0xB9CAA6AA    # x[170]
    .word 0xBBB6375A    # x[171]
    .word 0x396DB2A4    # x[172]
    .word 0x38FC31AE    # x[173]
    .word 0x328C38EF    # x[174]
    .word 0x3A6C2E8B    # x[175]
    .word 0xB5D4AD1D    # x[176]
    .word 0x3578B79D    # x[177]
    .word 0xB6B03B6C    # x[178]
    .word 0x3BE6B985    # x[179]
    .word 0x21FD323B    # x[180]
    .word 0xA8191A01    # x[181]
    .word 0xB9B23218    # x[182]
    .word 0x3620AE71    # x[183]
    .word 0xBB8F3652    # x[184]
    .word 0xB528B843    # x[185]
    .word 0xBA163A71    # x[186]
    .word 0x384D34BD    # x[187]
    .word 0x38F2B7AD    # x[188]
    .word 0xBA2B3AC2    # x[189]
    .word 0x27FBBB3A    # x[190]
    .word 0x24F7B593    # x[191]
    .word 0xABBC9F12    # x[192]
    .word 0x388635A8    # x[193]
    .word 0xB3ADB6EF    # x[194]
    .word 0xB39B319A    # x[195]
    .word 0x30D13BBB    # x[196]
    .word 0xB9AAAE52    # x[197]
    .word 0xB910B8E1    # x[198]
    .word 0x2F393930    # x[199]
    .word 0x33763347    # x[200]
    .word 0xAC7C2FA4    # x[201]
    .word 0xB94E3A11    # x[202]
    .word 0xB9623B1F    # x[203]
    .word 0xB9C3BA4D    # x[204]
    .word 0xB9E1BB77    # x[205]
    .word 0x3347B1B2    # x[206]
    .word 0xB3ED3867    # x[207]
    .word 0xB6D83303    # x[208]
    .word 0xB6533177    # x[209]
    .word 0xABE42DF6    # x[210]
    .word 0x3665B83D    # x[211]
    .word 0x39B2BB93    # x[212]
    .word 0x3B32B883    # x[213]
    .word 0x39A0A2D7    # x[214]
    .word 0x3835BBFB    # x[215]
    .word 0xB8303A0E    # x[216]
    .word 0xB93E3995    # x[217]
    .word 0xB5E83B17    # x[218]
    .word 0xBA3EB2A7    # x[219]
    .word 0x319934F9    # x[220]
    .word 0x36CC3971    # x[221]
    .word 0xB8EF35CA    # x[222]
    .word 0xB71B3B48    # x[223]
    .word 0x2D793814    # x[224]
    .word 0x35733BE9    # x[225]
    .word 0x35A63706    # x[226]
    .word 0xB93CB6FB    # x[227]
    .word 0x37DCA93F    # x[228]
    .word 0x32483453    # x[229]
    .word 0xB5D63933    # x[230]
    .word 0x360BB96B    # x[231]
    .word 0x32282C3B    # x[232]
    .word 0xB932B70F    # x[233]
    .word 0x39C63584    # x[234]
    .word 0x2C47B779    # x[235]
    .word 0xB8A73167    # x[236]
    .word 0x3BAD36B6    # x[237]
    .word 0xBAFD3B17    # x[238]
    .word 0xAC7BB9DC    # x[239]
    .word 0xB4E23BE2    # x[240]
    .word 0xB5E835C4    # x[241]
    .word 0x37F43BB5    # x[242]
    .word 0xB7F9B11E    # x[243]
    .word 0x33AB3B67    # x[244]
    .word 0xBB30303F    # x[245]
    .word 0x331EBAD4    # x[246]
    .word 0xBB593B4E    # x[247]
    .word 0x39B439B4    # x[248]
    .word 0xB76234B7    # x[249]
    .word 0x3783B2ED    # x[250]
    .word 0xB5D5B327    # x[251]
    .word 0xB5B5A0EE    # x[252]
    .word 0xB967372E    # x[253]
    .word 0xB07D385A    # x[254]
    .word 0x354826B1    # x[255]

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
