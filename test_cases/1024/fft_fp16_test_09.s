# Packed-fp16 radix-2 DIT FFT, N = 1024
# Each 64-bit register = 4 fp16 lanes [a,b,c,d] = (re0, im0, re1, im1) -> 2 complex samples.
#   vadd.h / vsub.h : lane-wise on 4 x fp16
#   vcmpl.h rd,rs1,rs2 : rd = (a*e-b*f, a*f+b*e, c*g-d*h, c*h+d*g)
#   vld / vsd : 64-bit load / store
# One complex sample = one 32-bit word: (imag_fp16 << 16) | real_fp16.
# Output overwrites x[] in place.

.data
x:
    .word 0xA678B91E    # x[0]
    .word 0x29C7BAC2    # x[1]
    .word 0x3A053AB7    # x[2]
    .word 0x390E1E15    # x[3]
    .word 0xB89338E5    # x[4]
    .word 0xB8BFBA97    # x[5]
    .word 0x358F315C    # x[6]
    .word 0x37E3B96D    # x[7]
    .word 0xACA23086    # x[8]
    .word 0xB9DA257B    # x[9]
    .word 0x3B88321E    # x[10]
    .word 0x3621B9CB    # x[11]
    .word 0x386FAD7D    # x[12]
    .word 0x3899B08D    # x[13]
    .word 0xB667ADF1    # x[14]
    .word 0xB184B76E    # x[15]
    .word 0xB5273A54    # x[16]
    .word 0xB77AAF2E    # x[17]
    .word 0x397AB8F1    # x[18]
    .word 0x2DDBB9EE    # x[19]
    .word 0xB5F9360C    # x[20]
    .word 0x37ED3880    # x[21]
    .word 0xBBD63638    # x[22]
    .word 0x39633821    # x[23]
    .word 0xB0CD3A58    # x[24]
    .word 0xB8F9B67D    # x[25]
    .word 0x39A2372E    # x[26]
    .word 0x2A65BA5F    # x[27]
    .word 0xB9B8B431    # x[28]
    .word 0x2D863A96    # x[29]
    .word 0x3910B118    # x[30]
    .word 0x382739BE    # x[31]
    .word 0xB9C23A2A    # x[32]
    .word 0xB22F36E4    # x[33]
    .word 0x3313B59D    # x[34]
    .word 0xB8653B19    # x[35]
    .word 0xB5C1B85A    # x[36]
    .word 0xBAF53B28    # x[37]
    .word 0xBB082C13    # x[38]
    .word 0xBB1EBB17    # x[39]
    .word 0xADDEBAB7    # x[40]
    .word 0x3B642D19    # x[41]
    .word 0xA1D2AF1F    # x[42]
    .word 0xBB66B65D    # x[43]
    .word 0x3628B599    # x[44]
    .word 0xBB4839A3    # x[45]
    .word 0x35243AC6    # x[46]
    .word 0x347CB8A6    # x[47]
    .word 0xBB692534    # x[48]
    .word 0xB57E3949    # x[49]
    .word 0x394839F0    # x[50]
    .word 0xBB58A9D7    # x[51]
    .word 0xBBDCB84D    # x[52]
    .word 0xB9EA37C9    # x[53]
    .word 0x3AE03878    # x[54]
    .word 0xBA883A7D    # x[55]
    .word 0xB84AB879    # x[56]
    .word 0xBB713521    # x[57]
    .word 0xB391BA8F    # x[58]
    .word 0x323A389B    # x[59]
    .word 0xAEAFB9C6    # x[60]
    .word 0xBBC82F63    # x[61]
    .word 0xB562B481    # x[62]
    .word 0x38D73426    # x[63]
    .word 0xB703BA29    # x[64]
    .word 0x3958362A    # x[65]
    .word 0xB6E7257F    # x[66]
    .word 0xB931BB69    # x[67]
    .word 0x9D28B6FF    # x[68]
    .word 0xB0FEBB45    # x[69]
    .word 0xB4A6B649    # x[70]
    .word 0x3A0336FE    # x[71]
    .word 0x35222C06    # x[72]
    .word 0xA9CDBBCA    # x[73]
    .word 0xBB4BB700    # x[74]
    .word 0xB0F03A72    # x[75]
    .word 0xBAC9B42E    # x[76]
    .word 0xB5A0B815    # x[77]
    .word 0x315D354E    # x[78]
    .word 0xB78331F2    # x[79]
    .word 0x38CE3953    # x[80]
    .word 0xBA27B6B5    # x[81]
    .word 0xB98136FC    # x[82]
    .word 0xB9B0385F    # x[83]
    .word 0xAA012E04    # x[84]
    .word 0xBBEA38C5    # x[85]
    .word 0xB847350F    # x[86]
    .word 0xB5E5B898    # x[87]
    .word 0xB9F2ACC4    # x[88]
    .word 0xB2A039DE    # x[89]
    .word 0xB378B89F    # x[90]
    .word 0xBB2835F6    # x[91]
    .word 0xB69AB6D4    # x[92]
    .word 0x2DE73B36    # x[93]
    .word 0x3ADCAF43    # x[94]
    .word 0xB439BA3B    # x[95]
    .word 0x2E503839    # x[96]
    .word 0x3B73376B    # x[97]
    .word 0x394AB995    # x[98]
    .word 0x32E73710    # x[99]
    .word 0x3906BAB8    # x[100]
    .word 0xB4D53923    # x[101]
    .word 0xACA83837    # x[102]
    .word 0x31EB3969    # x[103]
    .word 0x3B2DB9FA    # x[104]
    .word 0x3816B053    # x[105]
    .word 0x38D1B0FB    # x[106]
    .word 0x2EEC321C    # x[107]
    .word 0x379A35AE    # x[108]
    .word 0xB6213B31    # x[109]
    .word 0xB8A1B9C4    # x[110]
    .word 0xBB41383B    # x[111]
    .word 0x3AD6AD94    # x[112]
    .word 0xB6B7B63C    # x[113]
    .word 0x3B90BAB8    # x[114]
    .word 0x2C69B489    # x[115]
    .word 0xB7D4BBD4    # x[116]
    .word 0xAB24BA77    # x[117]
    .word 0x39603733    # x[118]
    .word 0xAE65B4F9    # x[119]
    .word 0xBB7FB83B    # x[120]
    .word 0x34713979    # x[121]
    .word 0xB9D5B3C3    # x[122]
    .word 0xB6BBAEE6    # x[123]
    .word 0x2F04B93A    # x[124]
    .word 0xAB1D2C72    # x[125]
    .word 0x3846B785    # x[126]
    .word 0x37013B18    # x[127]
    .word 0x3773B19B    # x[128]
    .word 0x39AC344B    # x[129]
    .word 0xB74CA80F    # x[130]
    .word 0x35CBB5A7    # x[131]
    .word 0xB65EBAD9    # x[132]
    .word 0xA94F3AB2    # x[133]
    .word 0xB278321A    # x[134]
    .word 0x285E375A    # x[135]
    .word 0xB9853B63    # x[136]
    .word 0x38F6ACD8    # x[137]
    .word 0xB201B55A    # x[138]
    .word 0x2CA93B04    # x[139]
    .word 0xBB6EB56F    # x[140]
    .word 0x2753B879    # x[141]
    .word 0xB8823ADE    # x[142]
    .word 0x237C3370    # x[143]
    .word 0xB82F3B3B    # x[144]
    .word 0xBADF3376    # x[145]
    .word 0x395EB264    # x[146]
    .word 0x3B7F3623    # x[147]
    .word 0xB96D38C9    # x[148]
    .word 0xB69DB6C6    # x[149]
    .word 0xACE2B508    # x[150]
    .word 0xB042AED1    # x[151]
    .word 0xAF2B38BC    # x[152]
    .word 0xB946B925    # x[153]
    .word 0x3977B831    # x[154]
    .word 0xB617BB64    # x[155]
    .word 0x3137B507    # x[156]
    .word 0x342F3B4C    # x[157]
    .word 0x392FB8C9    # x[158]
    .word 0x38EE38A7    # x[159]
    .word 0x38E13852    # x[160]
    .word 0xB68B3A58    # x[161]
    .word 0x35A231A0    # x[162]
    .word 0xBBB6B1E1    # x[163]
    .word 0x36A1BB5E    # x[164]
    .word 0x36093A1E    # x[165]
    .word 0x3A673764    # x[166]
    .word 0xB64A3980    # x[167]
    .word 0x3B0C3BAB    # x[168]
    .word 0xB45332CB    # x[169]
    .word 0xB23F357B    # x[170]
    .word 0x369BBABE    # x[171]
    .word 0xAB2C38AA    # x[172]
    .word 0xB89E3B76    # x[173]
    .word 0xB437B3EE    # x[174]
    .word 0xAF9F297C    # x[175]
    .word 0x38E9B9CF    # x[176]
    .word 0x30C3B8B9    # x[177]
    .word 0xAD15B252    # x[178]
    .word 0x387037A2    # x[179]
    .word 0x3BE43813    # x[180]
    .word 0x378CB981    # x[181]
    .word 0xAE1B37BA    # x[182]
    .word 0xBA6A33F7    # x[183]
    .word 0xB8893968    # x[184]
    .word 0xBB72B829    # x[185]
    .word 0xB5E633BD    # x[186]
    .word 0xBB25B823    # x[187]
    .word 0xB88EB7CE    # x[188]
    .word 0x2A45B951    # x[189]
    .word 0xBABB2DA1    # x[190]
    .word 0x39C6BBDC    # x[191]
    .word 0xB9E2BB0C    # x[192]
    .word 0xB3D53952    # x[193]
    .word 0x3B05B9AE    # x[194]
    .word 0xB8843B9D    # x[195]
    .word 0xB6B2B453    # x[196]
    .word 0xBBB23283    # x[197]
    .word 0xB9C63998    # x[198]
    .word 0xB71C39B6    # x[199]
    .word 0xB6DFAE91    # x[200]
    .word 0x373838A8    # x[201]
    .word 0x375F371D    # x[202]
    .word 0x3137B831    # x[203]
    .word 0x38452ED8    # x[204]
    .word 0x351D384D    # x[205]
    .word 0xB877B8AC    # x[206]
    .word 0xB960BB47    # x[207]
    .word 0x31F83A78    # x[208]
    .word 0x3A9AB8F9    # x[209]
    .word 0xB6303663    # x[210]
    .word 0xA5CEBB93    # x[211]
    .word 0x39AFB9A3    # x[212]
    .word 0x3BD2B6CD    # x[213]
    .word 0xB5453436    # x[214]
    .word 0x387AB5BC    # x[215]
    .word 0x3BB624BF    # x[216]
    .word 0xB7F8B440    # x[217]
    .word 0x34BDB97C    # x[218]
    .word 0xB27BB0BB    # x[219]
    .word 0x3B533820    # x[220]
    .word 0xA6D6BBFA    # x[221]
    .word 0x36A2BBF9    # x[222]
    .word 0x381EB7D5    # x[223]
    .word 0x3B6E37D5    # x[224]
    .word 0x290733E1    # x[225]
    .word 0xB95520B2    # x[226]
    .word 0x382AB5BA    # x[227]
    .word 0xB5F5BBCC    # x[228]
    .word 0xB52EB8BA    # x[229]
    .word 0x32AF38CC    # x[230]
    .word 0xBB723BFD    # x[231]
    .word 0x3795AF5B    # x[232]
    .word 0xBB06BB81    # x[233]
    .word 0x38703B47    # x[234]
    .word 0xB33B37A2    # x[235]
    .word 0xBACEB8A7    # x[236]
    .word 0xB934B271    # x[237]
    .word 0xB629B102    # x[238]
    .word 0xBBF73A3E    # x[239]
    .word 0x34713A83    # x[240]
    .word 0x3A7BB94F    # x[241]
    .word 0x3A53BB63    # x[242]
    .word 0x36F03755    # x[243]
    .word 0xB35D2A25    # x[244]
    .word 0x30F9ADB1    # x[245]
    .word 0x3413B74C    # x[246]
    .word 0x320F385A    # x[247]
    .word 0x39073429    # x[248]
    .word 0x2D5DAF64    # x[249]
    .word 0x3A36B84A    # x[250]
    .word 0xBA49B87E    # x[251]
    .word 0x38DA399F    # x[252]
    .word 0x3B463B9C    # x[253]
    .word 0x3A21BB3A    # x[254]
    .word 0x3AB5ACBD    # x[255]
    .word 0x33A83B4C    # x[256]
    .word 0xA58B397C    # x[257]
    .word 0x35BF3403    # x[258]
    .word 0x3ABFB99E    # x[259]
    .word 0xB8B8B540    # x[260]
    .word 0x340034EE    # x[261]
    .word 0xB83EB9FF    # x[262]
    .word 0xAFF9BBBA    # x[263]
    .word 0x2D2636B7    # x[264]
    .word 0xB516B94C    # x[265]
    .word 0xB914BAC8    # x[266]
    .word 0xB46729B0    # x[267]
    .word 0xB6A9B651    # x[268]
    .word 0xB7EC3A50    # x[269]
    .word 0x3973B9BA    # x[270]
    .word 0x32A7BB5B    # x[271]
    .word 0xB4E3BA26    # x[272]
    .word 0x28993889    # x[273]
    .word 0xB53C33D3    # x[274]
    .word 0x3529B9E8    # x[275]
    .word 0x3239B73C    # x[276]
    .word 0xBAA334F5    # x[277]
    .word 0x31853699    # x[278]
    .word 0xB16236C4    # x[279]
    .word 0x3A82BAD4    # x[280]
    .word 0x2E2D3536    # x[281]
    .word 0x26E0BABD    # x[282]
    .word 0xBAD8BB2F    # x[283]
    .word 0x3995BAA8    # x[284]
    .word 0x3B5A39A7    # x[285]
    .word 0x39C23609    # x[286]
    .word 0x34953326    # x[287]
    .word 0xBBAB321A    # x[288]
    .word 0xB35137FE    # x[289]
    .word 0xB2893B9A    # x[290]
    .word 0x31543936    # x[291]
    .word 0x349838B3    # x[292]
    .word 0xB352B50F    # x[293]
    .word 0x39D93A63    # x[294]
    .word 0x392C3A27    # x[295]
    .word 0xB8763165    # x[296]
    .word 0x377F39DF    # x[297]
    .word 0x37FB353F    # x[298]
    .word 0x33A4BB50    # x[299]
    .word 0x3BDDB58A    # x[300]
    .word 0x25C0AEBA    # x[301]
    .word 0xB663BBBC    # x[302]
    .word 0x33E03B3C    # x[303]
    .word 0xB95A2B99    # x[304]
    .word 0x38FD35B5    # x[305]
    .word 0xADD5B7C9    # x[306]
    .word 0xBB203B45    # x[307]
    .word 0x38A01D7F    # x[308]
    .word 0xAFE7B2CA    # x[309]
    .word 0x387B3945    # x[310]
    .word 0xB3C0266E    # x[311]
    .word 0xB3AEB848    # x[312]
    .word 0xAFED3921    # x[313]
    .word 0x30FA366D    # x[314]
    .word 0x3A3CB960    # x[315]
    .word 0xB4E5B74D    # x[316]
    .word 0xB5BFBB16    # x[317]
    .word 0x36A0B84D    # x[318]
    .word 0x3A16B9B1    # x[319]
    .word 0xB3CC3A21    # x[320]
    .word 0xAE163319    # x[321]
    .word 0xB705B389    # x[322]
    .word 0x31832C72    # x[323]
    .word 0x37D5B83F    # x[324]
    .word 0x2E70B88D    # x[325]
    .word 0xB490B405    # x[326]
    .word 0x39B2315C    # x[327]
    .word 0xBA483A92    # x[328]
    .word 0xA6D03125    # x[329]
    .word 0xB643AED8    # x[330]
    .word 0xBA5CB8AA    # x[331]
    .word 0x33EF3A9B    # x[332]
    .word 0x2DA63A90    # x[333]
    .word 0xB63F38FD    # x[334]
    .word 0x3B85AEEE    # x[335]
    .word 0xB3C4BBE8    # x[336]
    .word 0x3431B9F4    # x[337]
    .word 0xBBED3B55    # x[338]
    .word 0x381B386E    # x[339]
    .word 0xAB9D3B1B    # x[340]
    .word 0x37F031CA    # x[341]
    .word 0x39FBBA59    # x[342]
    .word 0x2F003A90    # x[343]
    .word 0xBB603B99    # x[344]
    .word 0xB605B90B    # x[345]
    .word 0x3404B5CD    # x[346]
    .word 0xB932AB55    # x[347]
    .word 0xB854B43F    # x[348]
    .word 0xBB74BA06    # x[349]
    .word 0x33B83789    # x[350]
    .word 0xBAFD3489    # x[351]
    .word 0x3A0E33F3    # x[352]
    .word 0x38643B28    # x[353]
    .word 0x2C47B9B5    # x[354]
    .word 0x3559382A    # x[355]
    .word 0x3847B98A    # x[356]
    .word 0x31E53B1E    # x[357]
    .word 0x340AAA3C    # x[358]
    .word 0xB9DAB617    # x[359]
    .word 0xB58DBA09    # x[360]
    .word 0x37F49D6A    # x[361]
    .word 0x3BBD2DA2    # x[362]
    .word 0x3B8D3866    # x[363]
    .word 0x354D32CD    # x[364]
    .word 0xAF553981    # x[365]
    .word 0xB7823B9C    # x[366]
    .word 0xBAE73B15    # x[367]
    .word 0xB426AECF    # x[368]
    .word 0x34323A15    # x[369]
    .word 0x32BCB9C0    # x[370]
    .word 0x2CCBB8C7    # x[371]
    .word 0x352B3A28    # x[372]
    .word 0x34BA39D5    # x[373]
    .word 0xB9172CA7    # x[374]
    .word 0xBA7C39F3    # x[375]
    .word 0x3BCFB4F9    # x[376]
    .word 0xBB469841    # x[377]
    .word 0x2A5836C7    # x[378]
    .word 0x3BFFAFA3    # x[379]
    .word 0xB10EBA18    # x[380]
    .word 0xB9CF3990    # x[381]
    .word 0x36A3331C    # x[382]
    .word 0x37BFB3D9    # x[383]
    .word 0x33BD3776    # x[384]
    .word 0x37D8B89D    # x[385]
    .word 0xB88DBB50    # x[386]
    .word 0x33EB38FB    # x[387]
    .word 0xA17639CF    # x[388]
    .word 0xB9FC3964    # x[389]
    .word 0x3144398E    # x[390]
    .word 0x374BAF8E    # x[391]
    .word 0x39023371    # x[392]
    .word 0xB859B5AB    # x[393]
    .word 0x2CC0BBA5    # x[394]
    .word 0xB7AB23C6    # x[395]
    .word 0x38D8B8EE    # x[396]
    .word 0x38F93991    # x[397]
    .word 0x396F3059    # x[398]
    .word 0x37CEA71B    # x[399]
    .word 0x39DA356B    # x[400]
    .word 0xB8B0B378    # x[401]
    .word 0x9A93BBF1    # x[402]
    .word 0xB55DB330    # x[403]
    .word 0xA9773AF3    # x[404]
    .word 0xB11ABAE4    # x[405]
    .word 0xB52838FC    # x[406]
    .word 0x24FE3467    # x[407]
    .word 0x3A22BBC6    # x[408]
    .word 0x94B7B0A2    # x[409]
    .word 0xBAE338C5    # x[410]
    .word 0x3A893489    # x[411]
    .word 0xB846B90A    # x[412]
    .word 0xB8ACB9CD    # x[413]
    .word 0x38F9399D    # x[414]
    .word 0x34B0BBEE    # x[415]
    .word 0x29EEB905    # x[416]
    .word 0x368E3538    # x[417]
    .word 0xBAC6B8AF    # x[418]
    .word 0xB8D0AD84    # x[419]
    .word 0xB2323083    # x[420]
    .word 0x38E5B07E    # x[421]
    .word 0x3A21349E    # x[422]
    .word 0xB5F7BA1A    # x[423]
    .word 0xAF65AA02    # x[424]
    .word 0x3BEA3049    # x[425]
    .word 0x388EBB87    # x[426]
    .word 0xBA3837CF    # x[427]
    .word 0xB1A8B992    # x[428]
    .word 0x391E39ED    # x[429]
    .word 0xB19C352A    # x[430]
    .word 0x395038B9    # x[431]
    .word 0xAEB03738    # x[432]
    .word 0x242A3918    # x[433]
    .word 0xAC4CB869    # x[434]
    .word 0xB37EB7D1    # x[435]
    .word 0x256CB185    # x[436]
    .word 0x2DF8B93B    # x[437]
    .word 0xBA01BAE0    # x[438]
    .word 0xBA19B803    # x[439]
    .word 0x3A032C85    # x[440]
    .word 0x38FCB7C4    # x[441]
    .word 0x3B4F3888    # x[442]
    .word 0xB642BA35    # x[443]
    .word 0x3A503ACE    # x[444]
    .word 0x3B813903    # x[445]
    .word 0x3006BAAC    # x[446]
    .word 0xAF6A33C4    # x[447]
    .word 0xB8A4B16A    # x[448]
    .word 0x30ACB961    # x[449]
    .word 0xB8A3B945    # x[450]
    .word 0xB7D23641    # x[451]
    .word 0xBADDBB10    # x[452]
    .word 0xB7DEB916    # x[453]
    .word 0xB52FBA5C    # x[454]
    .word 0x368CBBAC    # x[455]
    .word 0xB0D93929    # x[456]
    .word 0xBA31B8CB    # x[457]
    .word 0xB8C831A0    # x[458]
    .word 0xBA70398B    # x[459]
    .word 0x34CFBA26    # x[460]
    .word 0xAEA53A93    # x[461]
    .word 0x39B93A0B    # x[462]
    .word 0xB85CBB93    # x[463]
    .word 0xB73DBBE3    # x[464]
    .word 0x32ACB14D    # x[465]
    .word 0x38413B9D    # x[466]
    .word 0x322CB44E    # x[467]
    .word 0x37D230F4    # x[468]
    .word 0x26FDB091    # x[469]
    .word 0xB854B2A4    # x[470]
    .word 0x396BB5CD    # x[471]
    .word 0xB1023998    # x[472]
    .word 0x38B6BA6E    # x[473]
    .word 0x3403B624    # x[474]
    .word 0xB96EB86C    # x[475]
    .word 0xB8C83194    # x[476]
    .word 0xB57237A5    # x[477]
    .word 0x2A7C3A3C    # x[478]
    .word 0x3BF4B716    # x[479]
    .word 0xBA19BBA2    # x[480]
    .word 0xBA333B8C    # x[481]
    .word 0x9887AF19    # x[482]
    .word 0xB9FE3A2C    # x[483]
    .word 0xB6FF3BFA    # x[484]
    .word 0x3AA33156    # x[485]
    .word 0xB686B802    # x[486]
    .word 0x38DEB752    # x[487]
    .word 0xB99E3218    # x[488]
    .word 0x1DE1B88C    # x[489]
    .word 0x3898363F    # x[490]
    .word 0xB7A0A143    # x[491]
    .word 0xB94D389B    # x[492]
    .word 0x2FE23A6D    # x[493]
    .word 0x2A10BB2F    # x[494]
    .word 0x3737B5F6    # x[495]
    .word 0xBBD5A8CE    # x[496]
    .word 0xB425BB54    # x[497]
    .word 0x2DFDB906    # x[498]
    .word 0xB92EAEEF    # x[499]
    .word 0x314F2B81    # x[500]
    .word 0xB198BB17    # x[501]
    .word 0x30AE3988    # x[502]
    .word 0xB8E03208    # x[503]
    .word 0x3305BAE3    # x[504]
    .word 0xB933380B    # x[505]
    .word 0x3B5FB76C    # x[506]
    .word 0x37FE386A    # x[507]
    .word 0xB521B259    # x[508]
    .word 0xB81B380F    # x[509]
    .word 0x371C3652    # x[510]
    .word 0xB8E83AD2    # x[511]
    .word 0xB704BA41    # x[512]
    .word 0x37E2BB36    # x[513]
    .word 0xBA28A14B    # x[514]
    .word 0xBAABB98E    # x[515]
    .word 0xB96A3A61    # x[516]
    .word 0xBA62AC59    # x[517]
    .word 0x3A2DBBB9    # x[518]
    .word 0xB8E938C6    # x[519]
    .word 0x3B1C2D80    # x[520]
    .word 0x3B98B88F    # x[521]
    .word 0xBABF3A29    # x[522]
    .word 0x30B42950    # x[523]
    .word 0xB773B8CB    # x[524]
    .word 0xB156B38C    # x[525]
    .word 0x38473459    # x[526]
    .word 0xBB79B877    # x[527]
    .word 0x2E703AEB    # x[528]
    .word 0x390D3A9A    # x[529]
    .word 0xB40C36B2    # x[530]
    .word 0x982BB9B4    # x[531]
    .word 0x31203A9E    # x[532]
    .word 0xBA8FB892    # x[533]
    .word 0xBB80352B    # x[534]
    .word 0xBBC939AD    # x[535]
    .word 0xB2D22E6A    # x[536]
    .word 0x319C3A35    # x[537]
    .word 0xB847383D    # x[538]
    .word 0x2B40B532    # x[539]
    .word 0xB41738C5    # x[540]
    .word 0xBB1F3968    # x[541]
    .word 0x3ADC3753    # x[542]
    .word 0x2C82BBF1    # x[543]
    .word 0x9BDEB985    # x[544]
    .word 0xB9CFB64A    # x[545]
    .word 0x3A3A37E4    # x[546]
    .word 0xB742B899    # x[547]
    .word 0x3AB434FD    # x[548]
    .word 0x3BAC3917    # x[549]
    .word 0xB92D3AA0    # x[550]
    .word 0xB768BBB0    # x[551]
    .word 0x2EDD3AA3    # x[552]
    .word 0x3596233D    # x[553]
    .word 0xBA1CB882    # x[554]
    .word 0x38CA331C    # x[555]
    .word 0xB540381B    # x[556]
    .word 0xBBB039CD    # x[557]
    .word 0xBA5136DA    # x[558]
    .word 0x317BB4E9    # x[559]
    .word 0xAD49342B    # x[560]
    .word 0x29B1B4CE    # x[561]
    .word 0xB56438E5    # x[562]
    .word 0x34C6345B    # x[563]
    .word 0x398ABA47    # x[564]
    .word 0xB92FBB1A    # x[565]
    .word 0xACC138D4    # x[566]
    .word 0x3A7135AD    # x[567]
    .word 0x37C5370F    # x[568]
    .word 0xB63FBBBC    # x[569]
    .word 0xB89E3299    # x[570]
    .word 0x36BCB8E3    # x[571]
    .word 0xB90E3319    # x[572]
    .word 0xBA262A39    # x[573]
    .word 0x3AEBB5FF    # x[574]
    .word 0xBB0B36A0    # x[575]
    .word 0x3ACC3ABC    # x[576]
    .word 0x39E2AF65    # x[577]
    .word 0x37593787    # x[578]
    .word 0xB8F13041    # x[579]
    .word 0xB6023958    # x[580]
    .word 0x3A2C3A84    # x[581]
    .word 0x3679B6A1    # x[582]
    .word 0x3BC7301E    # x[583]
    .word 0x3BB3365B    # x[584]
    .word 0xB09BB423    # x[585]
    .word 0xBA1D28A4    # x[586]
    .word 0x3B8327D4    # x[587]
    .word 0x37263320    # x[588]
    .word 0xB671371D    # x[589]
    .word 0xB26F3BDB    # x[590]
    .word 0xB85DB3C6    # x[591]
    .word 0x3645264A    # x[592]
    .word 0x36CBB90B    # x[593]
    .word 0x3AAD397C    # x[594]
    .word 0xB060B8DC    # x[595]
    .word 0xB5B7B737    # x[596]
    .word 0x3A82A252    # x[597]
    .word 0xB0B83B4D    # x[598]
    .word 0x3A39AF66    # x[599]
    .word 0x3483384B    # x[600]
    .word 0x2C7E376E    # x[601]
    .word 0xBA0A2B63    # x[602]
    .word 0x3888BA67    # x[603]
    .word 0xBA76B0C0    # x[604]
    .word 0xB5DAB615    # x[605]
    .word 0x3B5DBAB8    # x[606]
    .word 0xB95BB98B    # x[607]
    .word 0x3B6FB9AD    # x[608]
    .word 0x34CBBB22    # x[609]
    .word 0xB0DC3701    # x[610]
    .word 0x384735D8    # x[611]
    .word 0x3595B444    # x[612]
    .word 0x365D360E    # x[613]
    .word 0xBB1D3A58    # x[614]
    .word 0x391339A4    # x[615]
    .word 0x3095B79E    # x[616]
    .word 0x377CB961    # x[617]
    .word 0xBBF4BB9F    # x[618]
    .word 0xB98D3439    # x[619]
    .word 0x39FEAA1D    # x[620]
    .word 0xB8843A69    # x[621]
    .word 0x38E8AD82    # x[622]
    .word 0x38333977    # x[623]
    .word 0x380938FB    # x[624]
    .word 0xB81FB818    # x[625]
    .word 0xB555BA2B    # x[626]
    .word 0x334ABA58    # x[627]
    .word 0xBBBCAE8A    # x[628]
    .word 0x3B4EBAEC    # x[629]
    .word 0x3B80B5F6    # x[630]
    .word 0x3A70BB04    # x[631]
    .word 0xB9573AB0    # x[632]
    .word 0x3B4B33DA    # x[633]
    .word 0x315AB590    # x[634]
    .word 0xB9B7BB64    # x[635]
    .word 0xB8E7B885    # x[636]
    .word 0x32BEB954    # x[637]
    .word 0xBAA6BB69    # x[638]
    .word 0x3B5638EC    # x[639]
    .word 0xB24131B2    # x[640]
    .word 0x37E8B471    # x[641]
    .word 0x32B1B955    # x[642]
    .word 0x39B038A4    # x[643]
    .word 0xB84431A8    # x[644]
    .word 0xBB23398E    # x[645]
    .word 0xAA8FB8D0    # x[646]
    .word 0x3AAF253F    # x[647]
    .word 0xB3EE383D    # x[648]
    .word 0x3996B420    # x[649]
    .word 0x3AFF3741    # x[650]
    .word 0xB8D0B981    # x[651]
    .word 0x39DD305E    # x[652]
    .word 0x38AEB029    # x[653]
    .word 0xBB3A3B27    # x[654]
    .word 0xB0E7359B    # x[655]
    .word 0x3463B4B8    # x[656]
    .word 0xB8B1B715    # x[657]
    .word 0xB51234FE    # x[658]
    .word 0xA40BB448    # x[659]
    .word 0x34B1BB5E    # x[660]
    .word 0x38D3B90B    # x[661]
    .word 0x3564BB0D    # x[662]
    .word 0xB037341A    # x[663]
    .word 0xB90CB834    # x[664]
    .word 0x2732B8B6    # x[665]
    .word 0xBB3EB856    # x[666]
    .word 0x385F37B6    # x[667]
    .word 0xB89FBBA2    # x[668]
    .word 0xBBCBB84B    # x[669]
    .word 0x342E3B66    # x[670]
    .word 0x378930A1    # x[671]
    .word 0xBB5BB862    # x[672]
    .word 0x3530B00E    # x[673]
    .word 0x330C2FE4    # x[674]
    .word 0xB72F345C    # x[675]
    .word 0x3613B912    # x[676]
    .word 0x3AE8B7A1    # x[677]
    .word 0x371A3512    # x[678]
    .word 0x35B2B5F5    # x[679]
    .word 0xB811B8D8    # x[680]
    .word 0xAF6131F2    # x[681]
    .word 0x3A942A97    # x[682]
    .word 0xA3A33B88    # x[683]
    .word 0xB62FB559    # x[684]
    .word 0x30DFB9DA    # x[685]
    .word 0xB18FB8A1    # x[686]
    .word 0x380F3A04    # x[687]
    .word 0x3907A292    # x[688]
    .word 0x3BDA3274    # x[689]
    .word 0x2648BAE5    # x[690]
    .word 0x371E39D6    # x[691]
    .word 0xB54CB52F    # x[692]
    .word 0xB8F8388D    # x[693]
    .word 0x3470B894    # x[694]
    .word 0xBBB23997    # x[695]
    .word 0x1D563159    # x[696]
    .word 0xB15EBA8D    # x[697]
    .word 0x324C307B    # x[698]
    .word 0xA7C73ACF    # x[699]
    .word 0x2ED0B732    # x[700]
    .word 0xB1E8B859    # x[701]
    .word 0x3B32B873    # x[702]
    .word 0x34063A0F    # x[703]
    .word 0x38CCBB60    # x[704]
    .word 0x2E08B9AA    # x[705]
    .word 0x3B0D3978    # x[706]
    .word 0x32F33A15    # x[707]
    .word 0x392F3011    # x[708]
    .word 0xB956AE7F    # x[709]
    .word 0x3905BBF6    # x[710]
    .word 0xB1B435FC    # x[711]
    .word 0xBA20B99C    # x[712]
    .word 0x3448B406    # x[713]
    .word 0xB3D53964    # x[714]
    .word 0xB65034D2    # x[715]
    .word 0x333CB5E7    # x[716]
    .word 0x25102FDF    # x[717]
    .word 0xB88DA816    # x[718]
    .word 0x38F9B96F    # x[719]
    .word 0x37FBB3B6    # x[720]
    .word 0xBB99BAF9    # x[721]
    .word 0x34BD31B3    # x[722]
    .word 0x3B3A2FCE    # x[723]
    .word 0x39E83391    # x[724]
    .word 0x2DA2B026    # x[725]
    .word 0xB75EB08E    # x[726]
    .word 0xB2FEB2A2    # x[727]
    .word 0xAD6FB88E    # x[728]
    .word 0xB369B9E9    # x[729]
    .word 0x37233893    # x[730]
    .word 0xB937B69D    # x[731]
    .word 0xB8623968    # x[732]
    .word 0x388DBB1A    # x[733]
    .word 0xA6993232    # x[734]
    .word 0x382BBBC3    # x[735]
    .word 0xB0863670    # x[736]
    .word 0x2F74AA7F    # x[737]
    .word 0x3B6E36EC    # x[738]
    .word 0x35FC39F3    # x[739]
    .word 0xB2E0B58C    # x[740]
    .word 0xB9FEB672    # x[741]
    .word 0x34E738DB    # x[742]
    .word 0x346CB59C    # x[743]
    .word 0x3A083A20    # x[744]
    .word 0x38023848    # x[745]
    .word 0xB90B3216    # x[746]
    .word 0x32423767    # x[747]
    .word 0xAD3B3819    # x[748]
    .word 0xB76CB898    # x[749]
    .word 0xBB823A9A    # x[750]
    .word 0x320F355F    # x[751]
    .word 0x32703B1C    # x[752]
    .word 0xB1C43875    # x[753]
    .word 0xB5903489    # x[754]
    .word 0x3A7D316B    # x[755]
    .word 0x3849374B    # x[756]
    .word 0xB73DB3C2    # x[757]
    .word 0xA862B12A    # x[758]
    .word 0x3976BB2C    # x[759]
    .word 0x38C7BA64    # x[760]
    .word 0x2675B267    # x[761]
    .word 0xB83FB8FA    # x[762]
    .word 0x3ACFB91C    # x[763]
    .word 0xBB10B950    # x[764]
    .word 0x38EA3440    # x[765]
    .word 0xBB2B386F    # x[766]
    .word 0xB026B79D    # x[767]
    .word 0x3A39394F    # x[768]
    .word 0xB9EBB7DD    # x[769]
    .word 0xB8CAB0BC    # x[770]
    .word 0x3A2DB17D    # x[771]
    .word 0xB97B3A0A    # x[772]
    .word 0xB17B2729    # x[773]
    .word 0xBAF8B58E    # x[774]
    .word 0xBA5B35F0    # x[775]
    .word 0xB4BFB966    # x[776]
    .word 0x358238D7    # x[777]
    .word 0xB3A53543    # x[778]
    .word 0x3BB89FFD    # x[779]
    .word 0x38D43A6A    # x[780]
    .word 0x35D7B069    # x[781]
    .word 0xB669B83D    # x[782]
    .word 0x376DB4BB    # x[783]
    .word 0x3A9733A5    # x[784]
    .word 0xAF533483    # x[785]
    .word 0x39D0BB77    # x[786]
    .word 0xBAD0B898    # x[787]
    .word 0xB3C8B859    # x[788]
    .word 0x3847B495    # x[789]
    .word 0xB1C8BB4D    # x[790]
    .word 0xA3C8359E    # x[791]
    .word 0x3A89BAB3    # x[792]
    .word 0x3345BB05    # x[793]
    .word 0xBB123156    # x[794]
    .word 0x3932AF6F    # x[795]
    .word 0x34D0370E    # x[796]
    .word 0x2B4EB3D3    # x[797]
    .word 0x2DD038C7    # x[798]
    .word 0x1E8E3907    # x[799]
    .word 0x3A6A35E6    # x[800]
    .word 0x3AEB302C    # x[801]
    .word 0x38CD3AEF    # x[802]
    .word 0x31EAB8A4    # x[803]
    .word 0x3620BB1E    # x[804]
    .word 0x212222A1    # x[805]
    .word 0xBB7A3891    # x[806]
    .word 0x3A423823    # x[807]
    .word 0xBA8C2DA9    # x[808]
    .word 0x2EF6BA0F    # x[809]
    .word 0xBA19B572    # x[810]
    .word 0xB2071862    # x[811]
    .word 0x32E5B758    # x[812]
    .word 0x3BC9AF13    # x[813]
    .word 0x3820B25C    # x[814]
    .word 0xB7783842    # x[815]
    .word 0x39B5B2BC    # x[816]
    .word 0xBB4539D5    # x[817]
    .word 0x31F8B9A1    # x[818]
    .word 0xB96A3BDD    # x[819]
    .word 0x2CA132C4    # x[820]
    .word 0xBAB0239B    # x[821]
    .word 0xB897B47E    # x[822]
    .word 0x34B93560    # x[823]
    .word 0x3658337D    # x[824]
    .word 0x3A4C3505    # x[825]
    .word 0xB6993BBB    # x[826]
    .word 0x2CB12E3D    # x[827]
    .word 0x9B06B749    # x[828]
    .word 0xB344B535    # x[829]
    .word 0xB669B728    # x[830]
    .word 0xBA51B816    # x[831]
    .word 0x37D8B624    # x[832]
    .word 0xB7883A7E    # x[833]
    .word 0x3849BBBB    # x[834]
    .word 0xB7483A24    # x[835]
    .word 0x3BC3B8C5    # x[836]
    .word 0x3469247E    # x[837]
    .word 0xB8F7B8DF    # x[838]
    .word 0xBBD63B23    # x[839]
    .word 0xBA633B87    # x[840]
    .word 0xBBFC3BD4    # x[841]
    .word 0x3B963B27    # x[842]
    .word 0x3A07B2D6    # x[843]
    .word 0xB891BBBB    # x[844]
    .word 0x3800BAB0    # x[845]
    .word 0xB6E6A6E2    # x[846]
    .word 0x3379BA0E    # x[847]
    .word 0x3A39B75A    # x[848]
    .word 0xB6AFBA1C    # x[849]
    .word 0xB5E63083    # x[850]
    .word 0x3937ACE4    # x[851]
    .word 0x30BEB116    # x[852]
    .word 0xB49BB97B    # x[853]
    .word 0xB7BE320B    # x[854]
    .word 0xAD1BB66B    # x[855]
    .word 0x30FEBAD3    # x[856]
    .word 0xB1503A1C    # x[857]
    .word 0xBA7AB770    # x[858]
    .word 0x35393AD0    # x[859]
    .word 0xBBD439EF    # x[860]
    .word 0x3B8539C2    # x[861]
    .word 0xAB913893    # x[862]
    .word 0xBB09BB12    # x[863]
    .word 0xB96CAE99    # x[864]
    .word 0xBA3038DF    # x[865]
    .word 0xBBC53272    # x[866]
    .word 0xB8F0B1BA    # x[867]
    .word 0x3AD4BA27    # x[868]
    .word 0x392BB3F5    # x[869]
    .word 0x3B7DB738    # x[870]
    .word 0x3AF9B731    # x[871]
    .word 0xB382B9E3    # x[872]
    .word 0x3370B870    # x[873]
    .word 0xBAE82D08    # x[874]
    .word 0xB6CB3A93    # x[875]
    .word 0x3A233BAE    # x[876]
    .word 0xBBDEB7DC    # x[877]
    .word 0x34A8BA2C    # x[878]
    .word 0x38013783    # x[879]
    .word 0x374A3745    # x[880]
    .word 0x3B4AB91C    # x[881]
    .word 0x36653A4A    # x[882]
    .word 0xB02439C6    # x[883]
    .word 0x36C33480    # x[884]
    .word 0xB6C43A0D    # x[885]
    .word 0x3BCFBA10    # x[886]
    .word 0x3532B87F    # x[887]
    .word 0x3AFAB8DE    # x[888]
    .word 0xAD0533EE    # x[889]
    .word 0x39543BE1    # x[890]
    .word 0x332F365C    # x[891]
    .word 0x3B4A39E6    # x[892]
    .word 0xBA443B7E    # x[893]
    .word 0xB4043BE4    # x[894]
    .word 0xBB3F3810    # x[895]
    .word 0xBA83B4F2    # x[896]
    .word 0xB88CBBCB    # x[897]
    .word 0x29313866    # x[898]
    .word 0xB81F394E    # x[899]
    .word 0x38E6B81D    # x[900]
    .word 0x3B323B91    # x[901]
    .word 0xB821BB69    # x[902]
    .word 0xB83BB2C4    # x[903]
    .word 0xB903B8B4    # x[904]
    .word 0xB6793965    # x[905]
    .word 0x39E1BA7C    # x[906]
    .word 0xABD53985    # x[907]
    .word 0x384E3BF2    # x[908]
    .word 0x38633802    # x[909]
    .word 0x3441B854    # x[910]
    .word 0xBAF0A371    # x[911]
    .word 0xB25CADE6    # x[912]
    .word 0xB1C0398E    # x[913]
    .word 0xBAB2B5D5    # x[914]
    .word 0xB97BB863    # x[915]
    .word 0x3776B894    # x[916]
    .word 0x3147B296    # x[917]
    .word 0xB32C3B6B    # x[918]
    .word 0xB483BADE    # x[919]
    .word 0x384B353F    # x[920]
    .word 0x24BB2F8A    # x[921]
    .word 0x3BC1B5BB    # x[922]
    .word 0xB59B30DF    # x[923]
    .word 0xB41A2EE0    # x[924]
    .word 0x35C3BBE5    # x[925]
    .word 0xBBAFB6BE    # x[926]
    .word 0x336035D4    # x[927]
    .word 0x39DCB828    # x[928]
    .word 0x3A3B398B    # x[929]
    .word 0xBAE93842    # x[930]
    .word 0x34AABA17    # x[931]
    .word 0xAB0837A9    # x[932]
    .word 0x3B9CB95C    # x[933]
    .word 0xB05AB9AF    # x[934]
    .word 0x38C0B5BD    # x[935]
    .word 0x3A35B221    # x[936]
    .word 0x3906B8F3    # x[937]
    .word 0xB67EBB40    # x[938]
    .word 0x39EEB384    # x[939]
    .word 0xB375B9AE    # x[940]
    .word 0x300F392D    # x[941]
    .word 0x3B5C2557    # x[942]
    .word 0x30A8B524    # x[943]
    .word 0x38C6B810    # x[944]
    .word 0x39083B9E    # x[945]
    .word 0xB9EA32EE    # x[946]
    .word 0x37DA3431    # x[947]
    .word 0x3BE636E6    # x[948]
    .word 0xB0B13B3C    # x[949]
    .word 0x39A63447    # x[950]
    .word 0x323A3AD9    # x[951]
    .word 0x3A193911    # x[952]
    .word 0x30433680    # x[953]
    .word 0xBAE5B97A    # x[954]
    .word 0xB86EB32A    # x[955]
    .word 0x31D0BB1E    # x[956]
    .word 0x31FEB49D    # x[957]
    .word 0xA9BFBB0C    # x[958]
    .word 0x3016B60C    # x[959]
    .word 0x382D270A    # x[960]
    .word 0x349D25AF    # x[961]
    .word 0xB83BBAC0    # x[962]
    .word 0xB41CB29E    # x[963]
    .word 0x3B42357E    # x[964]
    .word 0x2FEABB25    # x[965]
    .word 0xB516BA1B    # x[966]
    .word 0xBBEFBAA8    # x[967]
    .word 0x3688B854    # x[968]
    .word 0xB61EBACD    # x[969]
    .word 0x362AB5D1    # x[970]
    .word 0xB39FB94F    # x[971]
    .word 0xB4B838BC    # x[972]
    .word 0x29AB2425    # x[973]
    .word 0xB678389F    # x[974]
    .word 0xB2D8BA3D    # x[975]
    .word 0xAD493888    # x[976]
    .word 0x3448BA09    # x[977]
    .word 0x34753B33    # x[978]
    .word 0xBA6B3A1C    # x[979]
    .word 0x3775BA4D    # x[980]
    .word 0xB8B9326E    # x[981]
    .word 0xB95EB97D    # x[982]
    .word 0x3A8ABAC3    # x[983]
    .word 0xAEFB3432    # x[984]
    .word 0x3243AE9C    # x[985]
    .word 0xB808AF75    # x[986]
    .word 0x28BD3085    # x[987]
    .word 0xB0F4B003    # x[988]
    .word 0xBBC82E4F    # x[989]
    .word 0xB9843120    # x[990]
    .word 0xB36BB850    # x[991]
    .word 0x394FB320    # x[992]
    .word 0xB060BBF1    # x[993]
    .word 0xB5E0BBB2    # x[994]
    .word 0x3645BB6A    # x[995]
    .word 0xB12439CD    # x[996]
    .word 0xB7643885    # x[997]
    .word 0xBA853A4A    # x[998]
    .word 0xBAA53A48    # x[999]
    .word 0xB9F335AF    # x[1000]
    .word 0x39E23A8D    # x[1001]
    .word 0xB7BBB8AD    # x[1002]
    .word 0xBB6039A2    # x[1003]
    .word 0x367E3AC6    # x[1004]
    .word 0xBB913BF6    # x[1005]
    .word 0x3A0E3905    # x[1006]
    .word 0xBAE0B8C7    # x[1007]
    .word 0x33F22DD9    # x[1008]
    .word 0xB4AAB26B    # x[1009]
    .word 0xB9543A3D    # x[1010]
    .word 0x380234A7    # x[1011]
    .word 0x3915B319    # x[1012]
    .word 0xBAB23935    # x[1013]
    .word 0x3AF1A988    # x[1014]
    .word 0x9A09371D    # x[1015]
    .word 0x3AAEB82C    # x[1016]
    .word 0x37A23B57    # x[1017]
    .word 0x3559BB59    # x[1018]
    .word 0x3B62A708    # x[1019]
    .word 0xA86FBB1E    # x[1020]
    .word 0x30302E9A    # x[1021]
    .word 0xA88D2C95    # x[1022]
    .word 0x2D15AD3C    # x[1023]

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
