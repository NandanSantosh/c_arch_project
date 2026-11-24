# Packed-fp16 radix-2 DIT FFT, N = 1024
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
    .word 0x27B8BBFE    # x[256]
    .word 0xB2C5BA64    # x[257]
    .word 0xB8DE3599    # x[258]
    .word 0x3963B6DF    # x[259]
    .word 0xB9F53450    # x[260]
    .word 0xBA5E2D6D    # x[261]
    .word 0x350C3960    # x[262]
    .word 0x3B07BA19    # x[263]
    .word 0xB85438D3    # x[264]
    .word 0xB9BCABBC    # x[265]
    .word 0xB9E3386F    # x[266]
    .word 0x31552CD9    # x[267]
    .word 0xAF42B381    # x[268]
    .word 0x3B2AAD10    # x[269]
    .word 0x2712B598    # x[270]
    .word 0xBAB3AE13    # x[271]
    .word 0xB1312FAE    # x[272]
    .word 0xBBB42F54    # x[273]
    .word 0xAF4B3854    # x[274]
    .word 0x2F0538D0    # x[275]
    .word 0xB9F83A73    # x[276]
    .word 0xAF32B7AA    # x[277]
    .word 0x3B903BBF    # x[278]
    .word 0x38DDB428    # x[279]
    .word 0x344B3B13    # x[280]
    .word 0xB9A6395D    # x[281]
    .word 0x39E6B0CE    # x[282]
    .word 0xB913B8A5    # x[283]
    .word 0xAD84BAE3    # x[284]
    .word 0x3129A23D    # x[285]
    .word 0x3B4D3B5B    # x[286]
    .word 0xB44EBA9E    # x[287]
    .word 0x3A0A356D    # x[288]
    .word 0xBB70BB5D    # x[289]
    .word 0x3BA2B033    # x[290]
    .word 0x3800B9B0    # x[291]
    .word 0xB909BB95    # x[292]
    .word 0xB817AB51    # x[293]
    .word 0xB177B94C    # x[294]
    .word 0xB5A034EB    # x[295]
    .word 0x3BC8209E    # x[296]
    .word 0xB2433683    # x[297]
    .word 0xB16237FD    # x[298]
    .word 0x322E3A00    # x[299]
    .word 0x3A20BA7F    # x[300]
    .word 0x29823784    # x[301]
    .word 0x39A2B934    # x[302]
    .word 0xB4ABA3F2    # x[303]
    .word 0xBBE7B4C7    # x[304]
    .word 0xB8213B0C    # x[305]
    .word 0xBAE23871    # x[306]
    .word 0xBB403BFB    # x[307]
    .word 0xB9AE3B50    # x[308]
    .word 0x3BF1BA91    # x[309]
    .word 0x3418BA68    # x[310]
    .word 0xB890BBCF    # x[311]
    .word 0xB500B607    # x[312]
    .word 0x3991AFC6    # x[313]
    .word 0xB86C3A89    # x[314]
    .word 0xB1C23505    # x[315]
    .word 0xB84435A1    # x[316]
    .word 0x34ABAC29    # x[317]
    .word 0xB62339B9    # x[318]
    .word 0xBB5AB941    # x[319]
    .word 0xB2D1B545    # x[320]
    .word 0x399D35ED    # x[321]
    .word 0xB968B069    # x[322]
    .word 0x3B023498    # x[323]
    .word 0x3A70B240    # x[324]
    .word 0xB94A3A20    # x[325]
    .word 0xB8483452    # x[326]
    .word 0x3807B7B8    # x[327]
    .word 0xAD27B930    # x[328]
    .word 0xB9EC33A8    # x[329]
    .word 0xB1A3BB76    # x[330]
    .word 0x3861B872    # x[331]
    .word 0x3A15B381    # x[332]
    .word 0xB595B87F    # x[333]
    .word 0xB8EBB812    # x[334]
    .word 0x3A602EAF    # x[335]
    .word 0xBBDAB94F    # x[336]
    .word 0xBBDCB3CB    # x[337]
    .word 0xB9C5B959    # x[338]
    .word 0xB75BB934    # x[339]
    .word 0x3BEF3785    # x[340]
    .word 0x3B60AD7B    # x[341]
    .word 0x33853829    # x[342]
    .word 0xB6DFB7C3    # x[343]
    .word 0x372CBB74    # x[344]
    .word 0xB44FB86E    # x[345]
    .word 0x396B323C    # x[346]
    .word 0xB4DD2BE3    # x[347]
    .word 0x9C59378E    # x[348]
    .word 0x3A972F4F    # x[349]
    .word 0x33F33B23    # x[350]
    .word 0xAE13ACC4    # x[351]
    .word 0xBB4DB0F3    # x[352]
    .word 0xBBAEBB79    # x[353]
    .word 0x36952C6E    # x[354]
    .word 0x3A19B5B8    # x[355]
    .word 0xB8F4B606    # x[356]
    .word 0x39A838D6    # x[357]
    .word 0x383F2DED    # x[358]
    .word 0xB7933A07    # x[359]
    .word 0x277EB73C    # x[360]
    .word 0x3A2EBB66    # x[361]
    .word 0xBB253916    # x[362]
    .word 0xB402B86A    # x[363]
    .word 0xABA7B6C7    # x[364]
    .word 0x2F5C3911    # x[365]
    .word 0xB6B5B128    # x[366]
    .word 0xBA5937EC    # x[367]
    .word 0x36BC3836    # x[368]
    .word 0xB809B940    # x[369]
    .word 0x3A20B961    # x[370]
    .word 0x3807B223    # x[371]
    .word 0x367E3814    # x[372]
    .word 0xB86C3915    # x[373]
    .word 0x3AA83888    # x[374]
    .word 0xB1FC3BC5    # x[375]
    .word 0x3A64B9E9    # x[376]
    .word 0x3948B6A8    # x[377]
    .word 0x315FBAD7    # x[378]
    .word 0xA9CEB774    # x[379]
    .word 0xAFEA3AD7    # x[380]
    .word 0xB339B8D8    # x[381]
    .word 0xBA1DB227    # x[382]
    .word 0xB93931C9    # x[383]
    .word 0x36133751    # x[384]
    .word 0xB6DF39B2    # x[385]
    .word 0xB662381B    # x[386]
    .word 0x2BF6B847    # x[387]
    .word 0x3504347A    # x[388]
    .word 0x3A6ABBD8    # x[389]
    .word 0x392AB260    # x[390]
    .word 0xBB5D3903    # x[391]
    .word 0x340F3308    # x[392]
    .word 0x3A8AB797    # x[393]
    .word 0xB77DB9B7    # x[394]
    .word 0xB37BB932    # x[395]
    .word 0x2FDE3BBA    # x[396]
    .word 0xB3AFBB8F    # x[397]
    .word 0xBB05B79A    # x[398]
    .word 0x38F931AD    # x[399]
    .word 0x35A93A7C    # x[400]
    .word 0x38652833    # x[401]
    .word 0xA99F34DB    # x[402]
    .word 0xAFBF347E    # x[403]
    .word 0xB7BA3572    # x[404]
    .word 0x3A93BA3D    # x[405]
    .word 0xAF53B9EB    # x[406]
    .word 0x39CEB754    # x[407]
    .word 0xBA52B835    # x[408]
    .word 0x3863A9BD    # x[409]
    .word 0xB697BABF    # x[410]
    .word 0xBA7536C8    # x[411]
    .word 0xB5103A2C    # x[412]
    .word 0x231AB92B    # x[413]
    .word 0x2C642EA7    # x[414]
    .word 0xAEFCB8F8    # x[415]
    .word 0xBBCA381B    # x[416]
    .word 0xB76EB744    # x[417]
    .word 0xB84BB41F    # x[418]
    .word 0x34B22E97    # x[419]
    .word 0x2E6A9F1E    # x[420]
    .word 0x380DB9D1    # x[421]
    .word 0xAD76AFA1    # x[422]
    .word 0x3307B4BF    # x[423]
    .word 0xA042B4AC    # x[424]
    .word 0xBAFDB290    # x[425]
    .word 0xBA04B256    # x[426]
    .word 0xBA783632    # x[427]
    .word 0x3903B449    # x[428]
    .word 0xBAABB617    # x[429]
    .word 0x30EB38E1    # x[430]
    .word 0xADBE35D3    # x[431]
    .word 0x2FB1BB46    # x[432]
    .word 0xB2B3B4CA    # x[433]
    .word 0x3858B76B    # x[434]
    .word 0x2F673B91    # x[435]
    .word 0xA6C839BC    # x[436]
    .word 0x39D4BB49    # x[437]
    .word 0x3810BAA7    # x[438]
    .word 0x34DF39F0    # x[439]
    .word 0x38093635    # x[440]
    .word 0xB8793BBA    # x[441]
    .word 0xBB3AB621    # x[442]
    .word 0x371F38D3    # x[443]
    .word 0x371EAC28    # x[444]
    .word 0xB8E1B566    # x[445]
    .word 0x39D13993    # x[446]
    .word 0x32C22C8F    # x[447]
    .word 0xB78EB884    # x[448]
    .word 0xB0A42CE8    # x[449]
    .word 0xB3BCB057    # x[450]
    .word 0xBBB0AF7D    # x[451]
    .word 0xB01939B3    # x[452]
    .word 0xB1BA3BC3    # x[453]
    .word 0xB531266D    # x[454]
    .word 0x2F54BB43    # x[455]
    .word 0xAF62B948    # x[456]
    .word 0xB8E0B6F2    # x[457]
    .word 0x3547AA93    # x[458]
    .word 0xBA9C370D    # x[459]
    .word 0xBA1BB9BD    # x[460]
    .word 0x35D7B424    # x[461]
    .word 0xA6EDB8AD    # x[462]
    .word 0x3894B6DB    # x[463]
    .word 0x349F3B89    # x[464]
    .word 0x35A2380C    # x[465]
    .word 0x37B1B707    # x[466]
    .word 0x3452B2C6    # x[467]
    .word 0xB3E3B860    # x[468]
    .word 0xB6C435ED    # x[469]
    .word 0x38083963    # x[470]
    .word 0x39EEB616    # x[471]
    .word 0x35E1349D    # x[472]
    .word 0x3735341E    # x[473]
    .word 0x3089B607    # x[474]
    .word 0x3BD5A39A    # x[475]
    .word 0xB83F3ADC    # x[476]
    .word 0x2D182ED6    # x[477]
    .word 0x38FA3516    # x[478]
    .word 0xB48AB8BA    # x[479]
    .word 0x3992B93D    # x[480]
    .word 0xB45DB947    # x[481]
    .word 0x29D9B870    # x[482]
    .word 0x2CD4B741    # x[483]
    .word 0xAC453BD7    # x[484]
    .word 0x35353B96    # x[485]
    .word 0x350DB483    # x[486]
    .word 0x232933D2    # x[487]
    .word 0x32BC39A5    # x[488]
    .word 0x35CB362A    # x[489]
    .word 0xB626B769    # x[490]
    .word 0xB9D5AD9D    # x[491]
    .word 0xB41438AB    # x[492]
    .word 0xAC16B94E    # x[493]
    .word 0x35BB30CE    # x[494]
    .word 0x3AAFB084    # x[495]
    .word 0xB071BBBA    # x[496]
    .word 0x239CB9BB    # x[497]
    .word 0x3516B87B    # x[498]
    .word 0x37EDBB5B    # x[499]
    .word 0x3AFC3B0E    # x[500]
    .word 0x2E77AFEA    # x[501]
    .word 0xB99F3657    # x[502]
    .word 0x3A4AB2B1    # x[503]
    .word 0xBB61BB6E    # x[504]
    .word 0xBAB93436    # x[505]
    .word 0x3AB8AB89    # x[506]
    .word 0xBA863A23    # x[507]
    .word 0xB3F33A63    # x[508]
    .word 0x37F02C0E    # x[509]
    .word 0xA87038A5    # x[510]
    .word 0x3867B604    # x[511]
    .word 0xB3663648    # x[512]
    .word 0x28573B1D    # x[513]
    .word 0x36C438B2    # x[514]
    .word 0xBA4B392D    # x[515]
    .word 0xBA2DB96E    # x[516]
    .word 0xB28EB528    # x[517]
    .word 0xB93FBAD9    # x[518]
    .word 0x32FE35DD    # x[519]
    .word 0xAA4AA035    # x[520]
    .word 0x37013130    # x[521]
    .word 0xBA453BCB    # x[522]
    .word 0xB8D5362D    # x[523]
    .word 0xB86D3AD6    # x[524]
    .word 0xB9BD3B57    # x[525]
    .word 0x3575BA26    # x[526]
    .word 0xBAF43A77    # x[527]
    .word 0xBADBB4C0    # x[528]
    .word 0xB19F1D46    # x[529]
    .word 0xB138367C    # x[530]
    .word 0x393AB933    # x[531]
    .word 0xB9C0BBE4    # x[532]
    .word 0xBB1F37CE    # x[533]
    .word 0xB48CB0B9    # x[534]
    .word 0x2CE0392D    # x[535]
    .word 0x3ACE3977    # x[536]
    .word 0x37CFB544    # x[537]
    .word 0xADAABAD2    # x[538]
    .word 0x327034CA    # x[539]
    .word 0xBB2B2A91    # x[540]
    .word 0x3A98B30F    # x[541]
    .word 0x309ABAC2    # x[542]
    .word 0xBB622045    # x[543]
    .word 0x2E00B8E5    # x[544]
    .word 0x39B0B932    # x[545]
    .word 0x39E8339A    # x[546]
    .word 0xBA4335AA    # x[547]
    .word 0x39AA3BF6    # x[548]
    .word 0xAB2835DF    # x[549]
    .word 0xB73AB842    # x[550]
    .word 0x3862BBBC    # x[551]
    .word 0xB6F836BE    # x[552]
    .word 0xB45D3489    # x[553]
    .word 0xB544AD00    # x[554]
    .word 0x33AC3934    # x[555]
    .word 0xB9963B73    # x[556]
    .word 0xBB65B600    # x[557]
    .word 0x360CB2A7    # x[558]
    .word 0x34152ACD    # x[559]
    .word 0x38EE379D    # x[560]
    .word 0xB62C3818    # x[561]
    .word 0xB6E93820    # x[562]
    .word 0xB349360A    # x[563]
    .word 0x3905BBCD    # x[564]
    .word 0x3AA63AEE    # x[565]
    .word 0x37463B20    # x[566]
    .word 0xB921B97E    # x[567]
    .word 0x35ACB524    # x[568]
    .word 0xB79FB65D    # x[569]
    .word 0x382ABA07    # x[570]
    .word 0xB30F2CF4    # x[571]
    .word 0xB62BB4CB    # x[572]
    .word 0x39F82B66    # x[573]
    .word 0xBB832B9C    # x[574]
    .word 0x36AB34DC    # x[575]
    .word 0x3A33ACCF    # x[576]
    .word 0xA9D1B9E8    # x[577]
    .word 0xBA5639EA    # x[578]
    .word 0xB598AE9B    # x[579]
    .word 0xB855B35D    # x[580]
    .word 0x3947B4BA    # x[581]
    .word 0xB87BBBFC    # x[582]
    .word 0x365CB402    # x[583]
    .word 0x3A55B351    # x[584]
    .word 0xBB1C38DD    # x[585]
    .word 0xB63B2860    # x[586]
    .word 0x36DD35A6    # x[587]
    .word 0xB76A291D    # x[588]
    .word 0xB808B8E8    # x[589]
    .word 0x33B13B90    # x[590]
    .word 0xBBF0B973    # x[591]
    .word 0xBAC2B7A7    # x[592]
    .word 0x39603B9E    # x[593]
    .word 0x2AF6BBF9    # x[594]
    .word 0xB45FBA5D    # x[595]
    .word 0xB5E03987    # x[596]
    .word 0xB227B6AC    # x[597]
    .word 0x3880B78F    # x[598]
    .word 0x35183A0B    # x[599]
    .word 0xB86B3158    # x[600]
    .word 0xBAF338E6    # x[601]
    .word 0x3BC0399E    # x[602]
    .word 0xB7EDB45E    # x[603]
    .word 0x3AE8B8FF    # x[604]
    .word 0xBBEF346D    # x[605]
    .word 0x3AC4350B    # x[606]
    .word 0x37E93080    # x[607]
    .word 0xB0B8B8FF    # x[608]
    .word 0x327339B6    # x[609]
    .word 0x3A94BAE2    # x[610]
    .word 0x35E1BAEB    # x[611]
    .word 0xA60BB9A4    # x[612]
    .word 0x39C036B7    # x[613]
    .word 0xB4343627    # x[614]
    .word 0xBA41B9FA    # x[615]
    .word 0x3A87B37D    # x[616]
    .word 0x3345B8F0    # x[617]
    .word 0x3540BBD9    # x[618]
    .word 0xB9FCB7E4    # x[619]
    .word 0xBA6E3BBA    # x[620]
    .word 0x9F363964    # x[621]
    .word 0x3AAFBAD6    # x[622]
    .word 0xB812ABA8    # x[623]
    .word 0xB7D6223C    # x[624]
    .word 0xA5403941    # x[625]
    .word 0xBBAC39F2    # x[626]
    .word 0xB639BB22    # x[627]
    .word 0x3AE53B9A    # x[628]
    .word 0x3BDF392E    # x[629]
    .word 0x33183A46    # x[630]
    .word 0x2C5D382D    # x[631]
    .word 0x399E32A5    # x[632]
    .word 0x3924350F    # x[633]
    .word 0x35C2BAC2    # x[634]
    .word 0xBA06B86B    # x[635]
    .word 0x38253B20    # x[636]
    .word 0x3A1F38C5    # x[637]
    .word 0xBBED3611    # x[638]
    .word 0x36BBB1B0    # x[639]
    .word 0xB920AE49    # x[640]
    .word 0xB95A379B    # x[641]
    .word 0xACE4B5AB    # x[642]
    .word 0xBB303617    # x[643]
    .word 0xB39A3439    # x[644]
    .word 0xB931B943    # x[645]
    .word 0xB868B91F    # x[646]
    .word 0xA62434C3    # x[647]
    .word 0x3AB3BB82    # x[648]
    .word 0xBB073670    # x[649]
    .word 0x3097B835    # x[650]
    .word 0x3869B720    # x[651]
    .word 0xB2DAB891    # x[652]
    .word 0xB024B178    # x[653]
    .word 0xB8EDBBE5    # x[654]
    .word 0xB4A62B13    # x[655]
    .word 0xB3753B4C    # x[656]
    .word 0xBAC8B7C8    # x[657]
    .word 0x3825397D    # x[658]
    .word 0xBAC939E9    # x[659]
    .word 0xB4403BC9    # x[660]
    .word 0xBB7E399F    # x[661]
    .word 0x3AE73AFA    # x[662]
    .word 0x3ADEB7C4    # x[663]
    .word 0x2D0337F5    # x[664]
    .word 0x2838B2DB    # x[665]
    .word 0x38C5BB08    # x[666]
    .word 0x2B03ABB7    # x[667]
    .word 0x3A3526DA    # x[668]
    .word 0x3A223A3A    # x[669]
    .word 0x343CB861    # x[670]
    .word 0x35B7B882    # x[671]
    .word 0xB8F93B2A    # x[672]
    .word 0xB4CFB565    # x[673]
    .word 0xAE913260    # x[674]
    .word 0x3B503924    # x[675]
    .word 0xB3B238BF    # x[676]
    .word 0x3AFC3AC5    # x[677]
    .word 0xB614B83E    # x[678]
    .word 0xB588BBAF    # x[679]
    .word 0xB622AE4A    # x[680]
    .word 0x3011AFEF    # x[681]
    .word 0x2A9F339E    # x[682]
    .word 0x3B6539C5    # x[683]
    .word 0x3BDDBB84    # x[684]
    .word 0xB9DF307C    # x[685]
    .word 0xB7293822    # x[686]
    .word 0xAC0F37E6    # x[687]
    .word 0x33A3B5EE    # x[688]
    .word 0xBB70AA1F    # x[689]
    .word 0x3B74348D    # x[690]
    .word 0x9EA2A45B    # x[691]
    .word 0x35D5349B    # x[692]
    .word 0x352DB92C    # x[693]
    .word 0x2D1F3A5E    # x[694]
    .word 0xB83DAD70    # x[695]
    .word 0xAFDF3BA5    # x[696]
    .word 0x37E9B5B6    # x[697]
    .word 0xB863B64F    # x[698]
    .word 0x39D9BA88    # x[699]
    .word 0x30C03A55    # x[700]
    .word 0xBBEFB7ED    # x[701]
    .word 0x394BBAB7    # x[702]
    .word 0x35ACB573    # x[703]
    .word 0x304F3B06    # x[704]
    .word 0x3A99BAB9    # x[705]
    .word 0xBB01B996    # x[706]
    .word 0x31E33A8A    # x[707]
    .word 0x3B23B8F2    # x[708]
    .word 0x34E2AC0E    # x[709]
    .word 0x340B2C6A    # x[710]
    .word 0xBBB8B439    # x[711]
    .word 0x342F2C69    # x[712]
    .word 0xB9F0B0B4    # x[713]
    .word 0x3BD9B984    # x[714]
    .word 0xBAE3BB78    # x[715]
    .word 0xB8D92C8B    # x[716]
    .word 0x3939B89E    # x[717]
    .word 0x31D2B0E4    # x[718]
    .word 0xB14DB87B    # x[719]
    .word 0xB87C3917    # x[720]
    .word 0xB847B294    # x[721]
    .word 0x325ABBDA    # x[722]
    .word 0x30982956    # x[723]
    .word 0xBA682AFB    # x[724]
    .word 0x39BBB00F    # x[725]
    .word 0x353737E8    # x[726]
    .word 0x3A6EB5A3    # x[727]
    .word 0x2DF2BBF6    # x[728]
    .word 0x32C639A6    # x[729]
    .word 0x373E386C    # x[730]
    .word 0xB96E3B19    # x[731]
    .word 0xBA70AB2C    # x[732]
    .word 0xB672396E    # x[733]
    .word 0x333EAC7E    # x[734]
    .word 0xA1993B8B    # x[735]
    .word 0x3BA2BBA3    # x[736]
    .word 0x3137349E    # x[737]
    .word 0x1D06380C    # x[738]
    .word 0x3B4DB60B    # x[739]
    .word 0x3BFB2BD9    # x[740]
    .word 0xB70AB966    # x[741]
    .word 0xB643A9F9    # x[742]
    .word 0xB423B253    # x[743]
    .word 0xB877ACF7    # x[744]
    .word 0xB84EB0B5    # x[745]
    .word 0x309FBA9A    # x[746]
    .word 0xBB7FB607    # x[747]
    .word 0x34413A53    # x[748]
    .word 0xB8D09DC6    # x[749]
    .word 0xB48A3ADB    # x[750]
    .word 0x34CBB872    # x[751]
    .word 0x385AB79E    # x[752]
    .word 0xA9C4BBB1    # x[753]
    .word 0x3833B567    # x[754]
    .word 0xB09FB638    # x[755]
    .word 0x332ABB40    # x[756]
    .word 0xBA673A40    # x[757]
    .word 0xB896A664    # x[758]
    .word 0x3A4DBBC9    # x[759]
    .word 0x2EE7B878    # x[760]
    .word 0x3403A64F    # x[761]
    .word 0xBB173AF3    # x[762]
    .word 0xBBC9AE70    # x[763]
    .word 0xB98A3A8F    # x[764]
    .word 0x361AB9C6    # x[765]
    .word 0xAD61B928    # x[766]
    .word 0xB8D7B539    # x[767]
    .word 0x35B93BB5    # x[768]
    .word 0xB25DB878    # x[769]
    .word 0xBA6932AB    # x[770]
    .word 0xBA9FB789    # x[771]
    .word 0xAEA33B09    # x[772]
    .word 0x3B36319D    # x[773]
    .word 0xBA26B7F2    # x[774]
    .word 0x157739CB    # x[775]
    .word 0x3934B7EF    # x[776]
    .word 0xB60FB8C4    # x[777]
    .word 0x887CB602    # x[778]
    .word 0x38E13849    # x[779]
    .word 0xB122B84A    # x[780]
    .word 0x33BDB471    # x[781]
    .word 0x34003A7D    # x[782]
    .word 0x37E7A4FF    # x[783]
    .word 0x3AD93BCA    # x[784]
    .word 0x38723833    # x[785]
    .word 0x321536E9    # x[786]
    .word 0xB9143A77    # x[787]
    .word 0xB49BB59C    # x[788]
    .word 0xB988BB0B    # x[789]
    .word 0xB9F8B9D0    # x[790]
    .word 0xBBFD3724    # x[791]
    .word 0xB88C3AEF    # x[792]
    .word 0xBBAFB29A    # x[793]
    .word 0xBA82AD99    # x[794]
    .word 0x332A3BFE    # x[795]
    .word 0xBBE3397C    # x[796]
    .word 0x299E31D7    # x[797]
    .word 0xB824B752    # x[798]
    .word 0x37DBBABD    # x[799]
    .word 0xB41A3379    # x[800]
    .word 0x3B513251    # x[801]
    .word 0xB9323915    # x[802]
    .word 0xBB07BB66    # x[803]
    .word 0x347F3A83    # x[804]
    .word 0x35E5B560    # x[805]
    .word 0xB835BAAF    # x[806]
    .word 0xBBF2AD3D    # x[807]
    .word 0xB8BBB34B    # x[808]
    .word 0xB9FCBB2D    # x[809]
    .word 0xB482369B    # x[810]
    .word 0x3B53B754    # x[811]
    .word 0xB8383748    # x[812]
    .word 0xBA72B82B    # x[813]
    .word 0x398BBADB    # x[814]
    .word 0x29A3B8BA    # x[815]
    .word 0xB67FB9BB    # x[816]
    .word 0xB4B89051    # x[817]
    .word 0xB4BF3104    # x[818]
    .word 0xB9EAB9C1    # x[819]
    .word 0xB9E13800    # x[820]
    .word 0xBBFB3BF0    # x[821]
    .word 0x32CF3AA0    # x[822]
    .word 0x3913B2F5    # x[823]
    .word 0xB4E436C1    # x[824]
    .word 0x38D4B48F    # x[825]
    .word 0x3976B9E1    # x[826]
    .word 0xBA1EB47B    # x[827]
    .word 0x2DE1307E    # x[828]
    .word 0xBAAD35A1    # x[829]
    .word 0xB5F1B769    # x[830]
    .word 0x38DDAA6C    # x[831]
    .word 0x2ABD31F0    # x[832]
    .word 0x353AB19A    # x[833]
    .word 0xB4EA3773    # x[834]
    .word 0xB40DBB8B    # x[835]
    .word 0x3BA736DD    # x[836]
    .word 0x39B2B314    # x[837]
    .word 0x3B6CBB8B    # x[838]
    .word 0x3AF73846    # x[839]
    .word 0x30EBB55B    # x[840]
    .word 0x3A07B841    # x[841]
    .word 0x35182DDB    # x[842]
    .word 0x34433AC9    # x[843]
    .word 0x36E03250    # x[844]
    .word 0x395BB427    # x[845]
    .word 0xB8C1B9C0    # x[846]
    .word 0x327E3AF0    # x[847]
    .word 0xB1BAB62F    # x[848]
    .word 0x3AD4BA6B    # x[849]
    .word 0x3988B66A    # x[850]
    .word 0x3574B301    # x[851]
    .word 0x3A1B30A4    # x[852]
    .word 0xBA35B183    # x[853]
    .word 0x3B99B9AA    # x[854]
    .word 0xB0443960    # x[855]
    .word 0xA55130A7    # x[856]
    .word 0xB65336FF    # x[857]
    .word 0xB14ABA52    # x[858]
    .word 0xB9C5BB04    # x[859]
    .word 0x3546BB8F    # x[860]
    .word 0x2D3BB7A8    # x[861]
    .word 0xBA43B8CC    # x[862]
    .word 0x39C93344    # x[863]
    .word 0xBBB231E7    # x[864]
    .word 0x2B33B9CB    # x[865]
    .word 0xB335A910    # x[866]
    .word 0xB6CBB52B    # x[867]
    .word 0x3AD9BADB    # x[868]
    .word 0x39B3B9B7    # x[869]
    .word 0xBA6935F7    # x[870]
    .word 0x350FB41A    # x[871]
    .word 0x373639C1    # x[872]
    .word 0x3AEE95CC    # x[873]
    .word 0x3410B44F    # x[874]
    .word 0xB9302703    # x[875]
    .word 0x34B035D9    # x[876]
    .word 0x3BE62426    # x[877]
    .word 0xBB77B255    # x[878]
    .word 0x3916345C    # x[879]
    .word 0x3A3DB5A4    # x[880]
    .word 0x3618AB25    # x[881]
    .word 0xB0F73731    # x[882]
    .word 0x32713BA8    # x[883]
    .word 0x37492E66    # x[884]
    .word 0xB52B394C    # x[885]
    .word 0x25D1B1EE    # x[886]
    .word 0x2C8F388A    # x[887]
    .word 0xB921BA1B    # x[888]
    .word 0x3710BAB1    # x[889]
    .word 0x3AE9B92F    # x[890]
    .word 0xB281B8B4    # x[891]
    .word 0x3908B6A2    # x[892]
    .word 0x3B2BAF96    # x[893]
    .word 0xB18BB47E    # x[894]
    .word 0x39AD3848    # x[895]
    .word 0x354DB9F2    # x[896]
    .word 0x38FCB849    # x[897]
    .word 0x3AF738BA    # x[898]
    .word 0x335D31A3    # x[899]
    .word 0x38E4BBB6    # x[900]
    .word 0xAC533258    # x[901]
    .word 0xB935BAE3    # x[902]
    .word 0x3B8D346E    # x[903]
    .word 0xBBA5385E    # x[904]
    .word 0x3BA4B7EF    # x[905]
    .word 0x3096396B    # x[906]
    .word 0x350B3938    # x[907]
    .word 0x301AA8E6    # x[908]
    .word 0x3AE9BA24    # x[909]
    .word 0xB94F3ADC    # x[910]
    .word 0x2F2FA8A2    # x[911]
    .word 0xB9A0B605    # x[912]
    .word 0xACB6A9E2    # x[913]
    .word 0xBAEF3578    # x[914]
    .word 0xB089AFCB    # x[915]
    .word 0x3B32BBC7    # x[916]
    .word 0xB6CDB981    # x[917]
    .word 0x3A70B736    # x[918]
    .word 0xB1D0B4E9    # x[919]
    .word 0xB3E8389D    # x[920]
    .word 0x3786B273    # x[921]
    .word 0xB94D39D9    # x[922]
    .word 0xBAA33BC2    # x[923]
    .word 0x383D3AA2    # x[924]
    .word 0xAA372DDC    # x[925]
    .word 0x344036A6    # x[926]
    .word 0x3708B7C2    # x[927]
    .word 0xB974369F    # x[928]
    .word 0x26A7BA74    # x[929]
    .word 0xB536BB45    # x[930]
    .word 0x2C03BAF5    # x[931]
    .word 0x2ED1396C    # x[932]
    .word 0xAF0F3896    # x[933]
    .word 0xB604B196    # x[934]
    .word 0xB7AFB5CF    # x[935]
    .word 0xB14CB6A4    # x[936]
    .word 0xB71BB5C4    # x[937]
    .word 0xB4B23493    # x[938]
    .word 0x25F8BB55    # x[939]
    .word 0x3A853996    # x[940]
    .word 0x3A2FB8EC    # x[941]
    .word 0xB0FF3116    # x[942]
    .word 0xB96EB75F    # x[943]
    .word 0xADD6B300    # x[944]
    .word 0xBB1AB4F3    # x[945]
    .word 0x381D37C7    # x[946]
    .word 0x3B91B96A    # x[947]
    .word 0x39E9B816    # x[948]
    .word 0x39ABB0F8    # x[949]
    .word 0xB9E638EF    # x[950]
    .word 0xB9749491    # x[951]
    .word 0x37BABA97    # x[952]
    .word 0x38C13843    # x[953]
    .word 0xB04D38EA    # x[954]
    .word 0x3B52BB82    # x[955]
    .word 0xB8112E45    # x[956]
    .word 0x3B603BAD    # x[957]
    .word 0xB807B958    # x[958]
    .word 0xBA081F18    # x[959]
    .word 0xB44C385F    # x[960]
    .word 0x3BBC3BE6    # x[961]
    .word 0xB86739B3    # x[962]
    .word 0xB9273AB6    # x[963]
    .word 0xB91E3945    # x[964]
    .word 0xBA0D376F    # x[965]
    .word 0x36252C11    # x[966]
    .word 0xB15DB055    # x[967]
    .word 0xABEDB1AF    # x[968]
    .word 0xB8713153    # x[969]
    .word 0xB219A922    # x[970]
    .word 0xA477B7E8    # x[971]
    .word 0x37262440    # x[972]
    .word 0xB7E83932    # x[973]
    .word 0x3306BBEB    # x[974]
    .word 0x3B2DB57D    # x[975]
    .word 0xB554B923    # x[976]
    .word 0xA917B123    # x[977]
    .word 0xB044B9E8    # x[978]
    .word 0xB7183164    # x[979]
    .word 0x3690B21B    # x[980]
    .word 0x35A8326C    # x[981]
    .word 0xA759322B    # x[982]
    .word 0x3B26B850    # x[983]
    .word 0xBB40B73A    # x[984]
    .word 0xB80D371A    # x[985]
    .word 0x391D368F    # x[986]
    .word 0x39C43B3C    # x[987]
    .word 0x2C543B24    # x[988]
    .word 0xB54B3116    # x[989]
    .word 0xB5F13BAB    # x[990]
    .word 0xB4CBAB1F    # x[991]
    .word 0xB60A1FFC    # x[992]
    .word 0x3ACAB2E2    # x[993]
    .word 0x393E3861    # x[994]
    .word 0xB63636A6    # x[995]
    .word 0x34343BCE    # x[996]
    .word 0x36BB2EC8    # x[997]
    .word 0xB908B834    # x[998]
    .word 0x3AD5B07E    # x[999]
    .word 0xADCCB77E    # x[1000]
    .word 0xB9513A92    # x[1001]
    .word 0x3822B9F4    # x[1002]
    .word 0xAF5F3910    # x[1003]
    .word 0xBA29353E    # x[1004]
    .word 0x32CFB865    # x[1005]
    .word 0x35D8B5CE    # x[1006]
    .word 0xB606B92C    # x[1007]
    .word 0x31EDB804    # x[1008]
    .word 0xB735B5B6    # x[1009]
    .word 0xBBC63B92    # x[1010]
    .word 0xB62038C8    # x[1011]
    .word 0x2A483BA5    # x[1012]
    .word 0x3A9239DC    # x[1013]
    .word 0x391FB613    # x[1014]
    .word 0xBB85A5D2    # x[1015]
    .word 0xB26DB766    # x[1016]
    .word 0xB4F3B635    # x[1017]
    .word 0xB7F9BBEB    # x[1018]
    .word 0x2F80A005    # x[1019]
    .word 0xBACCB8AB    # x[1020]
    .word 0x3A1039CD    # x[1021]
    .word 0xBB7DB047    # x[1022]
    .word 0x3AA83953    # x[1023]

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
