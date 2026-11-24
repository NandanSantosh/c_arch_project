# Packed-fp16 radix-2 DIT FFT, N = 1024
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0x38CF39B2    # x[0]
    .word 0x3A313202    # x[1]
    .word 0x38F537BB    # x[2]
    .word 0x3B9EB867    # x[3]
    .word 0x2F6D3449    # x[4]
    .word 0xB6EFAEDE    # x[5]
    .word 0xBB7A3A6F    # x[6]
    .word 0xB8FCB014    # x[7]
    .word 0x3A6B3ACD    # x[8]
    .word 0x3AAEBA10    # x[9]
    .word 0x3A443446    # x[10]
    .word 0x34B83B16    # x[11]
    .word 0xB85BB694    # x[12]
    .word 0x3089BB93    # x[13]
    .word 0x3B91BA89    # x[14]
    .word 0x3910BB37    # x[15]
    .word 0xB2D1BA0F    # x[16]
    .word 0xB775382E    # x[17]
    .word 0xB757BB7C    # x[18]
    .word 0x3A1939EE    # x[19]
    .word 0xB8C6B90E    # x[20]
    .word 0xA0802839    # x[21]
    .word 0x3A6732E5    # x[22]
    .word 0xA8F6388C    # x[23]
    .word 0xBAE0BA2A    # x[24]
    .word 0xBBE2B5CD    # x[25]
    .word 0x34012942    # x[26]
    .word 0x336BB7FB    # x[27]
    .word 0xB882B33A    # x[28]
    .word 0xB6CF39FA    # x[29]
    .word 0x3814BA75    # x[30]
    .word 0xBB2E35ED    # x[31]
    .word 0x32FEB923    # x[32]
    .word 0xB438B801    # x[33]
    .word 0xBA0ABB0F    # x[34]
    .word 0xB257AD3A    # x[35]
    .word 0xB897AC79    # x[36]
    .word 0xB6DF33FC    # x[37]
    .word 0x39503451    # x[38]
    .word 0xBBB0396F    # x[39]
    .word 0xB74D2D4D    # x[40]
    .word 0xB78FAEA2    # x[41]
    .word 0x287CB548    # x[42]
    .word 0xB9FE35F9    # x[43]
    .word 0x3763BBA3    # x[44]
    .word 0xB615B84E    # x[45]
    .word 0x3708365A    # x[46]
    .word 0xA487AF92    # x[47]
    .word 0xB2E2BB24    # x[48]
    .word 0x376A3599    # x[49]
    .word 0x361CB920    # x[50]
    .word 0xBAA8B9F0    # x[51]
    .word 0x3A45A697    # x[52]
    .word 0xBBAF2EF2    # x[53]
    .word 0x303A32E6    # x[54]
    .word 0x39E0185C    # x[55]
    .word 0x9832B8CF    # x[56]
    .word 0x3AB1B399    # x[57]
    .word 0xB823BA00    # x[58]
    .word 0xB95BB515    # x[59]
    .word 0x2A773BC5    # x[60]
    .word 0xB821BBC7    # x[61]
    .word 0xB88FBA25    # x[62]
    .word 0x370BB8F1    # x[63]
    .word 0xB8BCBB5A    # x[64]
    .word 0x3B0EBB0E    # x[65]
    .word 0xB9F3B470    # x[66]
    .word 0x389DBB17    # x[67]
    .word 0x3847394D    # x[68]
    .word 0xB5E93A9B    # x[69]
    .word 0xB655B8CD    # x[70]
    .word 0xB916BA24    # x[71]
    .word 0xBB52AFD0    # x[72]
    .word 0x3B1CAE18    # x[73]
    .word 0xB54EB64E    # x[74]
    .word 0x3A9AB785    # x[75]
    .word 0x38802B39    # x[76]
    .word 0x3B99B947    # x[77]
    .word 0x37D53927    # x[78]
    .word 0x3AC834D4    # x[79]
    .word 0x37B0B8DC    # x[80]
    .word 0xBA0A26B5    # x[81]
    .word 0xB4FDBB91    # x[82]
    .word 0x331A3648    # x[83]
    .word 0xBB62B8BA    # x[84]
    .word 0xB2E238C4    # x[85]
    .word 0xB2853A4B    # x[86]
    .word 0x3658332F    # x[87]
    .word 0xB0DDBBB4    # x[88]
    .word 0x33B2B957    # x[89]
    .word 0xB8E9BBAD    # x[90]
    .word 0x397133A3    # x[91]
    .word 0xB827ABAE    # x[92]
    .word 0xB6F6AE30    # x[93]
    .word 0x350736CF    # x[94]
    .word 0xB69B31C4    # x[95]
    .word 0x3300B323    # x[96]
    .word 0x3A2B3955    # x[97]
    .word 0x3513A914    # x[98]
    .word 0xB75A395F    # x[99]
    .word 0x384636D8    # x[100]
    .word 0xB101BA0D    # x[101]
    .word 0x392BBB58    # x[102]
    .word 0x2C06B55D    # x[103]
    .word 0x389FB0BE    # x[104]
    .word 0x3988B12D    # x[105]
    .word 0xB85BBA9C    # x[106]
    .word 0xBB4BB553    # x[107]
    .word 0x33AFB8FF    # x[108]
    .word 0xA6B6BA55    # x[109]
    .word 0x398D395A    # x[110]
    .word 0xA63A3BD3    # x[111]
    .word 0xB85BB95B    # x[112]
    .word 0xBB0938D8    # x[113]
    .word 0xB556B925    # x[114]
    .word 0x29F09DC2    # x[115]
    .word 0x39DFB71B    # x[116]
    .word 0xBBB13050    # x[117]
    .word 0xAFAFBBD6    # x[118]
    .word 0x3918B66D    # x[119]
    .word 0xB44535EC    # x[120]
    .word 0xB271BAD9    # x[121]
    .word 0xB6D2B916    # x[122]
    .word 0x372EB477    # x[123]
    .word 0x2CBEB409    # x[124]
    .word 0xB077B44D    # x[125]
    .word 0x36CFB94D    # x[126]
    .word 0x399533E3    # x[127]
    .word 0xB9F3B287    # x[128]
    .word 0x39FBB8C4    # x[129]
    .word 0x3B03AFFE    # x[130]
    .word 0xB198B83B    # x[131]
    .word 0x3673B50C    # x[132]
    .word 0x365A314D    # x[133]
    .word 0xB910354D    # x[134]
    .word 0x3BB33BE5    # x[135]
    .word 0x35FEB276    # x[136]
    .word 0x2885B4C6    # x[137]
    .word 0x38CDB96B    # x[138]
    .word 0xBB09314A    # x[139]
    .word 0x2AE1355C    # x[140]
    .word 0x347D3211    # x[141]
    .word 0xB9F4316D    # x[142]
    .word 0xB9B738E5    # x[143]
    .word 0xB8103172    # x[144]
    .word 0xB68538B6    # x[145]
    .word 0x3BF93867    # x[146]
    .word 0xAFAB2EAB    # x[147]
    .word 0x349939A1    # x[148]
    .word 0x39E9BB91    # x[149]
    .word 0x3996BB68    # x[150]
    .word 0x33B2ABF9    # x[151]
    .word 0xB998AEB1    # x[152]
    .word 0x3444B677    # x[153]
    .word 0xA932BA8D    # x[154]
    .word 0xAAF1BA27    # x[155]
    .word 0xB0AFB27F    # x[156]
    .word 0xB949375B    # x[157]
    .word 0x381CB45D    # x[158]
    .word 0x3A6DB8B6    # x[159]
    .word 0xB90B31B5    # x[160]
    .word 0xB9C2B534    # x[161]
    .word 0x38F93AE4    # x[162]
    .word 0xB6B1BA0D    # x[163]
    .word 0x2F73B4C8    # x[164]
    .word 0x377236E9    # x[165]
    .word 0xB332B893    # x[166]
    .word 0xB90CB547    # x[167]
    .word 0xBB49352C    # x[168]
    .word 0xBAE8B888    # x[169]
    .word 0x39E5381F    # x[170]
    .word 0x36383622    # x[171]
    .word 0x37B3B77C    # x[172]
    .word 0xB99236CF    # x[173]
    .word 0xB487327A    # x[174]
    .word 0xB9E133E0    # x[175]
    .word 0x38AD39A6    # x[176]
    .word 0x3BDC33D6    # x[177]
    .word 0x39AA2C6D    # x[178]
    .word 0x332BB762    # x[179]
    .word 0x3B4EAA0A    # x[180]
    .word 0xB89CAD3A    # x[181]
    .word 0xB5CCB085    # x[182]
    .word 0x323FB651    # x[183]
    .word 0x39823557    # x[184]
    .word 0x3B7A383D    # x[185]
    .word 0xB38C164D    # x[186]
    .word 0x39E03559    # x[187]
    .word 0xB858BB90    # x[188]
    .word 0x39F42CFC    # x[189]
    .word 0xB947B4A2    # x[190]
    .word 0x38E3AF98    # x[191]
    .word 0xAE24BB26    # x[192]
    .word 0xB0913AB5    # x[193]
    .word 0xB178B977    # x[194]
    .word 0x32003A8B    # x[195]
    .word 0xB4383912    # x[196]
    .word 0x34293BB5    # x[197]
    .word 0xA83FB062    # x[198]
    .word 0x2DFFBA08    # x[199]
    .word 0xB652ADF7    # x[200]
    .word 0x396CB720    # x[201]
    .word 0x3998BBF4    # x[202]
    .word 0xBAC73ACA    # x[203]
    .word 0x3046B9F1    # x[204]
    .word 0xB67BBB1A    # x[205]
    .word 0xB9AD3BC5    # x[206]
    .word 0xBBE53712    # x[207]
    .word 0x2D8B3BDC    # x[208]
    .word 0x2A4C295B    # x[209]
    .word 0x3AD5B06B    # x[210]
    .word 0xBA51B991    # x[211]
    .word 0xB49D37BF    # x[212]
    .word 0x3B4FBBB2    # x[213]
    .word 0xB9E23245    # x[214]
    .word 0x3732B784    # x[215]
    .word 0xB899BB20    # x[216]
    .word 0x384029B6    # x[217]
    .word 0xB6AF38BD    # x[218]
    .word 0xB4442D40    # x[219]
    .word 0x3BF438B6    # x[220]
    .word 0xB1F5AEEA    # x[221]
    .word 0xB8242DD6    # x[222]
    .word 0x329D37BE    # x[223]
    .word 0xB5BDBAC6    # x[224]
    .word 0x34D136B7    # x[225]
    .word 0xA9FD2907    # x[226]
    .word 0xB2D0BB1E    # x[227]
    .word 0x34CA2F49    # x[228]
    .word 0x3832B7BC    # x[229]
    .word 0xB848BAFA    # x[230]
    .word 0x39A93546    # x[231]
    .word 0x38BC3246    # x[232]
    .word 0xA9303925    # x[233]
    .word 0x3A5B3BE7    # x[234]
    .word 0x34C9380E    # x[235]
    .word 0xB3863AC2    # x[236]
    .word 0x3887B80A    # x[237]
    .word 0xBBA53818    # x[238]
    .word 0xBA4E3910    # x[239]
    .word 0x34913B17    # x[240]
    .word 0x38413B3F    # x[241]
    .word 0xBB28B13E    # x[242]
    .word 0x385EB7FB    # x[243]
    .word 0xBAD4200F    # x[244]
    .word 0x397E3BCD    # x[245]
    .word 0x37E335D8    # x[246]
    .word 0xB018B022    # x[247]
    .word 0xB5FB3772    # x[248]
    .word 0xAE45A80E    # x[249]
    .word 0xB8253BC7    # x[250]
    .word 0x2EE03885    # x[251]
    .word 0x350DB651    # x[252]
    .word 0x35CC350D    # x[253]
    .word 0x3554B6C0    # x[254]
    .word 0xB81C3848    # x[255]
    .word 0xB48A2F73    # x[256]
    .word 0x366BB7F3    # x[257]
    .word 0x3250ADDF    # x[258]
    .word 0x397E393B    # x[259]
    .word 0x34082DB4    # x[260]
    .word 0x381C3759    # x[261]
    .word 0xB9B93AFC    # x[262]
    .word 0xB62D2FA2    # x[263]
    .word 0x3B623BFF    # x[264]
    .word 0x2A772E2D    # x[265]
    .word 0x38343227    # x[266]
    .word 0xB917AF43    # x[267]
    .word 0xBBC23B23    # x[268]
    .word 0x37F3B8A9    # x[269]
    .word 0x3A2834B6    # x[270]
    .word 0xBB21BB83    # x[271]
    .word 0x3A87B1D0    # x[272]
    .word 0x32123378    # x[273]
    .word 0xA36B3B36    # x[274]
    .word 0xAF853881    # x[275]
    .word 0xA56B3B34    # x[276]
    .word 0xB9043243    # x[277]
    .word 0x2F2439D9    # x[278]
    .word 0x34FEB8A0    # x[279]
    .word 0x3B6339E3    # x[280]
    .word 0x3B572F46    # x[281]
    .word 0x2051B56E    # x[282]
    .word 0xB4A0B2D7    # x[283]
    .word 0x3134388D    # x[284]
    .word 0x382F3A9A    # x[285]
    .word 0x3A8E33BE    # x[286]
    .word 0x37ED348D    # x[287]
    .word 0xB5752D61    # x[288]
    .word 0x3AD5AFD1    # x[289]
    .word 0xB3AEBA11    # x[290]
    .word 0xAC85B3C2    # x[291]
    .word 0xB9AE38B1    # x[292]
    .word 0x2BAFACED    # x[293]
    .word 0xAEB3A139    # x[294]
    .word 0x3B413533    # x[295]
    .word 0x35E339A5    # x[296]
    .word 0xB8B7B92D    # x[297]
    .word 0xB5AF3A56    # x[298]
    .word 0xB825368D    # x[299]
    .word 0x39E136A3    # x[300]
    .word 0x372BBADF    # x[301]
    .word 0xB7ACBA53    # x[302]
    .word 0xB516A98A    # x[303]
    .word 0xBA0DBB93    # x[304]
    .word 0xBA57BB98    # x[305]
    .word 0x373CB87B    # x[306]
    .word 0xB6542D81    # x[307]
    .word 0x3ADE3325    # x[308]
    .word 0xB3A7B956    # x[309]
    .word 0xB43D387C    # x[310]
    .word 0x3BC32F11    # x[311]
    .word 0x378BB974    # x[312]
    .word 0xBA62B662    # x[313]
    .word 0xAAC03B35    # x[314]
    .word 0x39813AA7    # x[315]
    .word 0x3464BAFF    # x[316]
    .word 0xB89F3A26    # x[317]
    .word 0xB813368B    # x[318]
    .word 0x360DB9D1    # x[319]
    .word 0xBACCB03A    # x[320]
    .word 0x2E6CB7CF    # x[321]
    .word 0x3B38B525    # x[322]
    .word 0x35862AF1    # x[323]
    .word 0xBB383A63    # x[324]
    .word 0xBBD33398    # x[325]
    .word 0xB4972E40    # x[326]
    .word 0xBA12B63B    # x[327]
    .word 0xBACDBA20    # x[328]
    .word 0xB301B8A8    # x[329]
    .word 0xB91AB557    # x[330]
    .word 0xB966B98E    # x[331]
    .word 0xB5B33490    # x[332]
    .word 0x3BF0BAA4    # x[333]
    .word 0x3337B61B    # x[334]
    .word 0xB5DDB1B9    # x[335]
    .word 0x378B3844    # x[336]
    .word 0x38D7BA4E    # x[337]
    .word 0xB65F3435    # x[338]
    .word 0x3AC6BBCD    # x[339]
    .word 0xBBB73838    # x[340]
    .word 0x3A363641    # x[341]
    .word 0xAED7BAE1    # x[342]
    .word 0x394E2F47    # x[343]
    .word 0xB822BAD5    # x[344]
    .word 0x39CC33C2    # x[345]
    .word 0xB418B937    # x[346]
    .word 0xAE013B7E    # x[347]
    .word 0xB58E3ADA    # x[348]
    .word 0xB72AB662    # x[349]
    .word 0x2CEF34A1    # x[350]
    .word 0x2E7C3375    # x[351]
    .word 0xBB163568    # x[352]
    .word 0xB4D2B675    # x[353]
    .word 0x39D4BA90    # x[354]
    .word 0x293A3AB9    # x[355]
    .word 0xB928B605    # x[356]
    .word 0x2E56B752    # x[357]
    .word 0x38EEB67E    # x[358]
    .word 0xBAFFB956    # x[359]
    .word 0xBB173831    # x[360]
    .word 0x3B3EB10D    # x[361]
    .word 0xB9D624F3    # x[362]
    .word 0xB8A3353A    # x[363]
    .word 0x39B23625    # x[364]
    .word 0x36BE36B8    # x[365]
    .word 0x3B833ADD    # x[366]
    .word 0x3BD63BEB    # x[367]
    .word 0x3BF9A7E7    # x[368]
    .word 0x342DBB96    # x[369]
    .word 0xB4D1BBCB    # x[370]
    .word 0xAE202C28    # x[371]
    .word 0x3AE03969    # x[372]
    .word 0x3BD83604    # x[373]
    .word 0x3A203AC3    # x[374]
    .word 0xBA08B835    # x[375]
    .word 0x3126387E    # x[376]
    .word 0x3B06B0D4    # x[377]
    .word 0x2D3ABA30    # x[378]
    .word 0x391BB53C    # x[379]
    .word 0x34702C06    # x[380]
    .word 0xB90E3150    # x[381]
    .word 0x354A3B0A    # x[382]
    .word 0xBB8CBBF7    # x[383]
    .word 0x3B1EBB4D    # x[384]
    .word 0xB7563705    # x[385]
    .word 0x2FA5B473    # x[386]
    .word 0xB3C93557    # x[387]
    .word 0xBAD2396D    # x[388]
    .word 0xB8F3AAC6    # x[389]
    .word 0xB44839A4    # x[390]
    .word 0xB93A387C    # x[391]
    .word 0x3A71B408    # x[392]
    .word 0xB7DB30CC    # x[393]
    .word 0xBB3F3518    # x[394]
    .word 0xBA9F39D1    # x[395]
    .word 0xBA7AB29A    # x[396]
    .word 0x39D736F8    # x[397]
    .word 0xB47533CC    # x[398]
    .word 0x3BC8B474    # x[399]
    .word 0x2C81B643    # x[400]
    .word 0xB975B926    # x[401]
    .word 0xA4703A3B    # x[402]
    .word 0x22A32FEC    # x[403]
    .word 0xB8883580    # x[404]
    .word 0x38FDB27A    # x[405]
    .word 0xB4493BF9    # x[406]
    .word 0xB70D34D0    # x[407]
    .word 0x390BA0D4    # x[408]
    .word 0xB592BB2B    # x[409]
    .word 0x3438B7AE    # x[410]
    .word 0x384AB4DE    # x[411]
    .word 0x37A63AA9    # x[412]
    .word 0xBA5FB9A2    # x[413]
    .word 0xB083B3BE    # x[414]
    .word 0x3BD03021    # x[415]
    .word 0x2FC237EF    # x[416]
    .word 0xB8C43711    # x[417]
    .word 0x391DB9B9    # x[418]
    .word 0xAA00306A    # x[419]
    .word 0x31F43A76    # x[420]
    .word 0xBAB3B767    # x[421]
    .word 0x355F386E    # x[422]
    .word 0x399BB0FD    # x[423]
    .word 0xAF423647    # x[424]
    .word 0x36003A97    # x[425]
    .word 0x3955B93E    # x[426]
    .word 0x2E14B25F    # x[427]
    .word 0xBAFCB158    # x[428]
    .word 0x36AEB5B0    # x[429]
    .word 0xB93EB7B9    # x[430]
    .word 0x2D18B9B4    # x[431]
    .word 0x2C493BE2    # x[432]
    .word 0x3633B9A2    # x[433]
    .word 0x39F4BA31    # x[434]
    .word 0x3B41B603    # x[435]
    .word 0x2F43B72B    # x[436]
    .word 0xBB8832D9    # x[437]
    .word 0xB804B821    # x[438]
    .word 0x3A8AB861    # x[439]
    .word 0x2E4FB4F0    # x[440]
    .word 0xB4673BD4    # x[441]
    .word 0x33B53576    # x[442]
    .word 0x334E3AAA    # x[443]
    .word 0x3505284E    # x[444]
    .word 0xB6B624BC    # x[445]
    .word 0x362E24F0    # x[446]
    .word 0xBB42B8F7    # x[447]
    .word 0x359FA871    # x[448]
    .word 0x3B4538F3    # x[449]
    .word 0xA94E3A52    # x[450]
    .word 0x37693AF6    # x[451]
    .word 0x2F6F3486    # x[452]
    .word 0x39C33B28    # x[453]
    .word 0x3B013A3A    # x[454]
    .word 0x3AB5B4D2    # x[455]
    .word 0xBAE93813    # x[456]
    .word 0xB8B5BBED    # x[457]
    .word 0xB48E39DC    # x[458]
    .word 0x36A83A10    # x[459]
    .word 0xB079B396    # x[460]
    .word 0xB52CAFC0    # x[461]
    .word 0x364BACF3    # x[462]
    .word 0x353DAAAB    # x[463]
    .word 0xBB77B47B    # x[464]
    .word 0x37A8B599    # x[465]
    .word 0x34F43364    # x[466]
    .word 0xB5ADAFAC    # x[467]
    .word 0x389B948A    # x[468]
    .word 0x3AFEB6A5    # x[469]
    .word 0xB04ABA8F    # x[470]
    .word 0xBB622E2F    # x[471]
    .word 0xB8F53678    # x[472]
    .word 0xB973398F    # x[473]
    .word 0xB63433DA    # x[474]
    .word 0xBA6CB32E    # x[475]
    .word 0xB8993B0D    # x[476]
    .word 0xB993B738    # x[477]
    .word 0x362239D6    # x[478]
    .word 0xB93ABA17    # x[479]
    .word 0xB0093B2A    # x[480]
    .word 0x343FBA9A    # x[481]
    .word 0xB925B97B    # x[482]
    .word 0xB85B26F9    # x[483]
    .word 0xB80E39A2    # x[484]
    .word 0xB5B0B084    # x[485]
    .word 0xBBFBAD32    # x[486]
    .word 0x323E395F    # x[487]
    .word 0x391FB929    # x[488]
    .word 0xBBAAB7FF    # x[489]
    .word 0x357C2F27    # x[490]
    .word 0xB3E4294D    # x[491]
    .word 0xB3DCB40A    # x[492]
    .word 0x338F2632    # x[493]
    .word 0x3348388B    # x[494]
    .word 0x382B3A90    # x[495]
    .word 0x37B9BADA    # x[496]
    .word 0xBB473B54    # x[497]
    .word 0xADCAB7D8    # x[498]
    .word 0xAF36B57D    # x[499]
    .word 0xB44EB828    # x[500]
    .word 0xB90834A3    # x[501]
    .word 0xBA90B85C    # x[502]
    .word 0x2E58A9C8    # x[503]
    .word 0x35AFB40A    # x[504]
    .word 0xBB7739BF    # x[505]
    .word 0xB1D9BAFB    # x[506]
    .word 0xB910A40B    # x[507]
    .word 0x390FB8EA    # x[508]
    .word 0x3822A21D    # x[509]
    .word 0xB9DE36FE    # x[510]
    .word 0xBB96BA98    # x[511]
    .word 0xB707BB0B    # x[512]
    .word 0x3BBABB1D    # x[513]
    .word 0x2EB039D9    # x[514]
    .word 0x301DBA57    # x[515]
    .word 0x24D93B96    # x[516]
    .word 0x380AB3AE    # x[517]
    .word 0x39B8B8FA    # x[518]
    .word 0x3495B822    # x[519]
    .word 0xB4713814    # x[520]
    .word 0x3935B554    # x[521]
    .word 0x39A420F0    # x[522]
    .word 0x35C7B982    # x[523]
    .word 0x3980A4A5    # x[524]
    .word 0xBA98B837    # x[525]
    .word 0x2DE139B2    # x[526]
    .word 0xB088BB2D    # x[527]
    .word 0x3A6B3A51    # x[528]
    .word 0xB00AB44D    # x[529]
    .word 0xB9D8B7E6    # x[530]
    .word 0xB079AF27    # x[531]
    .word 0x3B74B5A5    # x[532]
    .word 0x283A38B3    # x[533]
    .word 0x9C8DB7E4    # x[534]
    .word 0xBA573BB5    # x[535]
    .word 0x2F9AB50E    # x[536]
    .word 0x3A242A93    # x[537]
    .word 0x9AD7B6AE    # x[538]
    .word 0xB85A3816    # x[539]
    .word 0xB90DBA81    # x[540]
    .word 0xB2A1386A    # x[541]
    .word 0xB9E93B29    # x[542]
    .word 0x3890280B    # x[543]
    .word 0xB16B3AE2    # x[544]
    .word 0x3B399ECB    # x[545]
    .word 0xB4FBBA93    # x[546]
    .word 0xB70CB89C    # x[547]
    .word 0x3B423A5B    # x[548]
    .word 0x38C8A891    # x[549]
    .word 0x387C3AF0    # x[550]
    .word 0x35FF33B5    # x[551]
    .word 0xB60B3465    # x[552]
    .word 0xA9F734FD    # x[553]
    .word 0xAC9DB90A    # x[554]
    .word 0x284C3B1A    # x[555]
    .word 0xB9F734F9    # x[556]
    .word 0x3935BB09    # x[557]
    .word 0xAF7C35D8    # x[558]
    .word 0xB1723BED    # x[559]
    .word 0x3789394A    # x[560]
    .word 0xBA443881    # x[561]
    .word 0xB9FC3828    # x[562]
    .word 0x32A6B8D8    # x[563]
    .word 0x3B9BB88C    # x[564]
    .word 0x3A9E387F    # x[565]
    .word 0x37572A10    # x[566]
    .word 0xB99F3A4F    # x[567]
    .word 0xB81AB661    # x[568]
    .word 0x37303448    # x[569]
    .word 0xB98837C5    # x[570]
    .word 0xB9A2B8D9    # x[571]
    .word 0x3B2FB1B3    # x[572]
    .word 0xB647352B    # x[573]
    .word 0x371C3A56    # x[574]
    .word 0x3B9B38F4    # x[575]
    .word 0x37A63B75    # x[576]
    .word 0xAB1FB126    # x[577]
    .word 0xAE6ABA69    # x[578]
    .word 0x3A1DB7BB    # x[579]
    .word 0x2CF23B29    # x[580]
    .word 0xB7A4B93D    # x[581]
    .word 0x3A87B3E0    # x[582]
    .word 0xB54B397F    # x[583]
    .word 0x2799346F    # x[584]
    .word 0x38A1BA74    # x[585]
    .word 0xBA56BA30    # x[586]
    .word 0x3ACBB6A3    # x[587]
    .word 0xA3BC3A57    # x[588]
    .word 0xB9703933    # x[589]
    .word 0xB28AB4ED    # x[590]
    .word 0x3ADAB85A    # x[591]
    .word 0x3404B681    # x[592]
    .word 0x3046B8F4    # x[593]
    .word 0xBA78AE4C    # x[594]
    .word 0x2EB52BBD    # x[595]
    .word 0x398FB600    # x[596]
    .word 0x32C2B951    # x[597]
    .word 0x3909BACB    # x[598]
    .word 0xAF38B076    # x[599]
    .word 0x273B3464    # x[600]
    .word 0x3BE53940    # x[601]
    .word 0x34E03955    # x[602]
    .word 0xB20B3B95    # x[603]
    .word 0x36C3B400    # x[604]
    .word 0xB9352E90    # x[605]
    .word 0xBA2C36D2    # x[606]
    .word 0x377FBB83    # x[607]
    .word 0xB94AB0D5    # x[608]
    .word 0x2DD43505    # x[609]
    .word 0xB988B8A5    # x[610]
    .word 0x39A237AC    # x[611]
    .word 0xB70DB439    # x[612]
    .word 0x3847B429    # x[613]
    .word 0xB520BA01    # x[614]
    .word 0xB3E4BB6F    # x[615]
    .word 0x2123A6EE    # x[616]
    .word 0x331E2D39    # x[617]
    .word 0x3A0DAC53    # x[618]
    .word 0xB4733B5F    # x[619]
    .word 0x3B823956    # x[620]
    .word 0x3461B4F3    # x[621]
    .word 0xA9EA39FF    # x[622]
    .word 0xB54F36AA    # x[623]
    .word 0x266D322C    # x[624]
    .word 0xACD33B6F    # x[625]
    .word 0x35DEB420    # x[626]
    .word 0x3648B6CE    # x[627]
    .word 0x34C1BBDC    # x[628]
    .word 0xB918288D    # x[629]
    .word 0xBA9E30DF    # x[630]
    .word 0x383BAC04    # x[631]
    .word 0xBB00367D    # x[632]
    .word 0xB8A034B5    # x[633]
    .word 0x33023200    # x[634]
    .word 0x2C9E2C08    # x[635]
    .word 0x38B1BA6A    # x[636]
    .word 0xB4273B01    # x[637]
    .word 0x3099357E    # x[638]
    .word 0xB3F1363C    # x[639]
    .word 0xBB2C3925    # x[640]
    .word 0xB0FEA24F    # x[641]
    .word 0xB9B33B8F    # x[642]
    .word 0x3244360C    # x[643]
    .word 0x3A123B36    # x[644]
    .word 0x387E3460    # x[645]
    .word 0xB07CB42B    # x[646]
    .word 0x2DFA34F2    # x[647]
    .word 0xA68231B2    # x[648]
    .word 0xB98F3378    # x[649]
    .word 0xB66039A4    # x[650]
    .word 0x39933A6E    # x[651]
    .word 0x38893641    # x[652]
    .word 0xB13DB7B1    # x[653]
    .word 0x345BB436    # x[654]
    .word 0xB7A33584    # x[655]
    .word 0x31DCB053    # x[656]
    .word 0x3B49BA4F    # x[657]
    .word 0x343D3A24    # x[658]
    .word 0xB871B7BB    # x[659]
    .word 0xBB2B3BEB    # x[660]
    .word 0x36AAA842    # x[661]
    .word 0xAA353A72    # x[662]
    .word 0x34652DFC    # x[663]
    .word 0xB84B38D5    # x[664]
    .word 0x39ED3BD5    # x[665]
    .word 0xB8E2B97D    # x[666]
    .word 0xB894B65A    # x[667]
    .word 0x3B6A3B19    # x[668]
    .word 0x342DBA8F    # x[669]
    .word 0xB931BBCB    # x[670]
    .word 0x38B13B63    # x[671]
    .word 0x32A9A94D    # x[672]
    .word 0x30233A6B    # x[673]
    .word 0xB8E63740    # x[674]
    .word 0x3AF33B84    # x[675]
    .word 0xB6DBB33A    # x[676]
    .word 0xBAEB3698    # x[677]
    .word 0x3852B851    # x[678]
    .word 0x39EBB080    # x[679]
    .word 0x3B7FB602    # x[680]
    .word 0xB87FB6DA    # x[681]
    .word 0xB0F1BA45    # x[682]
    .word 0x370233EC    # x[683]
    .word 0xBAB22904    # x[684]
    .word 0xB88EB943    # x[685]
    .word 0xB6BF3957    # x[686]
    .word 0x3811B43A    # x[687]
    .word 0xBBF7B9FA    # x[688]
    .word 0xB2E0B8ED    # x[689]
    .word 0xB4DFB7CB    # x[690]
    .word 0x3941BA83    # x[691]
    .word 0xAB413A21    # x[692]
    .word 0x34E7B766    # x[693]
    .word 0xB2083824    # x[694]
    .word 0x339936A8    # x[695]
    .word 0x34833B9C    # x[696]
    .word 0xB998B4ED    # x[697]
    .word 0xAFC6B7EF    # x[698]
    .word 0x3401BA82    # x[699]
    .word 0xBB4FB608    # x[700]
    .word 0x3BA93735    # x[701]
    .word 0x35CA38EB    # x[702]
    .word 0x3A3F38DF    # x[703]
    .word 0xBA75BAB3    # x[704]
    .word 0x3A07BB49    # x[705]
    .word 0x39DABA8D    # x[706]
    .word 0xA47DB831    # x[707]
    .word 0xAE0DAECB    # x[708]
    .word 0xB99B39F3    # x[709]
    .word 0xB80EBA06    # x[710]
    .word 0xBBD5BA49    # x[711]
    .word 0xBB143A58    # x[712]
    .word 0x37A53267    # x[713]
    .word 0xB57AADEA    # x[714]
    .word 0x2AEE3B3B    # x[715]
    .word 0xB63E38DD    # x[716]
    .word 0xBB9CBAE8    # x[717]
    .word 0xBAD7B935    # x[718]
    .word 0xA78F28EA    # x[719]
    .word 0x395A2BC4    # x[720]
    .word 0xADA7BB75    # x[721]
    .word 0xBB76BBF4    # x[722]
    .word 0x348E348F    # x[723]
    .word 0xB4B3A692    # x[724]
    .word 0xB511B1F7    # x[725]
    .word 0x3811391F    # x[726]
    .word 0xB3733637    # x[727]
    .word 0xB484AFDD    # x[728]
    .word 0x309CB73E    # x[729]
    .word 0xBA9FAC50    # x[730]
    .word 0xB316B840    # x[731]
    .word 0x3B1FBB12    # x[732]
    .word 0xB89E3A1B    # x[733]
    .word 0x354EB951    # x[734]
    .word 0x378CBB37    # x[735]
    .word 0xB7A4A621    # x[736]
    .word 0x236B3AFB    # x[737]
    .word 0x3422B576    # x[738]
    .word 0xB7A3B399    # x[739]
    .word 0xAE503A09    # x[740]
    .word 0x967EB99A    # x[741]
    .word 0x2B18BA9F    # x[742]
    .word 0x35BABBBB    # x[743]
    .word 0x3278353E    # x[744]
    .word 0x36D4B54A    # x[745]
    .word 0xA4143181    # x[746]
    .word 0x39343766    # x[747]
    .word 0xBBF83B94    # x[748]
    .word 0xB41F37A6    # x[749]
    .word 0x346835AD    # x[750]
    .word 0xBA33387B    # x[751]
    .word 0x31E03A5E    # x[752]
    .word 0xB857BA25    # x[753]
    .word 0xB3A8B7EE    # x[754]
    .word 0xBA2A389B    # x[755]
    .word 0xBB92AF1C    # x[756]
    .word 0xBAA733DE    # x[757]
    .word 0x3BEF3668    # x[758]
    .word 0x2CF9BA7A    # x[759]
    .word 0xB390B93C    # x[760]
    .word 0x316EB309    # x[761]
    .word 0x3BEE392C    # x[762]
    .word 0x2999B9A0    # x[763]
    .word 0xAD763920    # x[764]
    .word 0x330A3AB3    # x[765]
    .word 0xB1773223    # x[766]
    .word 0xB9F737F2    # x[767]
    .word 0x3B882078    # x[768]
    .word 0xB9F83890    # x[769]
    .word 0x39C7BA39    # x[770]
    .word 0xBAA63441    # x[771]
    .word 0x393A31AF    # x[772]
    .word 0xBB002759    # x[773]
    .word 0xB7B1B9A0    # x[774]
    .word 0xB99428F7    # x[775]
    .word 0xB6F13A19    # x[776]
    .word 0x22DD3242    # x[777]
    .word 0x365C359D    # x[778]
    .word 0xB3FC3AA8    # x[779]
    .word 0xB589BA9B    # x[780]
    .word 0x3ABC3505    # x[781]
    .word 0x364C3B0F    # x[782]
    .word 0xBAAC3AF4    # x[783]
    .word 0xA8533BE3    # x[784]
    .word 0xBB73B01F    # x[785]
    .word 0xBBE5B34B    # x[786]
    .word 0xB68AAA6D    # x[787]
    .word 0x3A54BBC7    # x[788]
    .word 0x3B8A3A77    # x[789]
    .word 0x38AF3A27    # x[790]
    .word 0x3A25309E    # x[791]
    .word 0xB5B2350B    # x[792]
    .word 0x39333764    # x[793]
    .word 0xB120359B    # x[794]
    .word 0x3037393D    # x[795]
    .word 0x2EA23706    # x[796]
    .word 0xB5AE381E    # x[797]
    .word 0x33C82645    # x[798]
    .word 0xB684B351    # x[799]
    .word 0xAF25B34B    # x[800]
    .word 0xB554383F    # x[801]
    .word 0x299DA37B    # x[802]
    .word 0xB7F837B5    # x[803]
    .word 0xB511B4C1    # x[804]
    .word 0xBB0EBA45    # x[805]
    .word 0xA77CB85D    # x[806]
    .word 0xB8952BF8    # x[807]
    .word 0xB5582EB0    # x[808]
    .word 0x363838C9    # x[809]
    .word 0x33F73504    # x[810]
    .word 0x389AB4A9    # x[811]
    .word 0x1590B3F4    # x[812]
    .word 0x3A39B9EB    # x[813]
    .word 0x3B6F38D0    # x[814]
    .word 0xB9883900    # x[815]
    .word 0x3BD8B423    # x[816]
    .word 0x32C4BBE2    # x[817]
    .word 0xABCFA7F0    # x[818]
    .word 0x3B913B0A    # x[819]
    .word 0xB649B6C3    # x[820]
    .word 0xB22C3745    # x[821]
    .word 0xB824B3E3    # x[822]
    .word 0xA50DB3C7    # x[823]
    .word 0xBB29342B    # x[824]
    .word 0xB4AAACF0    # x[825]
    .word 0xB82D359B    # x[826]
    .word 0x384EAED7    # x[827]
    .word 0x3407B579    # x[828]
    .word 0x2D4136BE    # x[829]
    .word 0x3B763B46    # x[830]
    .word 0xB9AD3AD0    # x[831]
    .word 0x3846A7D0    # x[832]
    .word 0xAEB92F1B    # x[833]
    .word 0xB9A8B859    # x[834]
    .word 0xBAE8BB8C    # x[835]
    .word 0x3B7CAFE8    # x[836]
    .word 0x3456396D    # x[837]
    .word 0x35453BCC    # x[838]
    .word 0x2352B65A    # x[839]
    .word 0x295330E6    # x[840]
    .word 0xA9673460    # x[841]
    .word 0x326FBB1F    # x[842]
    .word 0x360D321A    # x[843]
    .word 0x3BAE342F    # x[844]
    .word 0xAA13B5D3    # x[845]
    .word 0xB6A4B4AC    # x[846]
    .word 0x3507B4D4    # x[847]
    .word 0xAE2B383A    # x[848]
    .word 0xBB872741    # x[849]
    .word 0x391332AA    # x[850]
    .word 0xB8F139FE    # x[851]
    .word 0xB80638A3    # x[852]
    .word 0xBBC139B6    # x[853]
    .word 0xB2583807    # x[854]
    .word 0x36593B28    # x[855]
    .word 0xBB35B1B4    # x[856]
    .word 0xB8EEB816    # x[857]
    .word 0x2BCAB9E6    # x[858]
    .word 0xBB6BB8C8    # x[859]
    .word 0xBBDBB5BC    # x[860]
    .word 0xAD9F3269    # x[861]
    .word 0x39EEB818    # x[862]
    .word 0xBA41B461    # x[863]
    .word 0x34D2AC05    # x[864]
    .word 0xBA72B4F1    # x[865]
    .word 0xBB71328C    # x[866]
    .word 0x3837B8CE    # x[867]
    .word 0xB871BB22    # x[868]
    .word 0xBAC13922    # x[869]
    .word 0xB8D2B13B    # x[870]
    .word 0xBAFD3406    # x[871]
    .word 0xBBD1BB31    # x[872]
    .word 0x2E45B6FD    # x[873]
    .word 0xB7B6BBCC    # x[874]
    .word 0xBAC0B53E    # x[875]
    .word 0xAAA3B973    # x[876]
    .word 0xB879B849    # x[877]
    .word 0x39ED3522    # x[878]
    .word 0xBB89B524    # x[879]
    .word 0x3A7CAFA8    # x[880]
    .word 0x2964B9FB    # x[881]
    .word 0x3441B913    # x[882]
    .word 0xB7D137E1    # x[883]
    .word 0x38C73202    # x[884]
    .word 0x36DDB990    # x[885]
    .word 0x3A09BA40    # x[886]
    .word 0x3562AF84    # x[887]
    .word 0xA9CCB9DD    # x[888]
    .word 0xBA50BA1F    # x[889]
    .word 0xB87DB647    # x[890]
    .word 0xB42133AF    # x[891]
    .word 0x37D5367B    # x[892]
    .word 0xB95B306C    # x[893]
    .word 0xB86FBADB    # x[894]
    .word 0x3B6BBB7D    # x[895]
    .word 0xB2202F4B    # x[896]
    .word 0x2C1FB64A    # x[897]
    .word 0x3066B404    # x[898]
    .word 0xB85235CD    # x[899]
    .word 0x386EBA6D    # x[900]
    .word 0x39A3B0F3    # x[901]
    .word 0x372EB851    # x[902]
    .word 0x39F1AC2D    # x[903]
    .word 0x383738E5    # x[904]
    .word 0xB99F37C7    # x[905]
    .word 0xB548BB71    # x[906]
    .word 0x3A02AFEA    # x[907]
    .word 0xBB8EBA2E    # x[908]
    .word 0xB6C7BA4A    # x[909]
    .word 0xAFFE3A1D    # x[910]
    .word 0xB0FFB620    # x[911]
    .word 0xB8423007    # x[912]
    .word 0x38AC38DB    # x[913]
    .word 0xBAC13AE0    # x[914]
    .word 0xBA552E0F    # x[915]
    .word 0xBBB2BB60    # x[916]
    .word 0x34AF3A7A    # x[917]
    .word 0x3818B025    # x[918]
    .word 0x324A36F9    # x[919]
    .word 0xB858B2DF    # x[920]
    .word 0x3A723B4F    # x[921]
    .word 0xB9083BB3    # x[922]
    .word 0x39A83850    # x[923]
    .word 0x37FE3235    # x[924]
    .word 0x3791BAAF    # x[925]
    .word 0xBAC5BB0E    # x[926]
    .word 0x3234B143    # x[927]
    .word 0xBAC4B96E    # x[928]
    .word 0xB8512F8D    # x[929]
    .word 0x3095AC67    # x[930]
    .word 0x333C3385    # x[931]
    .word 0xB88634EB    # x[932]
    .word 0x35B9A4A3    # x[933]
    .word 0x3964B82F    # x[934]
    .word 0xB72DB90F    # x[935]
    .word 0x37553807    # x[936]
    .word 0x37FD36E4    # x[937]
    .word 0xB9F33731    # x[938]
    .word 0x35D3BB29    # x[939]
    .word 0xAF83B8E5    # x[940]
    .word 0xB4703778    # x[941]
    .word 0x35513027    # x[942]
    .word 0x38D1B9E4    # x[943]
    .word 0x3A243908    # x[944]
    .word 0x369E3593    # x[945]
    .word 0x38E13B2C    # x[946]
    .word 0xBA76B692    # x[947]
    .word 0xBBD13442    # x[948]
    .word 0x3ADD3825    # x[949]
    .word 0x381433F0    # x[950]
    .word 0x3AD8B5F9    # x[951]
    .word 0xB4D03BB6    # x[952]
    .word 0x37D23641    # x[953]
    .word 0xB5B53404    # x[954]
    .word 0xBB0633E6    # x[955]
    .word 0xAC2C3962    # x[956]
    .word 0x31F6311B    # x[957]
    .word 0xB0EEB4CA    # x[958]
    .word 0xA8C23AE3    # x[959]
    .word 0xB646350C    # x[960]
    .word 0xB90DA5FF    # x[961]
    .word 0xB5FCBAE4    # x[962]
    .word 0x2AC73488    # x[963]
    .word 0x39F1AE45    # x[964]
    .word 0xB912B850    # x[965]
    .word 0x3553A983    # x[966]
    .word 0x340CAB88    # x[967]
    .word 0xA73C366D    # x[968]
    .word 0xB4F7B4AB    # x[969]
    .word 0xADE13004    # x[970]
    .word 0xAF1639C4    # x[971]
    .word 0xB1072DBB    # x[972]
    .word 0x3BAD34A8    # x[973]
    .word 0x3166382D    # x[974]
    .word 0xB927B861    # x[975]
    .word 0x3B05B819    # x[976]
    .word 0xBA71B3F4    # x[977]
    .word 0x368DB234    # x[978]
    .word 0x3BE9BBFA    # x[979]
    .word 0x9F71B82B    # x[980]
    .word 0xB82CBA76    # x[981]
    .word 0xB093369A    # x[982]
    .word 0xBB103AE4    # x[983]
    .word 0x3AEE3263    # x[984]
    .word 0x38093BF5    # x[985]
    .word 0xB6A0BB92    # x[986]
    .word 0xBA6BB976    # x[987]
    .word 0x39F33043    # x[988]
    .word 0xB407309B    # x[989]
    .word 0x347B352B    # x[990]
    .word 0x3A793ADA    # x[991]
    .word 0x3780B4A1    # x[992]
    .word 0xB67A3A2F    # x[993]
    .word 0x36993B30    # x[994]
    .word 0xB976B630    # x[995]
    .word 0xBA60B50C    # x[996]
    .word 0xB6A39F37    # x[997]
    .word 0x3599B391    # x[998]
    .word 0x285FBB84    # x[999]
    .word 0x36F9BB1E    # x[1000]
    .word 0x3B3A2665    # x[1001]
    .word 0xB9FA3396    # x[1002]
    .word 0x39842660    # x[1003]
    .word 0xB86A38B0    # x[1004]
    .word 0xB9693846    # x[1005]
    .word 0x38E5B2D7    # x[1006]
    .word 0x3B8A388A    # x[1007]
    .word 0x3B3F3680    # x[1008]
    .word 0x34F9B8D5    # x[1009]
    .word 0xBB5FB1B5    # x[1010]
    .word 0x3B512ADB    # x[1011]
    .word 0xAEB9B906    # x[1012]
    .word 0x380435E1    # x[1013]
    .word 0x35F2B731    # x[1014]
    .word 0xB8B3B409    # x[1015]
    .word 0x3881B41E    # x[1016]
    .word 0x326CBAEF    # x[1017]
    .word 0xBB933926    # x[1018]
    .word 0xB90230B4    # x[1019]
    .word 0xAACEB837    # x[1020]
    .word 0x28CCB86D    # x[1021]
    .word 0x3A71388E    # x[1022]
    .word 0x399BB571    # x[1023]

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
    # len = 512
    .word 0x00003C00    # W512^0 = 1.000000 +0.000000i
    .word 0xA2483C00    # W512^1 = 0.999925 -0.012272i
    .word 0xA6483BFF    # W512^2 = 0.999699 -0.024541i
    .word 0xA8B63BFF    # W512^3 = 0.999322 -0.036807i
    .word 0xAA483BFE    # W512^4 = 0.998795 -0.049068i
    .word 0xABD93BFC    # W512^5 = 0.998118 -0.061321i
    .word 0xACB53BFA    # W512^6 = 0.997290 -0.073565i
    .word 0xAD7E3BF8    # W512^7 = 0.996313 -0.085797i
    .word 0xAE463BF6    # W512^8 = 0.995185 -0.098017i
    .word 0xAF0E3BF4    # W512^9 = 0.993907 -0.110222i
    .word 0xAFD63BF1    # W512^10 = 0.992480 -0.122411i
    .word 0xB04E3BED    # W512^11 = 0.990903 -0.134581i
    .word 0xB0B23BEA    # W512^12 = 0.989177 -0.146730i
    .word 0xB1153BE6    # W512^13 = 0.987301 -0.158858i
    .word 0xB1793BE2    # W512^14 = 0.985278 -0.170962i
    .word 0xB1DB3BDD    # W512^15 = 0.983105 -0.183040i
    .word 0xB23E3BD9    # W512^16 = 0.980785 -0.195090i
    .word 0xB2A13BD4    # W512^17 = 0.978317 -0.207111i
    .word 0xB3033BCE    # W512^18 = 0.975702 -0.219101i
    .word 0xB3653BC9    # W512^19 = 0.972940 -0.231058i
    .word 0xB3C63BC3    # W512^20 = 0.970031 -0.242980i
    .word 0xB4143BBC    # W512^21 = 0.966976 -0.254866i
    .word 0xB4443BB6    # W512^22 = 0.963776 -0.266713i
    .word 0xB4753BAF    # W512^23 = 0.960431 -0.278520i
    .word 0xB4A53BA8    # W512^24 = 0.956940 -0.290285i
    .word 0xB4D53BA0    # W512^25 = 0.953306 -0.302006i
    .word 0xB5053B99    # W512^26 = 0.949528 -0.313682i
    .word 0xB5343B91    # W512^27 = 0.945607 -0.325310i
    .word 0xB5643B88    # W512^28 = 0.941544 -0.336890i
    .word 0xB5933B80    # W512^29 = 0.937339 -0.348419i
    .word 0xB5C23B77    # W512^30 = 0.932993 -0.359895i
    .word 0xB5F13B6E    # W512^31 = 0.928506 -0.371317i
    .word 0xB61F3B64    # W512^32 = 0.923880 -0.382683i
    .word 0xB64E3B5A    # W512^33 = 0.919114 -0.393992i
    .word 0xB67C3B50    # W512^34 = 0.914210 -0.405241i
    .word 0xB6AA3B46    # W512^35 = 0.909168 -0.416430i
    .word 0xB6D73B3B    # W512^36 = 0.903989 -0.427555i
    .word 0xB7053B30    # W512^37 = 0.898674 -0.438616i
    .word 0xB7323B25    # W512^38 = 0.893224 -0.449611i
    .word 0xB75E3B1A    # W512^39 = 0.887640 -0.460539i
    .word 0xB78B3B0E    # W512^40 = 0.881921 -0.471397i
    .word 0xB7B73B02    # W512^41 = 0.876070 -0.482184i
    .word 0xB7E33AF6    # W512^42 = 0.870087 -0.492898i
    .word 0xB8073AE9    # W512^43 = 0.863973 -0.503538i
    .word 0xB81D3ADD    # W512^44 = 0.857729 -0.514103i
    .word 0xB8323AD0    # W512^45 = 0.851355 -0.524590i
    .word 0xB8483AC2    # W512^46 = 0.844854 -0.534998i
    .word 0xB85D3AB5    # W512^47 = 0.838225 -0.545325i
    .word 0xB8723AA7    # W512^48 = 0.831470 -0.555570i
    .word 0xB8873A99    # W512^49 = 0.824589 -0.565732i
    .word 0xB89B3A8A    # W512^50 = 0.817585 -0.575808i
    .word 0xB8B03A7C    # W512^51 = 0.810457 -0.585798i
    .word 0xB8C43A6D    # W512^52 = 0.803208 -0.595699i
    .word 0xB8D83A5E    # W512^53 = 0.795837 -0.605511i
    .word 0xB8EC3A4F    # W512^54 = 0.788346 -0.615232i
    .word 0xB9003A3F    # W512^55 = 0.780737 -0.624859i
    .word 0xB9133A2F    # W512^56 = 0.773010 -0.634393i
    .word 0xB9273A1F    # W512^57 = 0.765167 -0.643832i
    .word 0xB93A3A0F    # W512^58 = 0.757209 -0.653173i
    .word 0xB94D39FE    # W512^59 = 0.749136 -0.662416i
    .word 0xB95F39ED    # W512^60 = 0.740951 -0.671559i
    .word 0xB97239DC    # W512^61 = 0.732654 -0.680601i
    .word 0xB98439CB    # W512^62 = 0.724247 -0.689541i
    .word 0xB99639BA    # W512^63 = 0.715731 -0.698376i
    .word 0xB9A839A8    # W512^64 = 0.707107 -0.707107i
    .word 0xB9BA3996    # W512^65 = 0.698376 -0.715731i
    .word 0xB9CB3984    # W512^66 = 0.689541 -0.724247i
    .word 0xB9DC3972    # W512^67 = 0.680601 -0.732654i
    .word 0xB9ED395F    # W512^68 = 0.671559 -0.740951i
    .word 0xB9FE394D    # W512^69 = 0.662416 -0.749136i
    .word 0xBA0F393A    # W512^70 = 0.653173 -0.757209i
    .word 0xBA1F3927    # W512^71 = 0.643832 -0.765167i
    .word 0xBA2F3913    # W512^72 = 0.634393 -0.773010i
    .word 0xBA3F3900    # W512^73 = 0.624859 -0.780737i
    .word 0xBA4F38EC    # W512^74 = 0.615232 -0.788346i
    .word 0xBA5E38D8    # W512^75 = 0.605511 -0.795837i
    .word 0xBA6D38C4    # W512^76 = 0.595699 -0.803208i
    .word 0xBA7C38B0    # W512^77 = 0.585798 -0.810457i
    .word 0xBA8A389B    # W512^78 = 0.575808 -0.817585i
    .word 0xBA993887    # W512^79 = 0.565732 -0.824589i
    .word 0xBAA73872    # W512^80 = 0.555570 -0.831470i
    .word 0xBAB5385D    # W512^81 = 0.545325 -0.838225i
    .word 0xBAC23848    # W512^82 = 0.534998 -0.844854i
    .word 0xBAD03832    # W512^83 = 0.524590 -0.851355i
    .word 0xBADD381D    # W512^84 = 0.514103 -0.857729i
    .word 0xBAE93807    # W512^85 = 0.503538 -0.863973i
    .word 0xBAF637E3    # W512^86 = 0.492898 -0.870087i
    .word 0xBB0237B7    # W512^87 = 0.482184 -0.876070i
    .word 0xBB0E378B    # W512^88 = 0.471397 -0.881921i
    .word 0xBB1A375E    # W512^89 = 0.460539 -0.887640i
    .word 0xBB253732    # W512^90 = 0.449611 -0.893224i
    .word 0xBB303705    # W512^91 = 0.438616 -0.898674i
    .word 0xBB3B36D7    # W512^92 = 0.427555 -0.903989i
    .word 0xBB4636AA    # W512^93 = 0.416430 -0.909168i
    .word 0xBB50367C    # W512^94 = 0.405241 -0.914210i
    .word 0xBB5A364E    # W512^95 = 0.393992 -0.919114i
    .word 0xBB64361F    # W512^96 = 0.382683 -0.923880i
    .word 0xBB6E35F1    # W512^97 = 0.371317 -0.928506i
    .word 0xBB7735C2    # W512^98 = 0.359895 -0.932993i
    .word 0xBB803593    # W512^99 = 0.348419 -0.937339i
    .word 0xBB883564    # W512^100 = 0.336890 -0.941544i
    .word 0xBB913534    # W512^101 = 0.325310 -0.945607i
    .word 0xBB993505    # W512^102 = 0.313682 -0.949528i
    .word 0xBBA034D5    # W512^103 = 0.302006 -0.953306i
    .word 0xBBA834A5    # W512^104 = 0.290285 -0.956940i
    .word 0xBBAF3475    # W512^105 = 0.278520 -0.960431i
    .word 0xBBB63444    # W512^106 = 0.266713 -0.963776i
    .word 0xBBBC3414    # W512^107 = 0.254866 -0.966976i
    .word 0xBBC333C6    # W512^108 = 0.242980 -0.970031i
    .word 0xBBC93365    # W512^109 = 0.231058 -0.972940i
    .word 0xBBCE3303    # W512^110 = 0.219101 -0.975702i
    .word 0xBBD432A1    # W512^111 = 0.207111 -0.978317i
    .word 0xBBD9323E    # W512^112 = 0.195090 -0.980785i
    .word 0xBBDD31DB    # W512^113 = 0.183040 -0.983105i
    .word 0xBBE23179    # W512^114 = 0.170962 -0.985278i
    .word 0xBBE63115    # W512^115 = 0.158858 -0.987301i
    .word 0xBBEA30B2    # W512^116 = 0.146730 -0.989177i
    .word 0xBBED304E    # W512^117 = 0.134581 -0.990903i
    .word 0xBBF12FD6    # W512^118 = 0.122411 -0.992480i
    .word 0xBBF42F0E    # W512^119 = 0.110222 -0.993907i
    .word 0xBBF62E46    # W512^120 = 0.098017 -0.995185i
    .word 0xBBF82D7E    # W512^121 = 0.085797 -0.996313i
    .word 0xBBFA2CB5    # W512^122 = 0.073565 -0.997290i
    .word 0xBBFC2BD9    # W512^123 = 0.061321 -0.998118i
    .word 0xBBFE2A48    # W512^124 = 0.049068 -0.998795i
    .word 0xBBFF28B6    # W512^125 = 0.036807 -0.999322i
    .word 0xBBFF2648    # W512^126 = 0.024541 -0.999699i
    .word 0xBC002248    # W512^127 = 0.012272 -0.999925i
    .word 0xBC000000    # W512^128 = 0.000000 -1.000000i
    .word 0xBC00A248    # W512^129 = -0.012272 -0.999925i
    .word 0xBBFFA648    # W512^130 = -0.024541 -0.999699i
    .word 0xBBFFA8B6    # W512^131 = -0.036807 -0.999322i
    .word 0xBBFEAA48    # W512^132 = -0.049068 -0.998795i
    .word 0xBBFCABD9    # W512^133 = -0.061321 -0.998118i
    .word 0xBBFAACB5    # W512^134 = -0.073565 -0.997290i
    .word 0xBBF8AD7E    # W512^135 = -0.085797 -0.996313i
    .word 0xBBF6AE46    # W512^136 = -0.098017 -0.995185i
    .word 0xBBF4AF0E    # W512^137 = -0.110222 -0.993907i
    .word 0xBBF1AFD6    # W512^138 = -0.122411 -0.992480i
    .word 0xBBEDB04E    # W512^139 = -0.134581 -0.990903i
    .word 0xBBEAB0B2    # W512^140 = -0.146730 -0.989177i
    .word 0xBBE6B115    # W512^141 = -0.158858 -0.987301i
    .word 0xBBE2B179    # W512^142 = -0.170962 -0.985278i
    .word 0xBBDDB1DB    # W512^143 = -0.183040 -0.983105i
    .word 0xBBD9B23E    # W512^144 = -0.195090 -0.980785i
    .word 0xBBD4B2A1    # W512^145 = -0.207111 -0.978317i
    .word 0xBBCEB303    # W512^146 = -0.219101 -0.975702i
    .word 0xBBC9B365    # W512^147 = -0.231058 -0.972940i
    .word 0xBBC3B3C6    # W512^148 = -0.242980 -0.970031i
    .word 0xBBBCB414    # W512^149 = -0.254866 -0.966976i
    .word 0xBBB6B444    # W512^150 = -0.266713 -0.963776i
    .word 0xBBAFB475    # W512^151 = -0.278520 -0.960431i
    .word 0xBBA8B4A5    # W512^152 = -0.290285 -0.956940i
    .word 0xBBA0B4D5    # W512^153 = -0.302006 -0.953306i
    .word 0xBB99B505    # W512^154 = -0.313682 -0.949528i
    .word 0xBB91B534    # W512^155 = -0.325310 -0.945607i
    .word 0xBB88B564    # W512^156 = -0.336890 -0.941544i
    .word 0xBB80B593    # W512^157 = -0.348419 -0.937339i
    .word 0xBB77B5C2    # W512^158 = -0.359895 -0.932993i
    .word 0xBB6EB5F1    # W512^159 = -0.371317 -0.928506i
    .word 0xBB64B61F    # W512^160 = -0.382683 -0.923880i
    .word 0xBB5AB64E    # W512^161 = -0.393992 -0.919114i
    .word 0xBB50B67C    # W512^162 = -0.405241 -0.914210i
    .word 0xBB46B6AA    # W512^163 = -0.416430 -0.909168i
    .word 0xBB3BB6D7    # W512^164 = -0.427555 -0.903989i
    .word 0xBB30B705    # W512^165 = -0.438616 -0.898674i
    .word 0xBB25B732    # W512^166 = -0.449611 -0.893224i
    .word 0xBB1AB75E    # W512^167 = -0.460539 -0.887640i
    .word 0xBB0EB78B    # W512^168 = -0.471397 -0.881921i
    .word 0xBB02B7B7    # W512^169 = -0.482184 -0.876070i
    .word 0xBAF6B7E3    # W512^170 = -0.492898 -0.870087i
    .word 0xBAE9B807    # W512^171 = -0.503538 -0.863973i
    .word 0xBADDB81D    # W512^172 = -0.514103 -0.857729i
    .word 0xBAD0B832    # W512^173 = -0.524590 -0.851355i
    .word 0xBAC2B848    # W512^174 = -0.534998 -0.844854i
    .word 0xBAB5B85D    # W512^175 = -0.545325 -0.838225i
    .word 0xBAA7B872    # W512^176 = -0.555570 -0.831470i
    .word 0xBA99B887    # W512^177 = -0.565732 -0.824589i
    .word 0xBA8AB89B    # W512^178 = -0.575808 -0.817585i
    .word 0xBA7CB8B0    # W512^179 = -0.585798 -0.810457i
    .word 0xBA6DB8C4    # W512^180 = -0.595699 -0.803208i
    .word 0xBA5EB8D8    # W512^181 = -0.605511 -0.795837i
    .word 0xBA4FB8EC    # W512^182 = -0.615232 -0.788346i
    .word 0xBA3FB900    # W512^183 = -0.624859 -0.780737i
    .word 0xBA2FB913    # W512^184 = -0.634393 -0.773010i
    .word 0xBA1FB927    # W512^185 = -0.643832 -0.765167i
    .word 0xBA0FB93A    # W512^186 = -0.653173 -0.757209i
    .word 0xB9FEB94D    # W512^187 = -0.662416 -0.749136i
    .word 0xB9EDB95F    # W512^188 = -0.671559 -0.740951i
    .word 0xB9DCB972    # W512^189 = -0.680601 -0.732654i
    .word 0xB9CBB984    # W512^190 = -0.689541 -0.724247i
    .word 0xB9BAB996    # W512^191 = -0.698376 -0.715731i
    .word 0xB9A8B9A8    # W512^192 = -0.707107 -0.707107i
    .word 0xB996B9BA    # W512^193 = -0.715731 -0.698376i
    .word 0xB984B9CB    # W512^194 = -0.724247 -0.689541i
    .word 0xB972B9DC    # W512^195 = -0.732654 -0.680601i
    .word 0xB95FB9ED    # W512^196 = -0.740951 -0.671559i
    .word 0xB94DB9FE    # W512^197 = -0.749136 -0.662416i
    .word 0xB93ABA0F    # W512^198 = -0.757209 -0.653173i
    .word 0xB927BA1F    # W512^199 = -0.765167 -0.643832i
    .word 0xB913BA2F    # W512^200 = -0.773010 -0.634393i
    .word 0xB900BA3F    # W512^201 = -0.780737 -0.624859i
    .word 0xB8ECBA4F    # W512^202 = -0.788346 -0.615232i
    .word 0xB8D8BA5E    # W512^203 = -0.795837 -0.605511i
    .word 0xB8C4BA6D    # W512^204 = -0.803208 -0.595699i
    .word 0xB8B0BA7C    # W512^205 = -0.810457 -0.585798i
    .word 0xB89BBA8A    # W512^206 = -0.817585 -0.575808i
    .word 0xB887BA99    # W512^207 = -0.824589 -0.565732i
    .word 0xB872BAA7    # W512^208 = -0.831470 -0.555570i
    .word 0xB85DBAB5    # W512^209 = -0.838225 -0.545325i
    .word 0xB848BAC2    # W512^210 = -0.844854 -0.534998i
    .word 0xB832BAD0    # W512^211 = -0.851355 -0.524590i
    .word 0xB81DBADD    # W512^212 = -0.857729 -0.514103i
    .word 0xB807BAE9    # W512^213 = -0.863973 -0.503538i
    .word 0xB7E3BAF6    # W512^214 = -0.870087 -0.492898i
    .word 0xB7B7BB02    # W512^215 = -0.876070 -0.482184i
    .word 0xB78BBB0E    # W512^216 = -0.881921 -0.471397i
    .word 0xB75EBB1A    # W512^217 = -0.887640 -0.460539i
    .word 0xB732BB25    # W512^218 = -0.893224 -0.449611i
    .word 0xB705BB30    # W512^219 = -0.898674 -0.438616i
    .word 0xB6D7BB3B    # W512^220 = -0.903989 -0.427555i
    .word 0xB6AABB46    # W512^221 = -0.909168 -0.416430i
    .word 0xB67CBB50    # W512^222 = -0.914210 -0.405241i
    .word 0xB64EBB5A    # W512^223 = -0.919114 -0.393992i
    .word 0xB61FBB64    # W512^224 = -0.923880 -0.382683i
    .word 0xB5F1BB6E    # W512^225 = -0.928506 -0.371317i
    .word 0xB5C2BB77    # W512^226 = -0.932993 -0.359895i
    .word 0xB593BB80    # W512^227 = -0.937339 -0.348419i
    .word 0xB564BB88    # W512^228 = -0.941544 -0.336890i
    .word 0xB534BB91    # W512^229 = -0.945607 -0.325310i
    .word 0xB505BB99    # W512^230 = -0.949528 -0.313682i
    .word 0xB4D5BBA0    # W512^231 = -0.953306 -0.302006i
    .word 0xB4A5BBA8    # W512^232 = -0.956940 -0.290285i
    .word 0xB475BBAF    # W512^233 = -0.960431 -0.278520i
    .word 0xB444BBB6    # W512^234 = -0.963776 -0.266713i
    .word 0xB414BBBC    # W512^235 = -0.966976 -0.254866i
    .word 0xB3C6BBC3    # W512^236 = -0.970031 -0.242980i
    .word 0xB365BBC9    # W512^237 = -0.972940 -0.231058i
    .word 0xB303BBCE    # W512^238 = -0.975702 -0.219101i
    .word 0xB2A1BBD4    # W512^239 = -0.978317 -0.207111i
    .word 0xB23EBBD9    # W512^240 = -0.980785 -0.195090i
    .word 0xB1DBBBDD    # W512^241 = -0.983105 -0.183040i
    .word 0xB179BBE2    # W512^242 = -0.985278 -0.170962i
    .word 0xB115BBE6    # W512^243 = -0.987301 -0.158858i
    .word 0xB0B2BBEA    # W512^244 = -0.989177 -0.146730i
    .word 0xB04EBBED    # W512^245 = -0.990903 -0.134581i
    .word 0xAFD6BBF1    # W512^246 = -0.992480 -0.122411i
    .word 0xAF0EBBF4    # W512^247 = -0.993907 -0.110222i
    .word 0xAE46BBF6    # W512^248 = -0.995185 -0.098017i
    .word 0xAD7EBBF8    # W512^249 = -0.996313 -0.085797i
    .word 0xACB5BBFA    # W512^250 = -0.997290 -0.073565i
    .word 0xABD9BBFC    # W512^251 = -0.998118 -0.061321i
    .word 0xAA48BBFE    # W512^252 = -0.998795 -0.049068i
    .word 0xA8B6BBFF    # W512^253 = -0.999322 -0.036807i
    .word 0xA648BBFF    # W512^254 = -0.999699 -0.024541i
    .word 0xA248BC00    # W512^255 = -0.999925 -0.012272i
    # len = 1024
    .word 0x00003C00    # W1024^0 = 1.000000 +0.000000i
    .word 0x9E483C00    # W1024^1 = 0.999981 -0.006136i
    .word 0xA2483C00    # W1024^2 = 0.999925 -0.012272i
    .word 0xA4B63C00    # W1024^3 = 0.999831 -0.018407i
    .word 0xA6483BFF    # W1024^4 = 0.999699 -0.024541i
    .word 0xA7DA3BFF    # W1024^5 = 0.999529 -0.030675i
    .word 0xA8B63BFF    # W1024^6 = 0.999322 -0.036807i
    .word 0xA97F3BFE    # W1024^7 = 0.999078 -0.042938i
    .word 0xAA483BFE    # W1024^8 = 0.998795 -0.049068i
    .word 0xAB113BFD    # W1024^9 = 0.998476 -0.055195i
    .word 0xABD93BFC    # W1024^10 = 0.998118 -0.061321i
    .word 0xAC513BFB    # W1024^11 = 0.997723 -0.067444i
    .word 0xACB53BFA    # W1024^12 = 0.997290 -0.073565i
    .word 0xAD1A3BF9    # W1024^13 = 0.996820 -0.079682i
    .word 0xAD7E3BF8    # W1024^14 = 0.996313 -0.085797i
    .word 0xADE23BF7    # W1024^15 = 0.995767 -0.091909i
    .word 0xAE463BF6    # W1024^16 = 0.995185 -0.098017i
    .word 0xAEAA3BF5    # W1024^17 = 0.994565 -0.104122i
    .word 0xAF0E3BF4    # W1024^18 = 0.993907 -0.110222i
    .word 0xAF723BF2    # W1024^19 = 0.993212 -0.116319i
    .word 0xAFD63BF1    # W1024^20 = 0.992480 -0.122411i
    .word 0xB01D3BEF    # W1024^21 = 0.991710 -0.128498i
    .word 0xB04E3BED    # W1024^22 = 0.990903 -0.134581i
    .word 0xB0803BEC    # W1024^23 = 0.990058 -0.140658i
    .word 0xB0B23BEA    # W1024^24 = 0.989177 -0.146730i
    .word 0xB0E43BE8    # W1024^25 = 0.988258 -0.152797i
    .word 0xB1153BE6    # W1024^26 = 0.987301 -0.158858i
    .word 0xB1473BE4    # W1024^27 = 0.986308 -0.164913i
    .word 0xB1793BE2    # W1024^28 = 0.985278 -0.170962i
    .word 0xB1AA3BE0    # W1024^29 = 0.984210 -0.177004i
    .word 0xB1DB3BDD    # W1024^30 = 0.983105 -0.183040i
    .word 0xB20D3BDB    # W1024^31 = 0.981964 -0.189069i
    .word 0xB23E3BD9    # W1024^32 = 0.980785 -0.195090i
    .word 0xB26F3BD6    # W1024^33 = 0.979570 -0.201105i
    .word 0xB2A13BD4    # W1024^34 = 0.978317 -0.207111i
    .word 0xB2D23BD1    # W1024^35 = 0.977028 -0.213110i
    .word 0xB3033BCE    # W1024^36 = 0.975702 -0.219101i
    .word 0xB3343BCB    # W1024^37 = 0.974339 -0.225084i
    .word 0xB3653BC9    # W1024^38 = 0.972940 -0.231058i
    .word 0xB3963BC6    # W1024^39 = 0.971504 -0.237024i
    .word 0xB3C63BC3    # W1024^40 = 0.970031 -0.242980i
    .word 0xB3F73BC0    # W1024^41 = 0.968522 -0.248928i
    .word 0xB4143BBC    # W1024^42 = 0.966976 -0.254866i
    .word 0xB42C3BB9    # W1024^43 = 0.965394 -0.260794i
    .word 0xB4443BB6    # W1024^44 = 0.963776 -0.266713i
    .word 0xB45D3BB2    # W1024^45 = 0.962121 -0.272621i
    .word 0xB4753BAF    # W1024^46 = 0.960431 -0.278520i
    .word 0xB48D3BAB    # W1024^47 = 0.958703 -0.284408i
    .word 0xB4A53BA8    # W1024^48 = 0.956940 -0.290285i
    .word 0xB4BD3BA4    # W1024^49 = 0.955141 -0.296151i
    .word 0xB4D53BA0    # W1024^50 = 0.953306 -0.302006i
    .word 0xB4ED3B9D    # W1024^51 = 0.951435 -0.307850i
    .word 0xB5053B99    # W1024^52 = 0.949528 -0.313682i
    .word 0xB51D3B95    # W1024^53 = 0.947586 -0.319502i
    .word 0xB5343B91    # W1024^54 = 0.945607 -0.325310i
    .word 0xB54C3B8C    # W1024^55 = 0.943593 -0.331106i
    .word 0xB5643B88    # W1024^56 = 0.941544 -0.336890i
    .word 0xB57C3B84    # W1024^57 = 0.939459 -0.342661i
    .word 0xB5933B80    # W1024^58 = 0.937339 -0.348419i
    .word 0xB5AB3B7B    # W1024^59 = 0.935184 -0.354164i
    .word 0xB5C23B77    # W1024^60 = 0.932993 -0.359895i
    .word 0xB5DA3B72    # W1024^61 = 0.930767 -0.365613i
    .word 0xB5F13B6E    # W1024^62 = 0.928506 -0.371317i
    .word 0xB6083B69    # W1024^63 = 0.926210 -0.377007i
    .word 0xB61F3B64    # W1024^64 = 0.923880 -0.382683i
    .word 0xB6373B5F    # W1024^65 = 0.921514 -0.388345i
    .word 0xB64E3B5A    # W1024^66 = 0.919114 -0.393992i
    .word 0xB6653B55    # W1024^67 = 0.916679 -0.399624i
    .word 0xB67C3B50    # W1024^68 = 0.914210 -0.405241i
    .word 0xB6933B4B    # W1024^69 = 0.911706 -0.410843i
    .word 0xB6AA3B46    # W1024^70 = 0.909168 -0.416430i
    .word 0xB6C13B41    # W1024^71 = 0.906596 -0.422000i
    .word 0xB6D73B3B    # W1024^72 = 0.903989 -0.427555i
    .word 0xB6EE3B36    # W1024^73 = 0.901349 -0.433094i
    .word 0xB7053B30    # W1024^74 = 0.898674 -0.438616i
    .word 0xB71B3B2B    # W1024^75 = 0.895966 -0.444122i
    .word 0xB7323B25    # W1024^76 = 0.893224 -0.449611i
    .word 0xB7483B20    # W1024^77 = 0.890449 -0.455084i
    .word 0xB75E3B1A    # W1024^78 = 0.887640 -0.460539i
    .word 0xB7753B14    # W1024^79 = 0.884797 -0.465976i
    .word 0xB78B3B0E    # W1024^80 = 0.881921 -0.471397i
    .word 0xB7A13B08    # W1024^81 = 0.879012 -0.476799i
    .word 0xB7B73B02    # W1024^82 = 0.876070 -0.482184i
    .word 0xB7CD3AFC    # W1024^83 = 0.873095 -0.487550i
    .word 0xB7E33AF6    # W1024^84 = 0.870087 -0.492898i
    .word 0xB7F93AF0    # W1024^85 = 0.867046 -0.498228i
    .word 0xB8073AE9    # W1024^86 = 0.863973 -0.503538i
    .word 0xB8123AE3    # W1024^87 = 0.860867 -0.508830i
    .word 0xB81D3ADD    # W1024^88 = 0.857729 -0.514103i
    .word 0xB8283AD6    # W1024^89 = 0.854558 -0.519356i
    .word 0xB8323AD0    # W1024^90 = 0.851355 -0.524590i
    .word 0xB83D3AC9    # W1024^91 = 0.848120 -0.529804i
    .word 0xB8483AC2    # W1024^92 = 0.844854 -0.534998i
    .word 0xB8523ABC    # W1024^93 = 0.841555 -0.540171i
    .word 0xB85D3AB5    # W1024^94 = 0.838225 -0.545325i
    .word 0xB8673AAE    # W1024^95 = 0.834863 -0.550458i
    .word 0xB8723AA7    # W1024^96 = 0.831470 -0.555570i
    .word 0xB87C3AA0    # W1024^97 = 0.828045 -0.560662i
    .word 0xB8873A99    # W1024^98 = 0.824589 -0.565732i
    .word 0xB8913A92    # W1024^99 = 0.821103 -0.570781i
    .word 0xB89B3A8A    # W1024^100 = 0.817585 -0.575808i
    .word 0xB8A63A83    # W1024^101 = 0.814036 -0.580814i
    .word 0xB8B03A7C    # W1024^102 = 0.810457 -0.585798i
    .word 0xB8BA3A74    # W1024^103 = 0.806848 -0.590760i
    .word 0xB8C43A6D    # W1024^104 = 0.803208 -0.595699i
    .word 0xB8CE3A65    # W1024^105 = 0.799537 -0.600616i
    .word 0xB8D83A5E    # W1024^106 = 0.795837 -0.605511i
    .word 0xB8E23A56    # W1024^107 = 0.792107 -0.610383i
    .word 0xB8EC3A4F    # W1024^108 = 0.788346 -0.615232i
    .word 0xB8F63A47    # W1024^109 = 0.784557 -0.620057i
    .word 0xB9003A3F    # W1024^110 = 0.780737 -0.624859i
    .word 0xB9093A37    # W1024^111 = 0.776888 -0.629638i
    .word 0xB9133A2F    # W1024^112 = 0.773010 -0.634393i
    .word 0xB91D3A27    # W1024^113 = 0.769103 -0.639124i
    .word 0xB9273A1F    # W1024^114 = 0.765167 -0.643832i
    .word 0xB9303A17    # W1024^115 = 0.761202 -0.648514i
    .word 0xB93A3A0F    # W1024^116 = 0.757209 -0.653173i
    .word 0xB9433A07    # W1024^117 = 0.753187 -0.657807i
    .word 0xB94D39FE    # W1024^118 = 0.749136 -0.662416i
    .word 0xB95639F6    # W1024^119 = 0.745058 -0.667000i
    .word 0xB95F39ED    # W1024^120 = 0.740951 -0.671559i
    .word 0xB96939E5    # W1024^121 = 0.736817 -0.676093i
    .word 0xB97239DC    # W1024^122 = 0.732654 -0.680601i
    .word 0xB97B39D4    # W1024^123 = 0.728464 -0.685084i
    .word 0xB98439CB    # W1024^124 = 0.724247 -0.689541i
    .word 0xB98D39C3    # W1024^125 = 0.720003 -0.693971i
    .word 0xB99639BA    # W1024^126 = 0.715731 -0.698376i
    .word 0xB99F39B1    # W1024^127 = 0.711432 -0.702755i
    .word 0xB9A839A8    # W1024^128 = 0.707107 -0.707107i
    .word 0xB9B1399F    # W1024^129 = 0.702755 -0.711432i
    .word 0xB9BA3996    # W1024^130 = 0.698376 -0.715731i
    .word 0xB9C3398D    # W1024^131 = 0.693971 -0.720003i
    .word 0xB9CB3984    # W1024^132 = 0.689541 -0.724247i
    .word 0xB9D4397B    # W1024^133 = 0.685084 -0.728464i
    .word 0xB9DC3972    # W1024^134 = 0.680601 -0.732654i
    .word 0xB9E53969    # W1024^135 = 0.676093 -0.736817i
    .word 0xB9ED395F    # W1024^136 = 0.671559 -0.740951i
    .word 0xB9F63956    # W1024^137 = 0.667000 -0.745058i
    .word 0xB9FE394D    # W1024^138 = 0.662416 -0.749136i
    .word 0xBA073943    # W1024^139 = 0.657807 -0.753187i
    .word 0xBA0F393A    # W1024^140 = 0.653173 -0.757209i
    .word 0xBA173930    # W1024^141 = 0.648514 -0.761202i
    .word 0xBA1F3927    # W1024^142 = 0.643832 -0.765167i
    .word 0xBA27391D    # W1024^143 = 0.639124 -0.769103i
    .word 0xBA2F3913    # W1024^144 = 0.634393 -0.773010i
    .word 0xBA373909    # W1024^145 = 0.629638 -0.776888i
    .word 0xBA3F3900    # W1024^146 = 0.624859 -0.780737i
    .word 0xBA4738F6    # W1024^147 = 0.620057 -0.784557i
    .word 0xBA4F38EC    # W1024^148 = 0.615232 -0.788346i
    .word 0xBA5638E2    # W1024^149 = 0.610383 -0.792107i
    .word 0xBA5E38D8    # W1024^150 = 0.605511 -0.795837i
    .word 0xBA6538CE    # W1024^151 = 0.600616 -0.799537i
    .word 0xBA6D38C4    # W1024^152 = 0.595699 -0.803208i
    .word 0xBA7438BA    # W1024^153 = 0.590760 -0.806848i
    .word 0xBA7C38B0    # W1024^154 = 0.585798 -0.810457i
    .word 0xBA8338A6    # W1024^155 = 0.580814 -0.814036i
    .word 0xBA8A389B    # W1024^156 = 0.575808 -0.817585i
    .word 0xBA923891    # W1024^157 = 0.570781 -0.821103i
    .word 0xBA993887    # W1024^158 = 0.565732 -0.824589i
    .word 0xBAA0387C    # W1024^159 = 0.560662 -0.828045i
    .word 0xBAA73872    # W1024^160 = 0.555570 -0.831470i
    .word 0xBAAE3867    # W1024^161 = 0.550458 -0.834863i
    .word 0xBAB5385D    # W1024^162 = 0.545325 -0.838225i
    .word 0xBABC3852    # W1024^163 = 0.540171 -0.841555i
    .word 0xBAC23848    # W1024^164 = 0.534998 -0.844854i
    .word 0xBAC9383D    # W1024^165 = 0.529804 -0.848120i
    .word 0xBAD03832    # W1024^166 = 0.524590 -0.851355i
    .word 0xBAD63828    # W1024^167 = 0.519356 -0.854558i
    .word 0xBADD381D    # W1024^168 = 0.514103 -0.857729i
    .word 0xBAE33812    # W1024^169 = 0.508830 -0.860867i
    .word 0xBAE93807    # W1024^170 = 0.503538 -0.863973i
    .word 0xBAF037F9    # W1024^171 = 0.498228 -0.867046i
    .word 0xBAF637E3    # W1024^172 = 0.492898 -0.870087i
    .word 0xBAFC37CD    # W1024^173 = 0.487550 -0.873095i
    .word 0xBB0237B7    # W1024^174 = 0.482184 -0.876070i
    .word 0xBB0837A1    # W1024^175 = 0.476799 -0.879012i
    .word 0xBB0E378B    # W1024^176 = 0.471397 -0.881921i
    .word 0xBB143775    # W1024^177 = 0.465976 -0.884797i
    .word 0xBB1A375E    # W1024^178 = 0.460539 -0.887640i
    .word 0xBB203748    # W1024^179 = 0.455084 -0.890449i
    .word 0xBB253732    # W1024^180 = 0.449611 -0.893224i
    .word 0xBB2B371B    # W1024^181 = 0.444122 -0.895966i
    .word 0xBB303705    # W1024^182 = 0.438616 -0.898674i
    .word 0xBB3636EE    # W1024^183 = 0.433094 -0.901349i
    .word 0xBB3B36D7    # W1024^184 = 0.427555 -0.903989i
    .word 0xBB4136C1    # W1024^185 = 0.422000 -0.906596i
    .word 0xBB4636AA    # W1024^186 = 0.416430 -0.909168i
    .word 0xBB4B3693    # W1024^187 = 0.410843 -0.911706i
    .word 0xBB50367C    # W1024^188 = 0.405241 -0.914210i
    .word 0xBB553665    # W1024^189 = 0.399624 -0.916679i
    .word 0xBB5A364E    # W1024^190 = 0.393992 -0.919114i
    .word 0xBB5F3637    # W1024^191 = 0.388345 -0.921514i
    .word 0xBB64361F    # W1024^192 = 0.382683 -0.923880i
    .word 0xBB693608    # W1024^193 = 0.377007 -0.926210i
    .word 0xBB6E35F1    # W1024^194 = 0.371317 -0.928506i
    .word 0xBB7235DA    # W1024^195 = 0.365613 -0.930767i
    .word 0xBB7735C2    # W1024^196 = 0.359895 -0.932993i
    .word 0xBB7B35AB    # W1024^197 = 0.354164 -0.935184i
    .word 0xBB803593    # W1024^198 = 0.348419 -0.937339i
    .word 0xBB84357C    # W1024^199 = 0.342661 -0.939459i
    .word 0xBB883564    # W1024^200 = 0.336890 -0.941544i
    .word 0xBB8C354C    # W1024^201 = 0.331106 -0.943593i
    .word 0xBB913534    # W1024^202 = 0.325310 -0.945607i
    .word 0xBB95351D    # W1024^203 = 0.319502 -0.947586i
    .word 0xBB993505    # W1024^204 = 0.313682 -0.949528i
    .word 0xBB9D34ED    # W1024^205 = 0.307850 -0.951435i
    .word 0xBBA034D5    # W1024^206 = 0.302006 -0.953306i
    .word 0xBBA434BD    # W1024^207 = 0.296151 -0.955141i
    .word 0xBBA834A5    # W1024^208 = 0.290285 -0.956940i
    .word 0xBBAB348D    # W1024^209 = 0.284408 -0.958703i
    .word 0xBBAF3475    # W1024^210 = 0.278520 -0.960431i
    .word 0xBBB2345D    # W1024^211 = 0.272621 -0.962121i
    .word 0xBBB63444    # W1024^212 = 0.266713 -0.963776i
    .word 0xBBB9342C    # W1024^213 = 0.260794 -0.965394i
    .word 0xBBBC3414    # W1024^214 = 0.254866 -0.966976i
    .word 0xBBC033F7    # W1024^215 = 0.248928 -0.968522i
    .word 0xBBC333C6    # W1024^216 = 0.242980 -0.970031i
    .word 0xBBC63396    # W1024^217 = 0.237024 -0.971504i
    .word 0xBBC93365    # W1024^218 = 0.231058 -0.972940i
    .word 0xBBCB3334    # W1024^219 = 0.225084 -0.974339i
    .word 0xBBCE3303    # W1024^220 = 0.219101 -0.975702i
    .word 0xBBD132D2    # W1024^221 = 0.213110 -0.977028i
    .word 0xBBD432A1    # W1024^222 = 0.207111 -0.978317i
    .word 0xBBD6326F    # W1024^223 = 0.201105 -0.979570i
    .word 0xBBD9323E    # W1024^224 = 0.195090 -0.980785i
    .word 0xBBDB320D    # W1024^225 = 0.189069 -0.981964i
    .word 0xBBDD31DB    # W1024^226 = 0.183040 -0.983105i
    .word 0xBBE031AA    # W1024^227 = 0.177004 -0.984210i
    .word 0xBBE23179    # W1024^228 = 0.170962 -0.985278i
    .word 0xBBE43147    # W1024^229 = 0.164913 -0.986308i
    .word 0xBBE63115    # W1024^230 = 0.158858 -0.987301i
    .word 0xBBE830E4    # W1024^231 = 0.152797 -0.988258i
    .word 0xBBEA30B2    # W1024^232 = 0.146730 -0.989177i
    .word 0xBBEC3080    # W1024^233 = 0.140658 -0.990058i
    .word 0xBBED304E    # W1024^234 = 0.134581 -0.990903i
    .word 0xBBEF301D    # W1024^235 = 0.128498 -0.991710i
    .word 0xBBF12FD6    # W1024^236 = 0.122411 -0.992480i
    .word 0xBBF22F72    # W1024^237 = 0.116319 -0.993212i
    .word 0xBBF42F0E    # W1024^238 = 0.110222 -0.993907i
    .word 0xBBF52EAA    # W1024^239 = 0.104122 -0.994565i
    .word 0xBBF62E46    # W1024^240 = 0.098017 -0.995185i
    .word 0xBBF72DE2    # W1024^241 = 0.091909 -0.995767i
    .word 0xBBF82D7E    # W1024^242 = 0.085797 -0.996313i
    .word 0xBBF92D1A    # W1024^243 = 0.079682 -0.996820i
    .word 0xBBFA2CB5    # W1024^244 = 0.073565 -0.997290i
    .word 0xBBFB2C51    # W1024^245 = 0.067444 -0.997723i
    .word 0xBBFC2BD9    # W1024^246 = 0.061321 -0.998118i
    .word 0xBBFD2B11    # W1024^247 = 0.055195 -0.998476i
    .word 0xBBFE2A48    # W1024^248 = 0.049068 -0.998795i
    .word 0xBBFE297F    # W1024^249 = 0.042938 -0.999078i
    .word 0xBBFF28B6    # W1024^250 = 0.036807 -0.999322i
    .word 0xBBFF27DA    # W1024^251 = 0.030675 -0.999529i
    .word 0xBBFF2648    # W1024^252 = 0.024541 -0.999699i
    .word 0xBC0024B6    # W1024^253 = 0.018407 -0.999831i
    .word 0xBC002248    # W1024^254 = 0.012272 -0.999925i
    .word 0xBC001E48    # W1024^255 = 0.006136 -0.999981i
    .word 0xBC000000    # W1024^256 = 0.000000 -1.000000i
    .word 0xBC009E48    # W1024^257 = -0.006136 -0.999981i
    .word 0xBC00A248    # W1024^258 = -0.012272 -0.999925i
    .word 0xBC00A4B6    # W1024^259 = -0.018407 -0.999831i
    .word 0xBBFFA648    # W1024^260 = -0.024541 -0.999699i
    .word 0xBBFFA7DA    # W1024^261 = -0.030675 -0.999529i
    .word 0xBBFFA8B6    # W1024^262 = -0.036807 -0.999322i
    .word 0xBBFEA97F    # W1024^263 = -0.042938 -0.999078i
    .word 0xBBFEAA48    # W1024^264 = -0.049068 -0.998795i
    .word 0xBBFDAB11    # W1024^265 = -0.055195 -0.998476i
    .word 0xBBFCABD9    # W1024^266 = -0.061321 -0.998118i
    .word 0xBBFBAC51    # W1024^267 = -0.067444 -0.997723i
    .word 0xBBFAACB5    # W1024^268 = -0.073565 -0.997290i
    .word 0xBBF9AD1A    # W1024^269 = -0.079682 -0.996820i
    .word 0xBBF8AD7E    # W1024^270 = -0.085797 -0.996313i
    .word 0xBBF7ADE2    # W1024^271 = -0.091909 -0.995767i
    .word 0xBBF6AE46    # W1024^272 = -0.098017 -0.995185i
    .word 0xBBF5AEAA    # W1024^273 = -0.104122 -0.994565i
    .word 0xBBF4AF0E    # W1024^274 = -0.110222 -0.993907i
    .word 0xBBF2AF72    # W1024^275 = -0.116319 -0.993212i
    .word 0xBBF1AFD6    # W1024^276 = -0.122411 -0.992480i
    .word 0xBBEFB01D    # W1024^277 = -0.128498 -0.991710i
    .word 0xBBEDB04E    # W1024^278 = -0.134581 -0.990903i
    .word 0xBBECB080    # W1024^279 = -0.140658 -0.990058i
    .word 0xBBEAB0B2    # W1024^280 = -0.146730 -0.989177i
    .word 0xBBE8B0E4    # W1024^281 = -0.152797 -0.988258i
    .word 0xBBE6B115    # W1024^282 = -0.158858 -0.987301i
    .word 0xBBE4B147    # W1024^283 = -0.164913 -0.986308i
    .word 0xBBE2B179    # W1024^284 = -0.170962 -0.985278i
    .word 0xBBE0B1AA    # W1024^285 = -0.177004 -0.984210i
    .word 0xBBDDB1DB    # W1024^286 = -0.183040 -0.983105i
    .word 0xBBDBB20D    # W1024^287 = -0.189069 -0.981964i
    .word 0xBBD9B23E    # W1024^288 = -0.195090 -0.980785i
    .word 0xBBD6B26F    # W1024^289 = -0.201105 -0.979570i
    .word 0xBBD4B2A1    # W1024^290 = -0.207111 -0.978317i
    .word 0xBBD1B2D2    # W1024^291 = -0.213110 -0.977028i
    .word 0xBBCEB303    # W1024^292 = -0.219101 -0.975702i
    .word 0xBBCBB334    # W1024^293 = -0.225084 -0.974339i
    .word 0xBBC9B365    # W1024^294 = -0.231058 -0.972940i
    .word 0xBBC6B396    # W1024^295 = -0.237024 -0.971504i
    .word 0xBBC3B3C6    # W1024^296 = -0.242980 -0.970031i
    .word 0xBBC0B3F7    # W1024^297 = -0.248928 -0.968522i
    .word 0xBBBCB414    # W1024^298 = -0.254866 -0.966976i
    .word 0xBBB9B42C    # W1024^299 = -0.260794 -0.965394i
    .word 0xBBB6B444    # W1024^300 = -0.266713 -0.963776i
    .word 0xBBB2B45D    # W1024^301 = -0.272621 -0.962121i
    .word 0xBBAFB475    # W1024^302 = -0.278520 -0.960431i
    .word 0xBBABB48D    # W1024^303 = -0.284408 -0.958703i
    .word 0xBBA8B4A5    # W1024^304 = -0.290285 -0.956940i
    .word 0xBBA4B4BD    # W1024^305 = -0.296151 -0.955141i
    .word 0xBBA0B4D5    # W1024^306 = -0.302006 -0.953306i
    .word 0xBB9DB4ED    # W1024^307 = -0.307850 -0.951435i
    .word 0xBB99B505    # W1024^308 = -0.313682 -0.949528i
    .word 0xBB95B51D    # W1024^309 = -0.319502 -0.947586i
    .word 0xBB91B534    # W1024^310 = -0.325310 -0.945607i
    .word 0xBB8CB54C    # W1024^311 = -0.331106 -0.943593i
    .word 0xBB88B564    # W1024^312 = -0.336890 -0.941544i
    .word 0xBB84B57C    # W1024^313 = -0.342661 -0.939459i
    .word 0xBB80B593    # W1024^314 = -0.348419 -0.937339i
    .word 0xBB7BB5AB    # W1024^315 = -0.354164 -0.935184i
    .word 0xBB77B5C2    # W1024^316 = -0.359895 -0.932993i
    .word 0xBB72B5DA    # W1024^317 = -0.365613 -0.930767i
    .word 0xBB6EB5F1    # W1024^318 = -0.371317 -0.928506i
    .word 0xBB69B608    # W1024^319 = -0.377007 -0.926210i
    .word 0xBB64B61F    # W1024^320 = -0.382683 -0.923880i
    .word 0xBB5FB637    # W1024^321 = -0.388345 -0.921514i
    .word 0xBB5AB64E    # W1024^322 = -0.393992 -0.919114i
    .word 0xBB55B665    # W1024^323 = -0.399624 -0.916679i
    .word 0xBB50B67C    # W1024^324 = -0.405241 -0.914210i
    .word 0xBB4BB693    # W1024^325 = -0.410843 -0.911706i
    .word 0xBB46B6AA    # W1024^326 = -0.416430 -0.909168i
    .word 0xBB41B6C1    # W1024^327 = -0.422000 -0.906596i
    .word 0xBB3BB6D7    # W1024^328 = -0.427555 -0.903989i
    .word 0xBB36B6EE    # W1024^329 = -0.433094 -0.901349i
    .word 0xBB30B705    # W1024^330 = -0.438616 -0.898674i
    .word 0xBB2BB71B    # W1024^331 = -0.444122 -0.895966i
    .word 0xBB25B732    # W1024^332 = -0.449611 -0.893224i
    .word 0xBB20B748    # W1024^333 = -0.455084 -0.890449i
    .word 0xBB1AB75E    # W1024^334 = -0.460539 -0.887640i
    .word 0xBB14B775    # W1024^335 = -0.465976 -0.884797i
    .word 0xBB0EB78B    # W1024^336 = -0.471397 -0.881921i
    .word 0xBB08B7A1    # W1024^337 = -0.476799 -0.879012i
    .word 0xBB02B7B7    # W1024^338 = -0.482184 -0.876070i
    .word 0xBAFCB7CD    # W1024^339 = -0.487550 -0.873095i
    .word 0xBAF6B7E3    # W1024^340 = -0.492898 -0.870087i
    .word 0xBAF0B7F9    # W1024^341 = -0.498228 -0.867046i
    .word 0xBAE9B807    # W1024^342 = -0.503538 -0.863973i
    .word 0xBAE3B812    # W1024^343 = -0.508830 -0.860867i
    .word 0xBADDB81D    # W1024^344 = -0.514103 -0.857729i
    .word 0xBAD6B828    # W1024^345 = -0.519356 -0.854558i
    .word 0xBAD0B832    # W1024^346 = -0.524590 -0.851355i
    .word 0xBAC9B83D    # W1024^347 = -0.529804 -0.848120i
    .word 0xBAC2B848    # W1024^348 = -0.534998 -0.844854i
    .word 0xBABCB852    # W1024^349 = -0.540171 -0.841555i
    .word 0xBAB5B85D    # W1024^350 = -0.545325 -0.838225i
    .word 0xBAAEB867    # W1024^351 = -0.550458 -0.834863i
    .word 0xBAA7B872    # W1024^352 = -0.555570 -0.831470i
    .word 0xBAA0B87C    # W1024^353 = -0.560662 -0.828045i
    .word 0xBA99B887    # W1024^354 = -0.565732 -0.824589i
    .word 0xBA92B891    # W1024^355 = -0.570781 -0.821103i
    .word 0xBA8AB89B    # W1024^356 = -0.575808 -0.817585i
    .word 0xBA83B8A6    # W1024^357 = -0.580814 -0.814036i
    .word 0xBA7CB8B0    # W1024^358 = -0.585798 -0.810457i
    .word 0xBA74B8BA    # W1024^359 = -0.590760 -0.806848i
    .word 0xBA6DB8C4    # W1024^360 = -0.595699 -0.803208i
    .word 0xBA65B8CE    # W1024^361 = -0.600616 -0.799537i
    .word 0xBA5EB8D8    # W1024^362 = -0.605511 -0.795837i
    .word 0xBA56B8E2    # W1024^363 = -0.610383 -0.792107i
    .word 0xBA4FB8EC    # W1024^364 = -0.615232 -0.788346i
    .word 0xBA47B8F6    # W1024^365 = -0.620057 -0.784557i
    .word 0xBA3FB900    # W1024^366 = -0.624859 -0.780737i
    .word 0xBA37B909    # W1024^367 = -0.629638 -0.776888i
    .word 0xBA2FB913    # W1024^368 = -0.634393 -0.773010i
    .word 0xBA27B91D    # W1024^369 = -0.639124 -0.769103i
    .word 0xBA1FB927    # W1024^370 = -0.643832 -0.765167i
    .word 0xBA17B930    # W1024^371 = -0.648514 -0.761202i
    .word 0xBA0FB93A    # W1024^372 = -0.653173 -0.757209i
    .word 0xBA07B943    # W1024^373 = -0.657807 -0.753187i
    .word 0xB9FEB94D    # W1024^374 = -0.662416 -0.749136i
    .word 0xB9F6B956    # W1024^375 = -0.667000 -0.745058i
    .word 0xB9EDB95F    # W1024^376 = -0.671559 -0.740951i
    .word 0xB9E5B969    # W1024^377 = -0.676093 -0.736817i
    .word 0xB9DCB972    # W1024^378 = -0.680601 -0.732654i
    .word 0xB9D4B97B    # W1024^379 = -0.685084 -0.728464i
    .word 0xB9CBB984    # W1024^380 = -0.689541 -0.724247i
    .word 0xB9C3B98D    # W1024^381 = -0.693971 -0.720003i
    .word 0xB9BAB996    # W1024^382 = -0.698376 -0.715731i
    .word 0xB9B1B99F    # W1024^383 = -0.702755 -0.711432i
    .word 0xB9A8B9A8    # W1024^384 = -0.707107 -0.707107i
    .word 0xB99FB9B1    # W1024^385 = -0.711432 -0.702755i
    .word 0xB996B9BA    # W1024^386 = -0.715731 -0.698376i
    .word 0xB98DB9C3    # W1024^387 = -0.720003 -0.693971i
    .word 0xB984B9CB    # W1024^388 = -0.724247 -0.689541i
    .word 0xB97BB9D4    # W1024^389 = -0.728464 -0.685084i
    .word 0xB972B9DC    # W1024^390 = -0.732654 -0.680601i
    .word 0xB969B9E5    # W1024^391 = -0.736817 -0.676093i
    .word 0xB95FB9ED    # W1024^392 = -0.740951 -0.671559i
    .word 0xB956B9F6    # W1024^393 = -0.745058 -0.667000i
    .word 0xB94DB9FE    # W1024^394 = -0.749136 -0.662416i
    .word 0xB943BA07    # W1024^395 = -0.753187 -0.657807i
    .word 0xB93ABA0F    # W1024^396 = -0.757209 -0.653173i
    .word 0xB930BA17    # W1024^397 = -0.761202 -0.648514i
    .word 0xB927BA1F    # W1024^398 = -0.765167 -0.643832i
    .word 0xB91DBA27    # W1024^399 = -0.769103 -0.639124i
    .word 0xB913BA2F    # W1024^400 = -0.773010 -0.634393i
    .word 0xB909BA37    # W1024^401 = -0.776888 -0.629638i
    .word 0xB900BA3F    # W1024^402 = -0.780737 -0.624859i
    .word 0xB8F6BA47    # W1024^403 = -0.784557 -0.620057i
    .word 0xB8ECBA4F    # W1024^404 = -0.788346 -0.615232i
    .word 0xB8E2BA56    # W1024^405 = -0.792107 -0.610383i
    .word 0xB8D8BA5E    # W1024^406 = -0.795837 -0.605511i
    .word 0xB8CEBA65    # W1024^407 = -0.799537 -0.600616i
    .word 0xB8C4BA6D    # W1024^408 = -0.803208 -0.595699i
    .word 0xB8BABA74    # W1024^409 = -0.806848 -0.590760i
    .word 0xB8B0BA7C    # W1024^410 = -0.810457 -0.585798i
    .word 0xB8A6BA83    # W1024^411 = -0.814036 -0.580814i
    .word 0xB89BBA8A    # W1024^412 = -0.817585 -0.575808i
    .word 0xB891BA92    # W1024^413 = -0.821103 -0.570781i
    .word 0xB887BA99    # W1024^414 = -0.824589 -0.565732i
    .word 0xB87CBAA0    # W1024^415 = -0.828045 -0.560662i
    .word 0xB872BAA7    # W1024^416 = -0.831470 -0.555570i
    .word 0xB867BAAE    # W1024^417 = -0.834863 -0.550458i
    .word 0xB85DBAB5    # W1024^418 = -0.838225 -0.545325i
    .word 0xB852BABC    # W1024^419 = -0.841555 -0.540171i
    .word 0xB848BAC2    # W1024^420 = -0.844854 -0.534998i
    .word 0xB83DBAC9    # W1024^421 = -0.848120 -0.529804i
    .word 0xB832BAD0    # W1024^422 = -0.851355 -0.524590i
    .word 0xB828BAD6    # W1024^423 = -0.854558 -0.519356i
    .word 0xB81DBADD    # W1024^424 = -0.857729 -0.514103i
    .word 0xB812BAE3    # W1024^425 = -0.860867 -0.508830i
    .word 0xB807BAE9    # W1024^426 = -0.863973 -0.503538i
    .word 0xB7F9BAF0    # W1024^427 = -0.867046 -0.498228i
    .word 0xB7E3BAF6    # W1024^428 = -0.870087 -0.492898i
    .word 0xB7CDBAFC    # W1024^429 = -0.873095 -0.487550i
    .word 0xB7B7BB02    # W1024^430 = -0.876070 -0.482184i
    .word 0xB7A1BB08    # W1024^431 = -0.879012 -0.476799i
    .word 0xB78BBB0E    # W1024^432 = -0.881921 -0.471397i
    .word 0xB775BB14    # W1024^433 = -0.884797 -0.465976i
    .word 0xB75EBB1A    # W1024^434 = -0.887640 -0.460539i
    .word 0xB748BB20    # W1024^435 = -0.890449 -0.455084i
    .word 0xB732BB25    # W1024^436 = -0.893224 -0.449611i
    .word 0xB71BBB2B    # W1024^437 = -0.895966 -0.444122i
    .word 0xB705BB30    # W1024^438 = -0.898674 -0.438616i
    .word 0xB6EEBB36    # W1024^439 = -0.901349 -0.433094i
    .word 0xB6D7BB3B    # W1024^440 = -0.903989 -0.427555i
    .word 0xB6C1BB41    # W1024^441 = -0.906596 -0.422000i
    .word 0xB6AABB46    # W1024^442 = -0.909168 -0.416430i
    .word 0xB693BB4B    # W1024^443 = -0.911706 -0.410843i
    .word 0xB67CBB50    # W1024^444 = -0.914210 -0.405241i
    .word 0xB665BB55    # W1024^445 = -0.916679 -0.399624i
    .word 0xB64EBB5A    # W1024^446 = -0.919114 -0.393992i
    .word 0xB637BB5F    # W1024^447 = -0.921514 -0.388345i
    .word 0xB61FBB64    # W1024^448 = -0.923880 -0.382683i
    .word 0xB608BB69    # W1024^449 = -0.926210 -0.377007i
    .word 0xB5F1BB6E    # W1024^450 = -0.928506 -0.371317i
    .word 0xB5DABB72    # W1024^451 = -0.930767 -0.365613i
    .word 0xB5C2BB77    # W1024^452 = -0.932993 -0.359895i
    .word 0xB5ABBB7B    # W1024^453 = -0.935184 -0.354164i
    .word 0xB593BB80    # W1024^454 = -0.937339 -0.348419i
    .word 0xB57CBB84    # W1024^455 = -0.939459 -0.342661i
    .word 0xB564BB88    # W1024^456 = -0.941544 -0.336890i
    .word 0xB54CBB8C    # W1024^457 = -0.943593 -0.331106i
    .word 0xB534BB91    # W1024^458 = -0.945607 -0.325310i
    .word 0xB51DBB95    # W1024^459 = -0.947586 -0.319502i
    .word 0xB505BB99    # W1024^460 = -0.949528 -0.313682i
    .word 0xB4EDBB9D    # W1024^461 = -0.951435 -0.307850i
    .word 0xB4D5BBA0    # W1024^462 = -0.953306 -0.302006i
    .word 0xB4BDBBA4    # W1024^463 = -0.955141 -0.296151i
    .word 0xB4A5BBA8    # W1024^464 = -0.956940 -0.290285i
    .word 0xB48DBBAB    # W1024^465 = -0.958703 -0.284408i
    .word 0xB475BBAF    # W1024^466 = -0.960431 -0.278520i
    .word 0xB45DBBB2    # W1024^467 = -0.962121 -0.272621i
    .word 0xB444BBB6    # W1024^468 = -0.963776 -0.266713i
    .word 0xB42CBBB9    # W1024^469 = -0.965394 -0.260794i
    .word 0xB414BBBC    # W1024^470 = -0.966976 -0.254866i
    .word 0xB3F7BBC0    # W1024^471 = -0.968522 -0.248928i
    .word 0xB3C6BBC3    # W1024^472 = -0.970031 -0.242980i
    .word 0xB396BBC6    # W1024^473 = -0.971504 -0.237024i
    .word 0xB365BBC9    # W1024^474 = -0.972940 -0.231058i
    .word 0xB334BBCB    # W1024^475 = -0.974339 -0.225084i
    .word 0xB303BBCE    # W1024^476 = -0.975702 -0.219101i
    .word 0xB2D2BBD1    # W1024^477 = -0.977028 -0.213110i
    .word 0xB2A1BBD4    # W1024^478 = -0.978317 -0.207111i
    .word 0xB26FBBD6    # W1024^479 = -0.979570 -0.201105i
    .word 0xB23EBBD9    # W1024^480 = -0.980785 -0.195090i
    .word 0xB20DBBDB    # W1024^481 = -0.981964 -0.189069i
    .word 0xB1DBBBDD    # W1024^482 = -0.983105 -0.183040i
    .word 0xB1AABBE0    # W1024^483 = -0.984210 -0.177004i
    .word 0xB179BBE2    # W1024^484 = -0.985278 -0.170962i
    .word 0xB147BBE4    # W1024^485 = -0.986308 -0.164913i
    .word 0xB115BBE6    # W1024^486 = -0.987301 -0.158858i
    .word 0xB0E4BBE8    # W1024^487 = -0.988258 -0.152797i
    .word 0xB0B2BBEA    # W1024^488 = -0.989177 -0.146730i
    .word 0xB080BBEC    # W1024^489 = -0.990058 -0.140658i
    .word 0xB04EBBED    # W1024^490 = -0.990903 -0.134581i
    .word 0xB01DBBEF    # W1024^491 = -0.991710 -0.128498i
    .word 0xAFD6BBF1    # W1024^492 = -0.992480 -0.122411i
    .word 0xAF72BBF2    # W1024^493 = -0.993212 -0.116319i
    .word 0xAF0EBBF4    # W1024^494 = -0.993907 -0.110222i
    .word 0xAEAABBF5    # W1024^495 = -0.994565 -0.104122i
    .word 0xAE46BBF6    # W1024^496 = -0.995185 -0.098017i
    .word 0xADE2BBF7    # W1024^497 = -0.995767 -0.091909i
    .word 0xAD7EBBF8    # W1024^498 = -0.996313 -0.085797i
    .word 0xAD1ABBF9    # W1024^499 = -0.996820 -0.079682i
    .word 0xACB5BBFA    # W1024^500 = -0.997290 -0.073565i
    .word 0xAC51BBFB    # W1024^501 = -0.997723 -0.067444i
    .word 0xABD9BBFC    # W1024^502 = -0.998118 -0.061321i
    .word 0xAB11BBFD    # W1024^503 = -0.998476 -0.055195i
    .word 0xAA48BBFE    # W1024^504 = -0.998795 -0.049068i
    .word 0xA97FBBFE    # W1024^505 = -0.999078 -0.042938i
    .word 0xA8B6BBFF    # W1024^506 = -0.999322 -0.036807i
    .word 0xA7DABBFF    # W1024^507 = -0.999529 -0.030675i
    .word 0xA648BBFF    # W1024^508 = -0.999699 -0.024541i
    .word 0xA4B6BC00    # W1024^509 = -0.999831 -0.018407i
    .word 0xA248BC00    # W1024^510 = -0.999925 -0.012272i
    .word 0x9E48BC00    # W1024^511 = -0.999981 -0.006136i

# 32-byte scratch for the len-2 lane shuffle: E @0, O @8, S @16, D @24
scratch: .word 0, 0, 0, 0, 0, 0, 0, 0

.text
main:
    la   s0, x
    li   s1, 1024

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
