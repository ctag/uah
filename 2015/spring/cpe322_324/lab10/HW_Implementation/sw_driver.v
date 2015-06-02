// Single Button Texter -- automated switch driver module
// -- sw_driver.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// Switch Drive module for testbench (to validate single button 
// texter design)
module sw_driver (input clk, sp_up, sp_dwn, reset,
   output reg sw_out, output reg [7:0] ledr);

   reg sp_up_os, sp_dwn_os;
   reg [2:0] sp_index = 0;
   reg [22:0] m_clk_range [0:7];
   reg [1:0]  sw_out_tm [0:2047];

   initial
      begin
      // these values represent 7.5, 10, 13, 15, 17, 20, 25, and 
      // 30 WPM of code
      m_clk_range[0] = 4319999;
      m_clk_range[1] = 3239999;
      m_clk_range[2] = 2492307;
      m_clk_range[3] = 2159999;
      m_clk_range[4] = 1799999;
      m_clk_range[5] = 1619999;
      m_clk_range[6] = 1295999;
      m_clk_range[7] = 1079999;

      // on/off keying timing where
      // 1 => one unit pulse, 2 => three unit pulses,  
      // 3 >= space timing 0 => restart at the beginning of the array
      sw_out_tm[0]=2'd1;   sw_out_tm[1]=2'd1;   sw_out_tm[2]=2'd2;
      sw_out_tm[3]=2'd2;   sw_out_tm[4]=2'd2;   sw_out_tm[5]=2'd1;
      sw_out_tm[6]=2'd1;   sw_out_tm[7]=2'd1;   sw_out_tm[8]=2'd1;
      sw_out_tm[9]=2'd1;   sw_out_tm[10]=2'd1;  sw_out_tm[11]=2'd2;
      sw_out_tm[12]=2'd2;  sw_out_tm[13]=2'd1;  sw_out_tm[14]=2'd1;
      sw_out_tm[15]=2'd1;  sw_out_tm[16]=2'd2;  sw_out_tm[17]=2'd1;
      sw_out_tm[18]=2'd1;  sw_out_tm[19]=2'd2;  sw_out_tm[20]=2'd2;
      sw_out_tm[21]=2'd1;  sw_out_tm[22]=2'd1;  sw_out_tm[23]=2'd1;
      sw_out_tm[24]=2'd1;  sw_out_tm[25]=2'd2;  sw_out_tm[26]=2'd1;
      sw_out_tm[27]=2'd2;  sw_out_tm[28]=2'd1;  sw_out_tm[29]=2'd1;
      sw_out_tm[30]=2'd1;  sw_out_tm[31]=2'd1;  sw_out_tm[32]=2'd2;
      sw_out_tm[33]=2'd1;  sw_out_tm[34]=2'd1;  sw_out_tm[35]=2'd2;
      sw_out_tm[36]=2'd2;  sw_out_tm[37]=2'd1;  sw_out_tm[38]=2'd2;
      sw_out_tm[39]=2'd1;  sw_out_tm[40]=2'd1;  sw_out_tm[41]=2'd2;
      sw_out_tm[42]=2'd1;  sw_out_tm[43]=2'd1;  sw_out_tm[44]=2'd1;
      sw_out_tm[45]=2'd1;  sw_out_tm[46]=2'd1;  sw_out_tm[47]=2'd1;
      sw_out_tm[48]=2'd1;  sw_out_tm[49]=2'd2;  sw_out_tm[50]=2'd1;
      sw_out_tm[51]=2'd1;  sw_out_tm[52]=2'd1;  sw_out_tm[53]=2'd2;
      sw_out_tm[54]=2'd1;  sw_out_tm[55]=2'd1;  sw_out_tm[56]=2'd2;
      sw_out_tm[57]=2'd1;  sw_out_tm[58]=2'd2;  sw_out_tm[59]=2'd1;
      sw_out_tm[60]=2'd2;  sw_out_tm[61]=2'd2;  sw_out_tm[62]=2'd2;
      sw_out_tm[63]=2'd1;  sw_out_tm[64]=2'd1;  sw_out_tm[65]=2'd1;
      sw_out_tm[66]=2'd2;  sw_out_tm[67]=2'd2;  sw_out_tm[68]=2'd1;
      sw_out_tm[69]=2'd1;  sw_out_tm[70]=2'd2;  sw_out_tm[71]=2'd1;
      sw_out_tm[72]=2'd1;  sw_out_tm[73]=2'd1;  sw_out_tm[74]=2'd1;
      sw_out_tm[75]=2'd2;  sw_out_tm[76]=2'd2;  sw_out_tm[77]=2'd1;
      sw_out_tm[78]=2'd2;  sw_out_tm[79]=2'd2;  sw_out_tm[80]=2'd2;
      sw_out_tm[81]=2'd1;  sw_out_tm[82]=2'd1;  sw_out_tm[83]=2'd2;
      sw_out_tm[84]=2'd2;  sw_out_tm[85]=2'd1;  sw_out_tm[86]=2'd2;
      sw_out_tm[87]=2'd1;  sw_out_tm[88]=2'd2;  sw_out_tm[89]=2'd2;
      sw_out_tm[90]=2'd1;  sw_out_tm[91]=2'd1;  sw_out_tm[92]=2'd2;
      sw_out_tm[93]=2'd1;  sw_out_tm[94]=2'd2;  sw_out_tm[95]=2'd1;
      sw_out_tm[96]=2'd1;  sw_out_tm[97]=2'd2;  sw_out_tm[98]=2'd2;
      sw_out_tm[99]=2'd1;  sw_out_tm[100]=2'd2; sw_out_tm[101]=2'd1;
      sw_out_tm[102]=2'd1; sw_out_tm[103]=2'd1; sw_out_tm[104]=2'd2;
      sw_out_tm[105]=2'd2; sw_out_tm[106]=2'd1; sw_out_tm[107]=2'd1;
      sw_out_tm[108]=2'd2; sw_out_tm[109]=2'd1; sw_out_tm[110]=2'd1;
      sw_out_tm[111]=2'd2; sw_out_tm[112]=2'd1; sw_out_tm[113]=2'd1;
      sw_out_tm[114]=2'd1; sw_out_tm[115]=2'd1; sw_out_tm[116]=2'd1;
      sw_out_tm[117]=2'd2; sw_out_tm[118]=2'd2; sw_out_tm[119]=2'd2;
      sw_out_tm[120]=2'd1; sw_out_tm[121]=2'd1; sw_out_tm[122]=2'd1;
      sw_out_tm[123]=2'd1; sw_out_tm[124]=2'd2; sw_out_tm[125]=2'd2;
      sw_out_tm[126]=2'd1; sw_out_tm[127]=2'd1; sw_out_tm[128]=2'd1;
      sw_out_tm[129]=2'd1; sw_out_tm[130]=2'd1; sw_out_tm[131]=2'd1;
      sw_out_tm[132]=2'd2; sw_out_tm[133]=2'd2; sw_out_tm[134]=2'd1;
      sw_out_tm[135]=2'd1; sw_out_tm[136]=2'd2; sw_out_tm[137]=2'd1;
      sw_out_tm[138]=2'd2; sw_out_tm[139]=2'd2; sw_out_tm[140]=2'd2;
      sw_out_tm[141]=2'd1; sw_out_tm[142]=2'd1; sw_out_tm[143]=2'd1;
      sw_out_tm[144]=2'd1; sw_out_tm[145]=2'd1; sw_out_tm[146]=2'd2;
      sw_out_tm[147]=2'd2; sw_out_tm[148]=2'd2; sw_out_tm[149]=2'd1;
      sw_out_tm[150]=2'd1; sw_out_tm[151]=2'd1; sw_out_tm[152]=2'd2;
      sw_out_tm[153]=2'd1; sw_out_tm[154]=2'd2; sw_out_tm[155]=2'd2;
      sw_out_tm[156]=2'd2; sw_out_tm[157]=2'd1; sw_out_tm[158]=2'd2;
      sw_out_tm[159]=2'd1; sw_out_tm[160]=2'd1; sw_out_tm[161]=2'd1;
      sw_out_tm[162]=2'd1; sw_out_tm[163]=2'd2; sw_out_tm[164]=2'd2;
      sw_out_tm[165]=2'd1; sw_out_tm[166]=2'd2; sw_out_tm[167]=2'd1;
      sw_out_tm[168]=2'd2; sw_out_tm[169]=2'd1; sw_out_tm[170]=2'd2;
      sw_out_tm[171]=2'd1; sw_out_tm[172]=2'd2; sw_out_tm[173]=2'd2;
      sw_out_tm[174]=2'd1; sw_out_tm[175]=2'd1; sw_out_tm[176]=2'd2;
      sw_out_tm[177]=2'd1; sw_out_tm[178]=2'd2; sw_out_tm[179]=2'd1;
      sw_out_tm[180]=2'd2; sw_out_tm[181]=2'd1; sw_out_tm[182]=2'd2;
      sw_out_tm[183]=2'd2; sw_out_tm[184]=2'd1; sw_out_tm[185]=2'd1;
      sw_out_tm[186]=2'd1; sw_out_tm[187]=2'd1; sw_out_tm[188]=2'd2;
      sw_out_tm[189]=2'd1; sw_out_tm[190]=2'd2; sw_out_tm[191]=2'd1;
      sw_out_tm[192]=2'd2; sw_out_tm[193]=2'd2; sw_out_tm[194]=2'd1;
      sw_out_tm[195]=2'd1; sw_out_tm[196]=2'd1; sw_out_tm[197]=2'd1;
      sw_out_tm[198]=2'd1; sw_out_tm[199]=2'd1; sw_out_tm[200]=2'd2;
      sw_out_tm[201]=2'd1; sw_out_tm[202]=2'd2; sw_out_tm[203]=2'd2;
      sw_out_tm[204]=2'd1; sw_out_tm[205]=2'd1; sw_out_tm[206]=2'd1;
      sw_out_tm[207]=2'd1; sw_out_tm[208]=2'd1; sw_out_tm[209]=2'd1;
      sw_out_tm[210]=2'd1; sw_out_tm[211]=2'd1; sw_out_tm[212]=2'd2;
      sw_out_tm[213]=2'd2; sw_out_tm[214]=2'd1; sw_out_tm[215]=2'd1;
      sw_out_tm[216]=2'd1; sw_out_tm[217]=2'd1; sw_out_tm[218]=2'd1;
      sw_out_tm[219]=2'd1; sw_out_tm[220]=2'd1; sw_out_tm[221]=2'd1;
      sw_out_tm[222]=2'd1; sw_out_tm[223]=2'd2; sw_out_tm[224]=2'd2;
      sw_out_tm[225]=2'd1; sw_out_tm[226]=2'd1; sw_out_tm[227]=2'd1;
      sw_out_tm[228]=2'd1; sw_out_tm[229]=2'd1; sw_out_tm[230]=2'd1;
      sw_out_tm[231]=2'd1; sw_out_tm[232]=2'd1; sw_out_tm[233]=2'd2;
      sw_out_tm[234]=2'd2; sw_out_tm[235]=2'd1; sw_out_tm[236]=2'd2;
      sw_out_tm[237]=2'd1; sw_out_tm[238]=2'd1; sw_out_tm[239]=2'd1;
      sw_out_tm[240]=2'd1; sw_out_tm[241]=2'd1; sw_out_tm[242]=2'd1;
      sw_out_tm[243]=2'd2; sw_out_tm[244]=2'd2; sw_out_tm[245]=2'd1;
      sw_out_tm[246]=2'd2; sw_out_tm[247]=2'd1; sw_out_tm[248]=2'd2;
      sw_out_tm[249]=2'd1; sw_out_tm[250]=2'd1; sw_out_tm[251]=2'd1;
      sw_out_tm[252]=2'd1; sw_out_tm[253]=2'd2; sw_out_tm[254]=2'd2;
      sw_out_tm[255]=2'd1; sw_out_tm[256]=2'd2; sw_out_tm[257]=2'd1;
      sw_out_tm[258]=2'd2; sw_out_tm[259]=2'd1; sw_out_tm[260]=2'd2;
      sw_out_tm[261]=2'd1; sw_out_tm[262]=2'd1; sw_out_tm[263]=2'd2;
      sw_out_tm[264]=2'd1; sw_out_tm[265]=2'd1; sw_out_tm[266]=2'd2;
      sw_out_tm[267]=2'd1; sw_out_tm[268]=2'd1; sw_out_tm[269]=2'd1;
      sw_out_tm[270]=2'd2; sw_out_tm[271]=2'd1; sw_out_tm[272]=2'd1;
      sw_out_tm[273]=2'd1; sw_out_tm[274]=2'd2; sw_out_tm[275]=2'd2;
      sw_out_tm[276]=2'd2; sw_out_tm[277]=2'd1; sw_out_tm[278]=2'd2;
      sw_out_tm[279]=2'd1; sw_out_tm[280]=2'd1; sw_out_tm[281]=2'd1;
      sw_out_tm[282]=2'd1; sw_out_tm[283]=2'd1; sw_out_tm[284]=2'd2;
      sw_out_tm[285]=2'd1; sw_out_tm[286]=2'd2; sw_out_tm[287]=2'd2;
      sw_out_tm[288]=2'd1; sw_out_tm[289]=2'd1; sw_out_tm[290]=2'd1;
      sw_out_tm[291]=2'd1; sw_out_tm[292]=2'd2; sw_out_tm[293]=2'd1;
      sw_out_tm[294]=2'd2; sw_out_tm[295]=2'd1; sw_out_tm[296]=2'd1;
      sw_out_tm[297]=2'd1; sw_out_tm[298]=2'd1; sw_out_tm[299]=2'd2;
      sw_out_tm[300]=2'd1; sw_out_tm[301]=2'd1; sw_out_tm[302]=2'd1;
      sw_out_tm[303]=2'd1; sw_out_tm[304]=2'd1; sw_out_tm[305]=2'd1;
      sw_out_tm[306]=2'd2; sw_out_tm[307]=2'd1; sw_out_tm[308]=2'd1;
      sw_out_tm[309]=2'd1; sw_out_tm[310]=2'd1; sw_out_tm[311]=2'd1;
      sw_out_tm[312]=2'd2; sw_out_tm[313]=2'd2; sw_out_tm[314]=2'd1;
      sw_out_tm[315]=2'd1; sw_out_tm[316]=2'd2; sw_out_tm[317]=2'd1;
      sw_out_tm[318]=2'd2; sw_out_tm[319]=2'd1; sw_out_tm[320]=2'd2;
      sw_out_tm[321]=2'd1; sw_out_tm[322]=2'd2; sw_out_tm[323]=2'd1;
      sw_out_tm[324]=2'd1; sw_out_tm[325]=2'd2; sw_out_tm[326]=2'd1;
      sw_out_tm[327]=2'd1; sw_out_tm[328]=2'd2; sw_out_tm[329]=2'd1;
      sw_out_tm[330]=2'd1; sw_out_tm[331]=2'd1; sw_out_tm[332]=2'd1;
      sw_out_tm[333]=2'd1; sw_out_tm[334]=2'd2; sw_out_tm[335]=2'd2;
      sw_out_tm[336]=2'd2; sw_out_tm[337]=2'd1; sw_out_tm[338]=2'd1;
      sw_out_tm[339]=2'd1; sw_out_tm[340]=2'd1; sw_out_tm[341]=2'd1;
      sw_out_tm[342]=2'd1; sw_out_tm[343]=2'd1; sw_out_tm[344]=2'd1;
      sw_out_tm[345]=2'd1; sw_out_tm[346]=2'd2; sw_out_tm[347]=2'd2;
      sw_out_tm[348]=2'd2; sw_out_tm[349]=2'd1; sw_out_tm[350]=2'd1;
      sw_out_tm[351]=2'd1; sw_out_tm[352]=2'd1; sw_out_tm[353]=2'd1;
      sw_out_tm[354]=2'd2; sw_out_tm[355]=2'd1; sw_out_tm[356]=2'd1;
      sw_out_tm[357]=2'd3; sw_out_tm[358]=2'd1; sw_out_tm[359]=2'd1;
      sw_out_tm[360]=2'd1; sw_out_tm[361]=2'd1; sw_out_tm[362]=2'd2;
      sw_out_tm[363]=2'd1; sw_out_tm[364]=2'd2; sw_out_tm[365]=2'd2;
      sw_out_tm[366]=2'd2; sw_out_tm[367]=2'd1; sw_out_tm[368]=2'd2;
      sw_out_tm[369]=2'd2; sw_out_tm[370]=2'd1; sw_out_tm[371]=2'd1;
      sw_out_tm[372]=2'd1; sw_out_tm[373]=2'd1; sw_out_tm[374]=2'd2;
      sw_out_tm[375]=2'd1; sw_out_tm[376]=2'd2; sw_out_tm[377]=2'd2;
      sw_out_tm[378]=2'd1; sw_out_tm[379]=2'd2; sw_out_tm[380]=2'd1;
      sw_out_tm[381]=2'd1; sw_out_tm[382]=2'd1; sw_out_tm[383]=2'd1;
      sw_out_tm[384]=2'd1; sw_out_tm[385]=2'd2; sw_out_tm[386]=2'd1;
      sw_out_tm[387]=2'd1; sw_out_tm[388]=2'd1; sw_out_tm[389]=2'd1;
      sw_out_tm[390]=2'd1; sw_out_tm[391]=2'd2; sw_out_tm[392]=2'd1;
      sw_out_tm[393]=2'd1; sw_out_tm[394]=2'd2; sw_out_tm[395]=2'd2;
      sw_out_tm[396]=2'd2; sw_out_tm[397]=2'd1; sw_out_tm[398]=2'd2;
      sw_out_tm[399]=2'd1; sw_out_tm[400]=2'd1; sw_out_tm[401]=2'd2;
      sw_out_tm[402]=2'd1; sw_out_tm[403]=2'd2; sw_out_tm[404]=2'd2;
      sw_out_tm[405]=2'd1; sw_out_tm[406]=2'd2; sw_out_tm[407]=2'd1;
      sw_out_tm[408]=2'd2; sw_out_tm[409]=2'd1; sw_out_tm[410]=2'd1;
      sw_out_tm[411]=2'd1; sw_out_tm[412]=2'd1; sw_out_tm[413]=2'd1;
      sw_out_tm[414]=2'd1; sw_out_tm[415]=2'd3; sw_out_tm[416]=2'd1;
      sw_out_tm[417]=2'd1; sw_out_tm[418]=2'd1; sw_out_tm[419]=2'd1;
      sw_out_tm[420]=2'd2; sw_out_tm[421]=2'd1; sw_out_tm[422]=2'd2;
      sw_out_tm[423]=2'd2; sw_out_tm[424]=2'd2; sw_out_tm[425]=2'd1;
      sw_out_tm[426]=2'd1; sw_out_tm[427]=2'd1; sw_out_tm[428]=2'd1;
      sw_out_tm[429]=2'd1; sw_out_tm[430]=2'd1; sw_out_tm[431]=2'd2;
      sw_out_tm[432]=2'd1; sw_out_tm[433]=2'd1; sw_out_tm[434]=2'd1;
      sw_out_tm[435]=2'd1; sw_out_tm[436]=2'd2; sw_out_tm[437]=2'd1;
      sw_out_tm[438]=2'd2; sw_out_tm[439]=2'd2; sw_out_tm[440]=2'd1;
      sw_out_tm[441]=2'd3; sw_out_tm[442]=2'd1; sw_out_tm[443]=2'd1;
      sw_out_tm[444]=2'd1; sw_out_tm[445]=2'd1; sw_out_tm[446]=2'd1;
      sw_out_tm[447]=2'd2; sw_out_tm[448]=2'd1; sw_out_tm[449]=2'd1;
      sw_out_tm[450]=2'd1; sw_out_tm[451]=2'd1; sw_out_tm[452]=2'd2;
      sw_out_tm[453]=2'd2; sw_out_tm[454]=2'd1; sw_out_tm[455]=2'd1;
      sw_out_tm[456]=2'd2; sw_out_tm[457]=2'd1; sw_out_tm[458]=2'd1;
      sw_out_tm[459]=2'd2; sw_out_tm[460]=2'd1; sw_out_tm[461]=2'd3;
      sw_out_tm[462]=2'd2; sw_out_tm[463]=2'd2; sw_out_tm[464]=2'd2;
      sw_out_tm[465]=2'd1; sw_out_tm[466]=2'd2; sw_out_tm[467]=2'd1;
      sw_out_tm[468]=2'd2; sw_out_tm[469]=2'd3; sw_out_tm[470]=2'd2;
      sw_out_tm[471]=2'd1; sw_out_tm[472]=2'd1; sw_out_tm[473]=2'd1;
      sw_out_tm[474]=2'd1; sw_out_tm[475]=2'd2; sw_out_tm[476]=2'd1;
      sw_out_tm[477]=2'd1; sw_out_tm[478]=2'd2; sw_out_tm[479]=2'd1;
      sw_out_tm[480]=2'd1; sw_out_tm[481]=2'd2; sw_out_tm[482]=2'd1;
      sw_out_tm[483]=2'd1; sw_out_tm[484]=2'd1; sw_out_tm[485]=2'd2;
      sw_out_tm[486]=2'd2; sw_out_tm[487]=2'd1; sw_out_tm[488]=2'd1;
      sw_out_tm[489]=2'd2; sw_out_tm[490]=2'd2; sw_out_tm[491]=2'd1;
      sw_out_tm[492]=2'd1; sw_out_tm[493]=2'd1; sw_out_tm[494]=2'd2;
      sw_out_tm[495]=2'd3; sw_out_tm[496]=2'd2; sw_out_tm[497]=2'd1;
      sw_out_tm[498]=2'd1; sw_out_tm[499]=2'd1; sw_out_tm[500]=2'd2;
      sw_out_tm[501]=2'd1; sw_out_tm[502]=2'd2; sw_out_tm[503]=2'd2;
      sw_out_tm[504]=2'd2; sw_out_tm[505]=2'd1; sw_out_tm[506]=2'd2;
      sw_out_tm[507]=2'd1; sw_out_tm[508]=2'd2; sw_out_tm[509]=2'd2;
      sw_out_tm[510]=2'd1; sw_out_tm[511]=2'd1; sw_out_tm[512]=2'd1;
      sw_out_tm[513]=2'd1; sw_out_tm[514]=2'd2; sw_out_tm[515]=2'd2;
      sw_out_tm[516]=2'd1; sw_out_tm[517]=2'd1; sw_out_tm[518]=2'd2;
      sw_out_tm[519]=2'd1; sw_out_tm[520]=2'd1; sw_out_tm[521]=2'd3;
      sw_out_tm[522]=2'd2; sw_out_tm[523]=2'd1; sw_out_tm[524]=2'd2;
      sw_out_tm[525]=2'd1; sw_out_tm[526]=2'd2; sw_out_tm[527]=2'd2;
      sw_out_tm[528]=2'd1; sw_out_tm[529]=2'd1; sw_out_tm[530]=2'd1;
      sw_out_tm[531]=2'd1; sw_out_tm[532]=2'd1; sw_out_tm[533]=2'd1;
      sw_out_tm[534]=2'd2; sw_out_tm[535]=2'd2; sw_out_tm[536]=2'd1;
      sw_out_tm[537]=2'd1; sw_out_tm[538]=2'd2; sw_out_tm[539]=2'd2;
      sw_out_tm[540]=2'd1; sw_out_tm[541]=2'd1; sw_out_tm[542]=2'd2;
      sw_out_tm[543]=2'd1; sw_out_tm[544]=2'd1; sw_out_tm[545]=2'd1;
      sw_out_tm[546]=2'd1; sw_out_tm[547]=2'd2; sw_out_tm[548]=2'd2;
      sw_out_tm[549]=2'd2; sw_out_tm[550]=2'd1; sw_out_tm[551]=2'd1;
      sw_out_tm[552]=2'd1; sw_out_tm[553]=2'd2; sw_out_tm[554]=2'd2;
      sw_out_tm[555]=2'd1; sw_out_tm[556]=2'd1; sw_out_tm[557]=2'd2;
      sw_out_tm[558]=2'd1; sw_out_tm[559]=2'd2; sw_out_tm[560]=2'd1;
      sw_out_tm[561]=2'd1; sw_out_tm[562]=2'd2; sw_out_tm[563]=2'd1;
      sw_out_tm[564]=2'd1; sw_out_tm[565]=2'd1; sw_out_tm[566]=2'd2;
      sw_out_tm[567]=2'd1; sw_out_tm[568]=2'd1; sw_out_tm[569]=2'd1;
      sw_out_tm[570]=2'd2; sw_out_tm[571]=2'd2; sw_out_tm[572]=2'd1;
      sw_out_tm[573]=2'd1; sw_out_tm[574]=2'd1; sw_out_tm[575]=2'd1;
      sw_out_tm[576]=2'd2; sw_out_tm[577]=2'd1; sw_out_tm[578]=2'd2;
      sw_out_tm[579]=2'd2; sw_out_tm[580]=2'd1; sw_out_tm[581]=2'd1;
      sw_out_tm[582]=2'd1; sw_out_tm[583]=2'd2; sw_out_tm[584]=2'd1;
      sw_out_tm[585]=2'd1; sw_out_tm[586]=2'd1; sw_out_tm[587]=2'd1;
      sw_out_tm[588]=2'd2; sw_out_tm[589]=2'd1; sw_out_tm[590]=2'd2;
      sw_out_tm[591]=2'd2; sw_out_tm[592]=2'd1; sw_out_tm[593]=2'd1;
      sw_out_tm[594]=2'd1; sw_out_tm[595]=2'd1; sw_out_tm[596]=2'd2;
      sw_out_tm[597]=2'd1; sw_out_tm[598]=2'd1; sw_out_tm[599]=2'd3;
      sw_out_tm[600]=2'd2; sw_out_tm[601]=2'd1; sw_out_tm[602]=2'd1;
      sw_out_tm[603]=2'd1; sw_out_tm[604]=2'd2; sw_out_tm[605]=2'd1;
      sw_out_tm[606]=2'd2; sw_out_tm[607]=2'd2; sw_out_tm[608]=2'd2;
      sw_out_tm[609]=2'd1; sw_out_tm[610]=2'd2; sw_out_tm[611]=2'd1;
      sw_out_tm[612]=2'd2; sw_out_tm[613]=2'd2; sw_out_tm[614]=2'd1;
      sw_out_tm[615]=2'd1; sw_out_tm[616]=2'd1; sw_out_tm[617]=2'd1;
      sw_out_tm[618]=2'd2; sw_out_tm[619]=2'd3; sw_out_tm[620]=2'd2;
      sw_out_tm[621]=2'd1; sw_out_tm[622]=2'd1; sw_out_tm[623]=2'd1;
      sw_out_tm[624]=2'd2; sw_out_tm[625]=2'd1; sw_out_tm[626]=2'd1;
      sw_out_tm[627]=2'd2; sw_out_tm[628]=2'd1; sw_out_tm[629]=2'd1;
      sw_out_tm[630]=2'd2; sw_out_tm[631]=2'd2; sw_out_tm[632]=2'd2;
      sw_out_tm[633]=2'd1; sw_out_tm[634]=2'd1; sw_out_tm[635]=2'd3;
      sw_out_tm[636]=2'd1; sw_out_tm[637]=2'd1; sw_out_tm[638]=2'd2;
      sw_out_tm[639]=2'd1; sw_out_tm[640]=2'd1; sw_out_tm[641]=2'd2;
      sw_out_tm[642]=2'd1; sw_out_tm[643]=2'd2; sw_out_tm[644]=2'd1;
      sw_out_tm[645]=2'd1; sw_out_tm[646]=2'd2; sw_out_tm[647]=2'd2;
      sw_out_tm[648]=2'd2; sw_out_tm[649]=2'd1; sw_out_tm[650]=2'd1;
      sw_out_tm[651]=2'd1; sw_out_tm[652]=2'd1; sw_out_tm[653]=2'd3;
      sw_out_tm[654]=2'd2; sw_out_tm[655]=2'd2; sw_out_tm[656]=2'd1;
      sw_out_tm[657]=2'd1; sw_out_tm[658]=2'd1; sw_out_tm[659]=2'd1;
      sw_out_tm[660]=2'd1; sw_out_tm[661]=2'd1; sw_out_tm[662]=2'd1;
      sw_out_tm[663]=2'd2; sw_out_tm[664]=2'd1; sw_out_tm[665]=2'd1;
      sw_out_tm[666]=2'd1; sw_out_tm[667]=2'd2; sw_out_tm[668]=2'd1;
      sw_out_tm[669]=2'd1; sw_out_tm[670]=2'd1; sw_out_tm[671]=2'd1;
      sw_out_tm[672]=2'd1; sw_out_tm[673]=2'd3; sw_out_tm[674]=2'd1;
      sw_out_tm[675]=2'd1; sw_out_tm[676]=2'd1; sw_out_tm[677]=2'd2;
      sw_out_tm[678]=2'd2; sw_out_tm[679]=2'd3; sw_out_tm[680]=2'd1;
      sw_out_tm[681]=2'd1; sw_out_tm[682]=2'd2; sw_out_tm[683]=2'd1;
      sw_out_tm[684]=2'd2; sw_out_tm[685]=2'd2; sw_out_tm[686]=2'd2;
      sw_out_tm[687]=2'd1; sw_out_tm[688]=2'd2; sw_out_tm[689]=2'd1;
      sw_out_tm[690]=2'd2; sw_out_tm[691]=2'd2; sw_out_tm[692]=2'd1;
      sw_out_tm[693]=2'd1; sw_out_tm[694]=2'd2; sw_out_tm[695]=2'd1;
      sw_out_tm[696]=2'd1; sw_out_tm[697]=2'd2; sw_out_tm[698]=2'd2;
      sw_out_tm[699]=2'd1; sw_out_tm[700]=2'd1; sw_out_tm[701]=2'd1;
      sw_out_tm[702]=2'd2; sw_out_tm[703]=2'd2; sw_out_tm[704]=2'd1;
      sw_out_tm[705]=2'd1; sw_out_tm[706]=2'd1; sw_out_tm[707]=2'd1;
      sw_out_tm[708]=2'd1; sw_out_tm[709]=2'd2; sw_out_tm[710]=2'd2;
      sw_out_tm[711]=2'd1; sw_out_tm[712]=2'd2; sw_out_tm[713]=2'd1;
      sw_out_tm[714]=2'd1; sw_out_tm[715]=2'd1; sw_out_tm[716]=2'd1;
      sw_out_tm[717]=2'd1; sw_out_tm[718]=2'd2; sw_out_tm[719]=2'd1;
      sw_out_tm[720]=2'd2; sw_out_tm[721]=2'd3; sw_out_tm[722]=2'd2;
      sw_out_tm[723]=2'd1; sw_out_tm[724]=2'd2; sw_out_tm[725]=2'd1;
      sw_out_tm[726]=2'd2; sw_out_tm[727]=2'd2; sw_out_tm[728]=2'd1;
      sw_out_tm[729]=2'd1; sw_out_tm[730]=2'd2; sw_out_tm[731]=2'd1;
      sw_out_tm[732]=2'd1; sw_out_tm[733]=2'd3; sw_out_tm[734]=2'd2;
      sw_out_tm[735]=2'd1; sw_out_tm[736]=2'd2; sw_out_tm[737]=2'd2;
      sw_out_tm[738]=2'd1; sw_out_tm[739]=2'd1; sw_out_tm[740]=2'd2;
      sw_out_tm[741]=2'd2; sw_out_tm[742]=2'd2; sw_out_tm[743]=2'd1;
      sw_out_tm[744]=2'd1; sw_out_tm[745]=2'd1; sw_out_tm[746]=2'd2;
      sw_out_tm[747]=2'd1; sw_out_tm[748]=2'd2; sw_out_tm[749]=2'd3;
      sw_out_tm[750]=2'd2; sw_out_tm[751]=2'd1; sw_out_tm[752]=2'd1;
      sw_out_tm[753]=2'd1; sw_out_tm[754]=2'd1; sw_out_tm[755]=2'd1;
      sw_out_tm[756]=2'd1; sw_out_tm[757]=2'd2; sw_out_tm[758]=2'd1;
      sw_out_tm[759]=2'd3; sw_out_tm[760]=2'd1; sw_out_tm[761]=2'd1;
      sw_out_tm[762]=2'd2; sw_out_tm[763]=2'd1; sw_out_tm[764]=2'd2;
      sw_out_tm[765]=2'd1; sw_out_tm[766]=2'd2; sw_out_tm[767]=2'd2;
      sw_out_tm[768]=2'd1; sw_out_tm[769]=2'd1; sw_out_tm[770]=2'd1;
      sw_out_tm[771]=2'd1; sw_out_tm[772]=2'd2; sw_out_tm[773]=2'd2;
      sw_out_tm[774]=2'd1; sw_out_tm[775]=2'd1; sw_out_tm[776]=2'd1;
      sw_out_tm[777]=2'd1; sw_out_tm[778]=2'd1; sw_out_tm[779]=2'd2;
      sw_out_tm[780]=2'd2; sw_out_tm[781]=2'd3; sw_out_tm[782]=2'd1;
      sw_out_tm[783]=2'd1; sw_out_tm[784]=2'd1; sw_out_tm[785]=2'd1;
      sw_out_tm[786]=2'd1; sw_out_tm[787]=2'd1; sw_out_tm[788]=2'd1;
      sw_out_tm[789]=2'd2; sw_out_tm[790]=2'd1; sw_out_tm[791]=2'd1;
      sw_out_tm[792]=2'd2; sw_out_tm[793]=2'd2; sw_out_tm[794]=2'd1;
      sw_out_tm[795]=2'd1; sw_out_tm[796]=2'd2; sw_out_tm[797]=2'd1;
      sw_out_tm[798]=2'd1; sw_out_tm[799]=2'd1; sw_out_tm[800]=2'd1;
      sw_out_tm[801]=2'd2; sw_out_tm[802]=2'd1; sw_out_tm[803]=2'd1;
      sw_out_tm[804]=2'd2; sw_out_tm[805]=2'd1; sw_out_tm[806]=2'd1;
      sw_out_tm[807]=2'd1; sw_out_tm[808]=2'd1; sw_out_tm[809]=2'd2;
      sw_out_tm[810]=2'd1; sw_out_tm[811]=2'd1; sw_out_tm[812]=2'd1;
      sw_out_tm[813]=2'd1; sw_out_tm[814]=2'd2; sw_out_tm[815]=2'd2;
      sw_out_tm[816]=2'd2; sw_out_tm[817]=2'd1; sw_out_tm[818]=2'd1;
      sw_out_tm[819]=2'd1; sw_out_tm[820]=2'd2; sw_out_tm[821]=2'd1;
      sw_out_tm[822]=2'd1; sw_out_tm[823]=2'd2; sw_out_tm[824]=2'd1;
      sw_out_tm[825]=2'd1; sw_out_tm[826]=2'd1; sw_out_tm[827]=2'd2;
      sw_out_tm[828]=2'd2; sw_out_tm[829]=2'd1; sw_out_tm[830]=2'd1;
      sw_out_tm[831]=2'd2; sw_out_tm[832]=2'd1; sw_out_tm[833]=2'd1;
      sw_out_tm[834]=2'd2; sw_out_tm[835]=2'd2; sw_out_tm[836]=2'd2;
      sw_out_tm[837]=2'd2; sw_out_tm[838]=2'd1; sw_out_tm[839]=2'd1;
      sw_out_tm[840]=2'd1; sw_out_tm[841]=2'd2; sw_out_tm[842]=2'd2;
      sw_out_tm[843]=2'd1; sw_out_tm[844]=2'd1; sw_out_tm[845]=2'd2;
      sw_out_tm[846]=2'd2; sw_out_tm[847]=2'd1; sw_out_tm[848]=2'd2;
      sw_out_tm[849]=2'd1; sw_out_tm[850]=2'd1; sw_out_tm[851]=2'd3;
      sw_out_tm[852]=2'd2; sw_out_tm[853]=2'd1; sw_out_tm[854]=2'd1;
      sw_out_tm[855]=2'd1; sw_out_tm[856]=2'd1; sw_out_tm[857]=2'd1;
      sw_out_tm[858]=2'd1; sw_out_tm[859]=2'd2; sw_out_tm[860]=2'd1;
      sw_out_tm[861]=2'd2; sw_out_tm[862]=2'd2; sw_out_tm[863]=2'd1;
      sw_out_tm[864]=2'd1; sw_out_tm[865]=2'd1; sw_out_tm[866]=2'd2;
      sw_out_tm[867]=2'd1; sw_out_tm[868]=2'd1; sw_out_tm[869]=2'd2;
      sw_out_tm[870]=2'd1; sw_out_tm[871]=2'd1; sw_out_tm[872]=2'd2;
      sw_out_tm[873]=2'd2; sw_out_tm[874]=2'd1; sw_out_tm[875]=2'd1;
      sw_out_tm[876]=2'd1; sw_out_tm[877]=2'd1; sw_out_tm[878]=2'd2;
      sw_out_tm[879]=2'd2; sw_out_tm[880]=2'd1; sw_out_tm[881]=2'd1;
      sw_out_tm[882]=2'd1; sw_out_tm[883]=2'd1; sw_out_tm[884]=2'd1;
      sw_out_tm[885]=2'd2; sw_out_tm[886]=2'd1; sw_out_tm[887]=2'd3;
      sw_out_tm[888]=2'd2; sw_out_tm[889]=2'd1; sw_out_tm[890]=2'd2;
      sw_out_tm[891]=2'd1; sw_out_tm[892]=2'd2; sw_out_tm[893]=2'd2;
      sw_out_tm[894]=2'd1; sw_out_tm[895]=2'd1; sw_out_tm[896]=2'd1;
      sw_out_tm[897]=2'd1; sw_out_tm[898]=2'd2; sw_out_tm[899]=2'd1;
      sw_out_tm[900]=2'd1; sw_out_tm[901]=2'd3; sw_out_tm[902]=2'd1;
      sw_out_tm[903]=2'd1; sw_out_tm[904]=2'd2; sw_out_tm[905]=2'd2;
      sw_out_tm[906]=2'd1; sw_out_tm[907]=2'd1; sw_out_tm[908]=2'd2;
      sw_out_tm[909]=2'd1; sw_out_tm[910]=2'd1; sw_out_tm[911]=2'd1;
      sw_out_tm[912]=2'd1; sw_out_tm[913]=2'd2; sw_out_tm[914]=2'd1;
      sw_out_tm[915]=2'd1; sw_out_tm[916]=2'd2; sw_out_tm[917]=2'd1;
      sw_out_tm[918]=2'd1; sw_out_tm[919]=2'd1; sw_out_tm[920]=2'd1;
      sw_out_tm[921]=2'd3; sw_out_tm[922]=2'd2; sw_out_tm[923]=2'd2;
      sw_out_tm[924]=2'd1; sw_out_tm[925]=2'd1; sw_out_tm[926]=2'd1;
      sw_out_tm[927]=2'd1; sw_out_tm[928]=2'd1; sw_out_tm[929]=2'd1;
      sw_out_tm[930]=2'd1; sw_out_tm[931]=2'd2; sw_out_tm[932]=2'd1;
      sw_out_tm[933]=2'd3; sw_out_tm[934]=2'd1; sw_out_tm[935]=2'd1;
      sw_out_tm[936]=2'd1; sw_out_tm[937]=2'd1; sw_out_tm[938]=2'd1;
      sw_out_tm[939]=2'd1; sw_out_tm[940]=2'd1; sw_out_tm[941]=2'd2;
      sw_out_tm[942]=2'd2; sw_out_tm[943]=2'd1; sw_out_tm[944]=2'd2;
      sw_out_tm[945]=2'd1; sw_out_tm[946]=2'd2; sw_out_tm[947]=2'd2;
      sw_out_tm[948]=2'd1; sw_out_tm[949]=2'd1; sw_out_tm[950]=2'd1;
      sw_out_tm[951]=2'd1; sw_out_tm[952]=2'd2; sw_out_tm[953]=2'd2;
      sw_out_tm[954]=2'd1; sw_out_tm[955]=2'd1; sw_out_tm[956]=2'd2;
      sw_out_tm[957]=2'd1; sw_out_tm[958]=2'd1; sw_out_tm[959]=2'd2;
      sw_out_tm[960]=2'd1; sw_out_tm[961]=2'd1; sw_out_tm[962]=2'd1;
      sw_out_tm[963]=2'd1; sw_out_tm[964]=2'd1; sw_out_tm[965]=2'd3;
      sw_out_tm[966]=2'd2; sw_out_tm[967]=2'd1; sw_out_tm[968]=2'd1;
      sw_out_tm[969]=2'd1; sw_out_tm[970]=2'd2; sw_out_tm[971]=2'd1;
      sw_out_tm[972]=2'd2; sw_out_tm[973]=2'd2; sw_out_tm[974]=2'd2;
      sw_out_tm[975]=2'd1; sw_out_tm[976]=2'd2; sw_out_tm[977]=2'd1;
      sw_out_tm[978]=2'd2; sw_out_tm[979]=2'd2; sw_out_tm[980]=2'd1;
      sw_out_tm[981]=2'd1; sw_out_tm[982]=2'd1; sw_out_tm[983]=2'd1;
      sw_out_tm[984]=2'd2; sw_out_tm[985]=2'd3; sw_out_tm[986]=2'd1;
      sw_out_tm[987]=2'd1; sw_out_tm[988]=2'd1; sw_out_tm[989]=2'd1;
      sw_out_tm[990]=2'd1; sw_out_tm[991]=2'd1; sw_out_tm[992]=2'd1;
      sw_out_tm[993]=2'd2; sw_out_tm[994]=2'd1; sw_out_tm[995]=2'd1;
      sw_out_tm[996]=2'd2; sw_out_tm[997]=2'd2; sw_out_tm[998]=2'd1;
      sw_out_tm[999]=2'd1; sw_out_tm[1000]=2'd1; sw_out_tm[1001]=2'd1;
      sw_out_tm[1002]=2'd1; sw_out_tm[1003]=2'd1; sw_out_tm[1004]=2'd2;
      sw_out_tm[1005]=2'd2; sw_out_tm[1006]=2'd1; sw_out_tm[1007]=2'd3;
      sw_out_tm[1008]=2'd1; sw_out_tm[1009]=2'd1; sw_out_tm[1010]=2'd2;
      sw_out_tm[1011]=2'd1; sw_out_tm[1012]=2'd2; sw_out_tm[1013]=2'd2;
      sw_out_tm[1014]=2'd2; sw_out_tm[1015]=2'd1; sw_out_tm[1016]=2'd2;
      sw_out_tm[1017]=2'd1; sw_out_tm[1018]=2'd2; sw_out_tm[1019]=2'd2;
      sw_out_tm[1020]=2'd1; sw_out_tm[1021]=2'd1; sw_out_tm[1022]=2'd2;
      sw_out_tm[1023]=2'd1; sw_out_tm[1024]=2'd1; sw_out_tm[1025]=2'd2;
      sw_out_tm[1026]=2'd2; sw_out_tm[1027]=2'd1; sw_out_tm[1028]=2'd1;
      sw_out_tm[1029]=2'd1; sw_out_tm[1030]=2'd2; sw_out_tm[1031]=2'd2;
      sw_out_tm[1032]=2'd1; sw_out_tm[1033]=2'd2; sw_out_tm[1034]=2'd2;
      sw_out_tm[1035]=2'd1; sw_out_tm[1036]=2'd1; sw_out_tm[1037]=2'd1;
      sw_out_tm[1038]=2'd1; sw_out_tm[1039]=2'd3; sw_out_tm[1040]=2'd2;
      sw_out_tm[1041]=2'd1; sw_out_tm[1042]=2'd2; sw_out_tm[1043]=2'd1;
      sw_out_tm[1044]=2'd2; sw_out_tm[1045]=2'd2; sw_out_tm[1046]=2'd2;
      sw_out_tm[1047]=2'd1; sw_out_tm[1048]=2'd1; sw_out_tm[1049]=2'd3;
      sw_out_tm[1050]=2'd2; sw_out_tm[1051]=2'd2; sw_out_tm[1052]=2'd1;
      sw_out_tm[1053]=2'd1; sw_out_tm[1054]=2'd1; sw_out_tm[1055]=2'd1;
      sw_out_tm[1056]=2'd1; sw_out_tm[1057]=2'd1; sw_out_tm[1058]=2'd1;
      sw_out_tm[1059]=2'd2; sw_out_tm[1060]=2'd1; sw_out_tm[1061]=2'd1;
      sw_out_tm[1062]=2'd1; sw_out_tm[1063]=2'd2; sw_out_tm[1064]=2'd1;
      sw_out_tm[1065]=2'd1; sw_out_tm[1066]=2'd1; sw_out_tm[1067]=2'd1;
      sw_out_tm[1068]=2'd1; sw_out_tm[1069]=2'd3; sw_out_tm[1070]=2'd1;
      sw_out_tm[1071]=2'd1; sw_out_tm[1072]=2'd2; sw_out_tm[1073]=2'd1;
      sw_out_tm[1074]=2'd2; sw_out_tm[1075]=2'd1; sw_out_tm[1076]=2'd1;
      sw_out_tm[1077]=2'd2; sw_out_tm[1078]=2'd1; sw_out_tm[1079]=2'd1;
      sw_out_tm[1080]=2'd2; sw_out_tm[1081]=2'd1; sw_out_tm[1082]=2'd1;
      sw_out_tm[1083]=2'd2; sw_out_tm[1084]=2'd2; sw_out_tm[1085]=2'd1;
      sw_out_tm[1086]=2'd2; sw_out_tm[1087]=2'd1; sw_out_tm[1088]=2'd2;
      sw_out_tm[1089]=2'd2; sw_out_tm[1090]=2'd1; sw_out_tm[1091]=2'd1;
      sw_out_tm[1092]=2'd2; sw_out_tm[1093]=2'd1; sw_out_tm[1094]=2'd2;
      sw_out_tm[1095]=2'd1; sw_out_tm[1096]=2'd2; sw_out_tm[1097]=2'd2;
      sw_out_tm[1098]=2'd1; sw_out_tm[1099]=2'd2; sw_out_tm[1100]=2'd2;
      sw_out_tm[1101]=2'd1; sw_out_tm[1102]=2'd1; sw_out_tm[1103]=2'd1;
      sw_out_tm[1104]=2'd2; sw_out_tm[1105]=2'd1; sw_out_tm[1106]=2'd1;
      sw_out_tm[1107]=2'd2; sw_out_tm[1108]=2'd2; sw_out_tm[1109]=2'd2;
      sw_out_tm[1110]=2'd1; sw_out_tm[1111]=2'd1; sw_out_tm[1112]=2'd2;
      sw_out_tm[1113]=2'd1; sw_out_tm[1114]=2'd1; sw_out_tm[1115]=2'd1;
      sw_out_tm[1116]=2'd2; sw_out_tm[1117]=2'd1; sw_out_tm[1118]=2'd1;
      sw_out_tm[1119]=2'd1; sw_out_tm[1120]=2'd2; sw_out_tm[1121]=2'd3;
      sw_out_tm[1122]=2'd1; sw_out_tm[1123]=2'd1; sw_out_tm[1124]=2'd1;
      sw_out_tm[1125]=2'd1; sw_out_tm[1126]=2'd2; sw_out_tm[1127]=2'd1;
      sw_out_tm[1128]=2'd2; sw_out_tm[1129]=2'd2; sw_out_tm[1130]=2'd1;
      sw_out_tm[1131]=2'd1; sw_out_tm[1132]=2'd1; sw_out_tm[1133]=2'd2;
      sw_out_tm[1134]=2'd1; sw_out_tm[1135]=2'd1; sw_out_tm[1136]=2'd1;
      sw_out_tm[1137]=2'd1; sw_out_tm[1138]=2'd2; sw_out_tm[1139]=2'd1;
      sw_out_tm[1140]=2'd2; sw_out_tm[1141]=2'd2; sw_out_tm[1142]=2'd1;
      sw_out_tm[1143]=2'd1; sw_out_tm[1144]=2'd1; sw_out_tm[1145]=2'd1;
      sw_out_tm[1146]=2'd2; sw_out_tm[1147]=2'd1; sw_out_tm[1148]=2'd1;
      sw_out_tm[1149]=2'd3; sw_out_tm[1150]=2'd1; sw_out_tm[1151]=2'd1;
      sw_out_tm[1152]=2'd1; sw_out_tm[1153]=2'd2; sw_out_tm[1154]=2'd2;
      sw_out_tm[1155]=2'd3; sw_out_tm[1156]=2'd1; sw_out_tm[1157]=2'd1;
      sw_out_tm[1158]=2'd1; sw_out_tm[1159]=2'd2; sw_out_tm[1160]=2'd1;
      sw_out_tm[1161]=2'd1; sw_out_tm[1162]=2'd1; sw_out_tm[1163]=2'd1;
      sw_out_tm[1164]=2'd1; sw_out_tm[1165]=2'd3; sw_out_tm[1166]=2'd1;
      sw_out_tm[1167]=2'd1; sw_out_tm[1168]=2'd2; sw_out_tm[1169]=2'd1;
      sw_out_tm[1170]=2'd2; sw_out_tm[1171]=2'd2; sw_out_tm[1172]=2'd2;
      sw_out_tm[1173]=2'd1; sw_out_tm[1174]=2'd2; sw_out_tm[1175]=2'd1;
      sw_out_tm[1176]=2'd2; sw_out_tm[1177]=2'd2; sw_out_tm[1178]=2'd1;
      sw_out_tm[1179]=2'd1; sw_out_tm[1180]=2'd2; sw_out_tm[1181]=2'd1;
      sw_out_tm[1182]=2'd1; sw_out_tm[1183]=2'd2; sw_out_tm[1184]=2'd2;
      sw_out_tm[1185]=2'd1; sw_out_tm[1186]=2'd1; sw_out_tm[1187]=2'd1;
      sw_out_tm[1188]=2'd2; sw_out_tm[1189]=2'd2; sw_out_tm[1190]=2'd1;
      sw_out_tm[1191]=2'd1; sw_out_tm[1192]=2'd1; sw_out_tm[1193]=2'd2;
      sw_out_tm[1194]=2'd2; sw_out_tm[1195]=2'd1; sw_out_tm[1196]=2'd1;
      sw_out_tm[1197]=2'd2; sw_out_tm[1198]=2'd2; sw_out_tm[1199]=2'd1;
      sw_out_tm[1200]=2'd2; sw_out_tm[1201]=2'd1; sw_out_tm[1202]=2'd1;
      sw_out_tm[1203]=2'd3; sw_out_tm[1204]=2'd2; sw_out_tm[1205]=2'd2;
      sw_out_tm[1206]=2'd1; sw_out_tm[1207]=2'd1; sw_out_tm[1208]=2'd1;
      sw_out_tm[1209]=2'd1; sw_out_tm[1210]=2'd1; sw_out_tm[1211]=2'd1;
      sw_out_tm[1212]=2'd1; sw_out_tm[1213]=2'd2; sw_out_tm[1214]=2'd1;
      sw_out_tm[1215]=2'd2; sw_out_tm[1216]=2'd2; sw_out_tm[1217]=2'd1;
      sw_out_tm[1218]=2'd1; sw_out_tm[1219]=2'd3; sw_out_tm[1220]=2'd1;
      sw_out_tm[1221]=2'd1; sw_out_tm[1222]=2'd1; sw_out_tm[1223]=2'd1;
      sw_out_tm[1224]=2'd2; sw_out_tm[1225]=2'd1; sw_out_tm[1226]=2'd2;
      sw_out_tm[1227]=2'd2; sw_out_tm[1228]=2'd2; sw_out_tm[1229]=2'd1;
      sw_out_tm[1230]=2'd1; sw_out_tm[1231]=2'd1; sw_out_tm[1232]=2'd2;
      sw_out_tm[1233]=2'd1; sw_out_tm[1234]=2'd1; sw_out_tm[1235]=2'd2;
      sw_out_tm[1236]=2'd2; sw_out_tm[1237]=2'd1; sw_out_tm[1238]=2'd2;
      sw_out_tm[1239]=2'd1; sw_out_tm[1240]=2'd2; sw_out_tm[1241]=2'd2;
      sw_out_tm[1242]=2'd2; sw_out_tm[1243]=2'd1; sw_out_tm[1244]=2'd1;
      sw_out_tm[1245]=2'd2; sw_out_tm[1246]=2'd2; sw_out_tm[1247]=2'd1;
      sw_out_tm[1248]=2'd2; sw_out_tm[1249]=2'd1; sw_out_tm[1250]=2'd1;
      sw_out_tm[1251]=2'd2; sw_out_tm[1252]=2'd1; sw_out_tm[1253]=2'd1;
      sw_out_tm[1254]=2'd2; sw_out_tm[1255]=2'd1; sw_out_tm[1256]=2'd1;
      sw_out_tm[1257]=2'd2; sw_out_tm[1258]=2'd1; sw_out_tm[1259]=2'd1;
      sw_out_tm[1260]=2'd2; sw_out_tm[1261]=2'd2; sw_out_tm[1262]=2'd2;
      sw_out_tm[1263]=2'd2; sw_out_tm[1264]=2'd1; sw_out_tm[1265]=2'd1;
      sw_out_tm[1266]=2'd1; sw_out_tm[1267]=2'd1; sw_out_tm[1268]=2'd2;
      sw_out_tm[1269]=2'd2; sw_out_tm[1270]=2'd1; sw_out_tm[1271]=2'd1;
      sw_out_tm[1272]=2'd2; sw_out_tm[1273]=2'd1; sw_out_tm[1274]=2'd1;
      sw_out_tm[1275]=2'd1; sw_out_tm[1276]=2'd1; sw_out_tm[1277]=2'd2;
      sw_out_tm[1278]=2'd1; sw_out_tm[1279]=2'd1; sw_out_tm[1280]=2'd2;
      sw_out_tm[1281]=2'd2; sw_out_tm[1282]=2'd2; sw_out_tm[1283]=2'd2;
      sw_out_tm[1284]=2'd1; sw_out_tm[1285]=2'd1; sw_out_tm[1286]=2'd1;
      sw_out_tm[1287]=2'd2; sw_out_tm[1288]=2'd2; sw_out_tm[1289]=2'd1;
      sw_out_tm[1290]=2'd2; sw_out_tm[1291]=2'd1; sw_out_tm[1292]=2'd2;
      sw_out_tm[1293]=2'd2; sw_out_tm[1294]=2'd2; sw_out_tm[1295]=2'd1;
      sw_out_tm[1296]=2'd1; sw_out_tm[1297]=2'd2; sw_out_tm[1298]=2'd1;
      sw_out_tm[1299]=2'd1; sw_out_tm[1300]=2'd1; sw_out_tm[1301]=2'd1;
      sw_out_tm[1302]=2'd1; sw_out_tm[1303]=2'd2; sw_out_tm[1304]=2'd1;
      sw_out_tm[1305]=2'd1; sw_out_tm[1306]=2'd2; sw_out_tm[1307]=2'd1;
      sw_out_tm[1308]=2'd1; sw_out_tm[1309]=2'd1; sw_out_tm[1310]=2'd2;
      sw_out_tm[1311]=2'd1; sw_out_tm[1312]=2'd1; sw_out_tm[1313]=2'd1;
      sw_out_tm[1314]=2'd2; sw_out_tm[1315]=2'd3; sw_out_tm[1316]=2'd1;
      sw_out_tm[1317]=2'd1; sw_out_tm[1318]=2'd1; sw_out_tm[1319]=2'd2;
      sw_out_tm[1320]=2'd1; sw_out_tm[1321]=2'd1; sw_out_tm[1322]=2'd1;
      sw_out_tm[1323]=2'd1; sw_out_tm[1324]=2'd2; sw_out_tm[1325]=2'd1;
      sw_out_tm[1326]=2'd2; sw_out_tm[1327]=2'd2; sw_out_tm[1328]=2'd1;
      sw_out_tm[1329]=2'd1; sw_out_tm[1330]=2'd1; sw_out_tm[1331]=2'd1;
      sw_out_tm[1332]=2'd2; sw_out_tm[1333]=2'd1; sw_out_tm[1334]=2'd1;
      sw_out_tm[1335]=2'd3; sw_out_tm[1336]=2'd2; sw_out_tm[1337]=2'd1;
      sw_out_tm[1338]=2'd1; sw_out_tm[1339]=2'd2; sw_out_tm[1340]=2'd2;
      sw_out_tm[1341]=2'd1; sw_out_tm[1342]=2'd2; sw_out_tm[1343]=2'd1;
      sw_out_tm[1344]=2'd2; sw_out_tm[1345]=2'd2; sw_out_tm[1346]=2'd2;
      sw_out_tm[1347]=2'd3; sw_out_tm[1348]=2'd2; sw_out_tm[1349]=2'd2;
      sw_out_tm[1350]=2'd1; sw_out_tm[1351]=2'd1; sw_out_tm[1352]=2'd1;
      sw_out_tm[1353]=2'd1; sw_out_tm[1354]=2'd1; sw_out_tm[1355]=2'd1;
      sw_out_tm[1356]=2'd1; sw_out_tm[1357]=2'd2; sw_out_tm[1358]=2'd1;
      sw_out_tm[1359]=2'd2; sw_out_tm[1360]=2'd2; sw_out_tm[1361]=2'd1;
      sw_out_tm[1362]=2'd1; sw_out_tm[1363]=2'd3; sw_out_tm[1364]=2'd1;
      sw_out_tm[1365]=2'd1; sw_out_tm[1366]=2'd2; sw_out_tm[1367]=2'd1;
      sw_out_tm[1368]=2'd2; sw_out_tm[1369]=2'd2; sw_out_tm[1370]=2'd1;
      sw_out_tm[1371]=2'd1; sw_out_tm[1372]=2'd2; sw_out_tm[1373]=2'd2;
      sw_out_tm[1374]=2'd2; sw_out_tm[1375]=2'd1; sw_out_tm[1376]=2'd1;
      sw_out_tm[1377]=2'd1; sw_out_tm[1378]=2'd2; sw_out_tm[1379]=2'd2;
      sw_out_tm[1380]=2'd1; sw_out_tm[1381]=2'd3; sw_out_tm[1382]=2'd1;
      sw_out_tm[1383]=2'd1; sw_out_tm[1384]=2'd1; sw_out_tm[1385]=2'd1;
      sw_out_tm[1386]=2'd2; sw_out_tm[1387]=2'd2; sw_out_tm[1388]=2'd1;
      sw_out_tm[1389]=2'd1; sw_out_tm[1390]=2'd2; sw_out_tm[1391]=2'd1;
      sw_out_tm[1392]=2'd2; sw_out_tm[1393]=2'd1; sw_out_tm[1394]=2'd1;
      sw_out_tm[1395]=2'd3; sw_out_tm[1396]=2'd1; sw_out_tm[1397]=2'd1;
      sw_out_tm[1398]=2'd2; sw_out_tm[1399]=2'd2; sw_out_tm[1400]=2'd2;
      sw_out_tm[1401]=2'd1; sw_out_tm[1402]=2'd1; sw_out_tm[1403]=2'd2;
      sw_out_tm[1404]=2'd2; sw_out_tm[1405]=2'd1; sw_out_tm[1406]=2'd1;
      sw_out_tm[1407]=2'd1; sw_out_tm[1408]=2'd1; sw_out_tm[1409]=2'd3;
      sw_out_tm[1410]=2'd2; sw_out_tm[1411]=2'd1; sw_out_tm[1412]=2'd2;
      sw_out_tm[1413]=2'd1; sw_out_tm[1414]=2'd1; sw_out_tm[1415]=2'd2;
      sw_out_tm[1416]=2'd1; sw_out_tm[1417]=2'd2; sw_out_tm[1418]=2'd2;
      sw_out_tm[1419]=2'd3; sw_out_tm[1420]=2'd2; sw_out_tm[1421]=2'd2;
      sw_out_tm[1422]=2'd2; sw_out_tm[1423]=2'd1; sw_out_tm[1424]=2'd2;
      sw_out_tm[1425]=2'd1; sw_out_tm[1426]=2'd2; sw_out_tm[1427]=2'd3;
      sw_out_tm[1428]=2'd1; sw_out_tm[1429]=2'd1; sw_out_tm[1430]=2'd2;
      sw_out_tm[1431]=2'd1; sw_out_tm[1432]=2'd2; sw_out_tm[1433]=2'd2;
      sw_out_tm[1434]=2'd2; sw_out_tm[1435]=2'd1; sw_out_tm[1436]=2'd2;
      sw_out_tm[1437]=2'd1; sw_out_tm[1438]=2'd2; sw_out_tm[1439]=2'd2;
      sw_out_tm[1440]=2'd1; sw_out_tm[1441]=2'd1; sw_out_tm[1442]=2'd2;
      sw_out_tm[1443]=2'd1; sw_out_tm[1444]=2'd1; sw_out_tm[1445]=2'd2;
      sw_out_tm[1446]=2'd2; sw_out_tm[1447]=2'd1; sw_out_tm[1448]=2'd1;
      sw_out_tm[1449]=2'd1; sw_out_tm[1450]=2'd2; sw_out_tm[1451]=2'd3;
      sw_out_tm[1452]=2'd2; sw_out_tm[1453]=2'd1; sw_out_tm[1454]=2'd1;
      sw_out_tm[1455]=2'd1; sw_out_tm[1456]=2'd1; sw_out_tm[1457]=2'd1;
      sw_out_tm[1458]=2'd1; sw_out_tm[1459]=2'd2; sw_out_tm[1460]=2'd1;
      sw_out_tm[1461]=2'd2; sw_out_tm[1462]=2'd1; sw_out_tm[1463]=2'd1;
      sw_out_tm[1464]=2'd1; sw_out_tm[1465]=2'd1; sw_out_tm[1466]=2'd2;
      sw_out_tm[1467]=2'd1; sw_out_tm[1468]=2'd1; sw_out_tm[1469]=2'd2;
      sw_out_tm[1470]=2'd2; sw_out_tm[1471]=2'd1; sw_out_tm[1472]=2'd2;
      sw_out_tm[1473]=2'd1; sw_out_tm[1474]=2'd2; sw_out_tm[1475]=2'd2;
      sw_out_tm[1476]=2'd1; sw_out_tm[1477]=2'd1; sw_out_tm[1478]=2'd2;
      sw_out_tm[1479]=2'd1; sw_out_tm[1480]=2'd1; sw_out_tm[1481]=2'd2;
      sw_out_tm[1482]=2'd1; sw_out_tm[1483]=2'd3; sw_out_tm[1484]=2'd1;
      sw_out_tm[1485]=2'd1; sw_out_tm[1486]=2'd1; sw_out_tm[1487]=2'd2;
      sw_out_tm[1488]=2'd2; sw_out_tm[1489]=2'd3; sw_out_tm[1490]=2'd1;
      sw_out_tm[1491]=2'd1; sw_out_tm[1492]=2'd1; sw_out_tm[1493]=2'd2;
      sw_out_tm[1494]=2'd1; sw_out_tm[1495]=2'd1; sw_out_tm[1496]=2'd1;
      sw_out_tm[1497]=2'd1; sw_out_tm[1498]=2'd1; sw_out_tm[1499]=2'd3;
      sw_out_tm[1500]=2'd2; sw_out_tm[1501]=2'd2; sw_out_tm[1502]=2'd2;
      sw_out_tm[1503]=2'd1; sw_out_tm[1504]=2'd2; sw_out_tm[1505]=2'd1;
      sw_out_tm[1506]=2'd2; sw_out_tm[1507]=2'd2; sw_out_tm[1508]=2'd2;
      sw_out_tm[1509]=2'd1; sw_out_tm[1510]=2'd2; sw_out_tm[1511]=2'd1;
      sw_out_tm[1512]=2'd2; sw_out_tm[1513]=2'd3; sw_out_tm[1514]=2'd1;
      sw_out_tm[1515]=2'd1; sw_out_tm[1516]=2'd2; sw_out_tm[1517]=2'd1;
      sw_out_tm[1518]=2'd1; sw_out_tm[1519]=2'd1; sw_out_tm[1520]=2'd1;
      sw_out_tm[1521]=2'd2; sw_out_tm[1522]=2'd1; sw_out_tm[1523]=2'd1;
      sw_out_tm[1524]=2'd2; sw_out_tm[1525]=2'd2; sw_out_tm[1526]=2'd2;
      sw_out_tm[1527]=2'd2; sw_out_tm[1528]=2'd1; sw_out_tm[1529]=2'd2;
      sw_out_tm[1530]=2'd1; sw_out_tm[1531]=2'd1; sw_out_tm[1532]=2'd2;
      sw_out_tm[1533]=2'd1; sw_out_tm[1534]=2'd1; sw_out_tm[1535]=2'd1;
      sw_out_tm[1536]=2'd2; sw_out_tm[1537]=2'd1; sw_out_tm[1538]=2'd1;
      sw_out_tm[1539]=2'd1; sw_out_tm[1540]=2'd2; sw_out_tm[1541]=2'd3;
      sw_out_tm[1542]=2'd1; sw_out_tm[1543]=2'd1; sw_out_tm[1544]=2'd1;
      sw_out_tm[1545]=2'd1; sw_out_tm[1546]=2'd2; sw_out_tm[1547]=2'd1;
      sw_out_tm[1548]=2'd2; sw_out_tm[1549]=2'd2; sw_out_tm[1550]=2'd2;
      sw_out_tm[1551]=2'd1; sw_out_tm[1552]=2'd1; sw_out_tm[1553]=2'd1;
      sw_out_tm[1554]=2'd2; sw_out_tm[1555]=2'd1; sw_out_tm[1556]=2'd1;
      sw_out_tm[1557]=2'd2; sw_out_tm[1558]=2'd1; sw_out_tm[1559]=2'd1;
      sw_out_tm[1560]=2'd1; sw_out_tm[1561]=2'd1; sw_out_tm[1562]=2'd2;
      sw_out_tm[1563]=2'd1; sw_out_tm[1564]=2'd2; sw_out_tm[1565]=2'd2;
      sw_out_tm[1566]=2'd1; sw_out_tm[1567]=2'd1; sw_out_tm[1568]=2'd1;
      sw_out_tm[1569]=2'd1; sw_out_tm[1570]=2'd1; sw_out_tm[1571]=2'd1;
      sw_out_tm[1572]=2'd1; sw_out_tm[1573]=2'd2; sw_out_tm[1574]=2'd1;
      sw_out_tm[1575]=2'd1; sw_out_tm[1576]=2'd2; sw_out_tm[1577]=2'd2;
      sw_out_tm[1578]=2'd2; sw_out_tm[1579]=2'd1; sw_out_tm[1580]=2'd1;
      sw_out_tm[1581]=2'd2; sw_out_tm[1582]=2'd2; sw_out_tm[1583]=2'd1;
      sw_out_tm[1584]=2'd2; sw_out_tm[1585]=2'd1; sw_out_tm[1586]=2'd1;
      sw_out_tm[1587]=2'd2; sw_out_tm[1588]=2'd1; sw_out_tm[1589]=2'd3;
      sw_out_tm[1590]=2'd2; sw_out_tm[1591]=2'd2; sw_out_tm[1592]=2'd1;
      sw_out_tm[1593]=2'd1; sw_out_tm[1594]=2'd1; sw_out_tm[1595]=2'd1;
      sw_out_tm[1596]=2'd1; sw_out_tm[1597]=2'd1; sw_out_tm[1598]=2'd1;
      sw_out_tm[1599]=2'd2; sw_out_tm[1600]=2'd1; sw_out_tm[1601]=2'd3;
      sw_out_tm[1602]=2'd1; sw_out_tm[1603]=2'd1; sw_out_tm[1604]=2'd1;
      sw_out_tm[1605]=2'd1; sw_out_tm[1606]=2'd1; sw_out_tm[1607]=2'd2;
      sw_out_tm[1608]=2'd1; sw_out_tm[1609]=2'd1; sw_out_tm[1610]=2'd2;
      sw_out_tm[1611]=2'd1; sw_out_tm[1612]=2'd2; sw_out_tm[1613]=2'd1;
      sw_out_tm[1614]=2'd1; sw_out_tm[1615]=2'd2; sw_out_tm[1616]=2'd1;
      sw_out_tm[1617]=2'd2; sw_out_tm[1618]=2'd1; sw_out_tm[1619]=2'd2;
      sw_out_tm[1620]=2'd2; sw_out_tm[1621]=2'd1; sw_out_tm[1622]=2'd1;
      sw_out_tm[1623]=2'd1; sw_out_tm[1624]=2'd1; sw_out_tm[1625]=2'd3;
      sw_out_tm[1626]=2'd2; sw_out_tm[1627]=2'd2; sw_out_tm[1628]=2'd2;
      sw_out_tm[1629]=2'd1; sw_out_tm[1630]=2'd2; sw_out_tm[1631]=2'd1;
      sw_out_tm[1632]=2'd2; sw_out_tm[1633]=2'd3; sw_out_tm[1634]=2'd1;
      sw_out_tm[1635]=2'd1; sw_out_tm[1636]=2'd1; sw_out_tm[1637]=2'd1;
      sw_out_tm[1638]=2'd1; sw_out_tm[1639]=2'd2; sw_out_tm[1640]=2'd1;
      sw_out_tm[1641]=2'd2; sw_out_tm[1642]=2'd1; sw_out_tm[1643]=2'd3;
      sw_out_tm[1644]=2'd1; sw_out_tm[1645]=2'd1; sw_out_tm[1646]=2'd1;
      sw_out_tm[1647]=2'd1; sw_out_tm[1648]=2'd1; sw_out_tm[1649]=2'd1;
      sw_out_tm[1650]=2'd1; sw_out_tm[1651]=2'd2; sw_out_tm[1652]=2'd2;
      sw_out_tm[1653]=2'd1; sw_out_tm[1654]=2'd2; sw_out_tm[1655]=2'd1;
      sw_out_tm[1656]=2'd2; sw_out_tm[1657]=2'd2; sw_out_tm[1658]=2'd1;
      sw_out_tm[1659]=2'd1; sw_out_tm[1660]=2'd2; sw_out_tm[1661]=2'd1;
      sw_out_tm[1662]=2'd2; sw_out_tm[1663]=2'd3; sw_out_tm[1664]=2'd1;
      sw_out_tm[1665]=2'd1; sw_out_tm[1666]=2'd2; sw_out_tm[1667]=2'd1;
      sw_out_tm[1668]=2'd1; sw_out_tm[1669]=2'd1; sw_out_tm[1670]=2'd1;
      sw_out_tm[1671]=2'd2; sw_out_tm[1672]=2'd2; sw_out_tm[1673]=2'd1;
      sw_out_tm[1674]=2'd2; sw_out_tm[1675]=2'd1; sw_out_tm[1676]=2'd2;
      sw_out_tm[1677]=2'd2; sw_out_tm[1678]=2'd2; sw_out_tm[1679]=2'd1;
      sw_out_tm[1680]=2'd1; sw_out_tm[1681]=2'd2; sw_out_tm[1682]=2'd2;
      sw_out_tm[1683]=2'd1; sw_out_tm[1684]=2'd2; sw_out_tm[1685]=2'd1;
      sw_out_tm[1686]=2'd1; sw_out_tm[1687]=2'd3; sw_out_tm[1688]=2'd1;
      sw_out_tm[1689]=2'd1; sw_out_tm[1690]=2'd1; sw_out_tm[1691]=2'd2;
      sw_out_tm[1692]=2'd2; sw_out_tm[1693]=2'd3; sw_out_tm[1694]=2'd2;
      sw_out_tm[1695]=2'd2; sw_out_tm[1696]=2'd1; sw_out_tm[1697]=2'd1;
      sw_out_tm[1698]=2'd2; sw_out_tm[1699]=2'd2; sw_out_tm[1700]=2'd2;
      sw_out_tm[1701]=2'd1; sw_out_tm[1702]=2'd1; sw_out_tm[1703]=2'd1;
      sw_out_tm[1704]=2'd2; sw_out_tm[1705]=2'd2; sw_out_tm[1706]=2'd1;
      sw_out_tm[1707]=2'd2; sw_out_tm[1708]=2'd1; sw_out_tm[1709]=2'd1;
      sw_out_tm[1710]=2'd1; sw_out_tm[1711]=2'd1; sw_out_tm[1712]=2'd1;
      sw_out_tm[1713]=2'd3; sw_out_tm[1714]=2'd2; sw_out_tm[1715]=2'd2;
      sw_out_tm[1716]=2'd2; sw_out_tm[1717]=2'd1; sw_out_tm[1718]=2'd2;
      sw_out_tm[1719]=2'd1; sw_out_tm[1720]=2'd2; sw_out_tm[1721]=2'd3;
      sw_out_tm[1722]=2'd1; sw_out_tm[1723]=2'd1; sw_out_tm[1724]=2'd2;
      sw_out_tm[1725]=2'd2; sw_out_tm[1726]=2'd2; sw_out_tm[1727]=2'd1;
      sw_out_tm[1728]=2'd1; sw_out_tm[1729]=2'd1; sw_out_tm[1730]=2'd1;
      sw_out_tm[1731]=2'd2; sw_out_tm[1732]=2'd1; sw_out_tm[1733]=2'd1;
      sw_out_tm[1734]=2'd2; sw_out_tm[1735]=2'd1; sw_out_tm[1736]=2'd2;
      sw_out_tm[1737]=2'd1; sw_out_tm[1738]=2'd2; sw_out_tm[1739]=2'd2;
      sw_out_tm[1740]=2'd1; sw_out_tm[1741]=2'd1; sw_out_tm[1742]=2'd1;
      sw_out_tm[1743]=2'd1; sw_out_tm[1744]=2'd2; sw_out_tm[1745]=2'd2;
      sw_out_tm[1746]=2'd1; sw_out_tm[1747]=2'd1; sw_out_tm[1748]=2'd1;
      sw_out_tm[1749]=2'd1; sw_out_tm[1750]=2'd1; sw_out_tm[1751]=2'd2;
      sw_out_tm[1752]=2'd2; sw_out_tm[1753]=2'd2; sw_out_tm[1754]=2'd1;
      sw_out_tm[1755]=2'd1; sw_out_tm[1756]=2'd2; sw_out_tm[1757]=2'd1;
      sw_out_tm[1758]=2'd1; sw_out_tm[1759]=2'd1; sw_out_tm[1760]=2'd2;
      sw_out_tm[1761]=2'd1; sw_out_tm[1762]=2'd1; sw_out_tm[1763]=2'd1;
      sw_out_tm[1764]=2'd2; sw_out_tm[1765]=2'd3; sw_out_tm[1766]=2'd1;
      sw_out_tm[1767]=2'd1; sw_out_tm[1768]=2'd1; sw_out_tm[1769]=2'd1;
      sw_out_tm[1770]=2'd2; sw_out_tm[1771]=2'd1; sw_out_tm[1772]=2'd2;
      sw_out_tm[1773]=2'd2; sw_out_tm[1774]=2'd2; sw_out_tm[1775]=2'd2;
      sw_out_tm[1776]=2'd1; sw_out_tm[1777]=2'd1; sw_out_tm[1778]=2'd1;
      sw_out_tm[1779]=2'd1; sw_out_tm[1780]=2'd2; sw_out_tm[1781]=2'd1;
      sw_out_tm[1782]=2'd2; sw_out_tm[1783]=2'd2; sw_out_tm[1784]=2'd1;
      sw_out_tm[1785]=2'd1; sw_out_tm[1786]=2'd1; sw_out_tm[1787]=2'd1;
      sw_out_tm[1788]=2'd1; sw_out_tm[1789]=2'd1; sw_out_tm[1790]=2'd1;
      sw_out_tm[1791]=2'd2; sw_out_tm[1792]=2'd1; sw_out_tm[1793]=2'd2;
      sw_out_tm[1794]=2'd2; sw_out_tm[1795]=2'd1; sw_out_tm[1796]=2'd1;
      sw_out_tm[1797]=2'd3; sw_out_tm[1798]=2'd2; sw_out_tm[1799]=2'd1;
      sw_out_tm[1800]=2'd1; sw_out_tm[1801]=2'd1; sw_out_tm[1802]=2'd2;
      sw_out_tm[1803]=2'd1; sw_out_tm[1804]=2'd2; sw_out_tm[1805]=2'd2;
      sw_out_tm[1806]=2'd2; sw_out_tm[1807]=2'd1; sw_out_tm[1808]=2'd2;
      sw_out_tm[1809]=2'd1; sw_out_tm[1810]=2'd2; sw_out_tm[1811]=2'd2;
      sw_out_tm[1812]=2'd1; sw_out_tm[1813]=2'd1; sw_out_tm[1814]=2'd1;
      sw_out_tm[1815]=2'd1; sw_out_tm[1816]=2'd2; sw_out_tm[1817]=2'd3;
      sw_out_tm[1818]=2'd1; sw_out_tm[1819]=2'd1; sw_out_tm[1820]=2'd2;
      sw_out_tm[1821]=2'd2; sw_out_tm[1822]=2'd1; sw_out_tm[1823]=2'd1;
      sw_out_tm[1824]=2'd2; sw_out_tm[1825]=2'd1; sw_out_tm[1826]=2'd1;
      sw_out_tm[1827]=2'd2; sw_out_tm[1828]=2'd1; sw_out_tm[1829]=2'd3;
      sw_out_tm[1830]=2'd1; sw_out_tm[1831]=2'd1; sw_out_tm[1832]=2'd2;
      sw_out_tm[1833]=2'd1; sw_out_tm[1834]=2'd1; sw_out_tm[1835]=2'd2;
      sw_out_tm[1836]=2'd1; sw_out_tm[1837]=2'd2; sw_out_tm[1838]=2'd1;
      sw_out_tm[1839]=2'd1; sw_out_tm[1840]=2'd2; sw_out_tm[1841]=2'd2;
      sw_out_tm[1842]=2'd2; sw_out_tm[1843]=2'd1; sw_out_tm[1844]=2'd1;
      sw_out_tm[1845]=2'd1; sw_out_tm[1846]=2'd1; sw_out_tm[1847]=2'd2;
      sw_out_tm[1848]=2'd2; sw_out_tm[1849]=2'd1; sw_out_tm[1850]=2'd1;
      sw_out_tm[1851]=2'd1; sw_out_tm[1852]=2'd2; sw_out_tm[1853]=2'd1;
      sw_out_tm[1854]=2'd2; sw_out_tm[1855]=2'd3; sw_out_tm[1856]=2'd2;
      sw_out_tm[1857]=2'd2; sw_out_tm[1858]=2'd2; sw_out_tm[1859]=2'd1;
      sw_out_tm[1860]=2'd2; sw_out_tm[1861]=2'd1; sw_out_tm[1862]=2'd2;
      sw_out_tm[1863]=2'd3; sw_out_tm[1864]=2'd2; sw_out_tm[1865]=2'd2;
      sw_out_tm[1866]=2'd1; sw_out_tm[1867]=2'd2; sw_out_tm[1868]=2'd1;
      sw_out_tm[1869]=2'd1; sw_out_tm[1870]=2'd1; sw_out_tm[1871]=2'd1;
      sw_out_tm[1872]=2'd1; sw_out_tm[1873]=2'd2; sw_out_tm[1874]=2'd2;
      sw_out_tm[1875]=2'd3; sw_out_tm[1876]=2'd2; sw_out_tm[1877]=2'd1;
      sw_out_tm[1878]=2'd1; sw_out_tm[1879]=2'd1; sw_out_tm[1880]=2'd2;
      sw_out_tm[1881]=2'd1; sw_out_tm[1882]=2'd2; sw_out_tm[1883]=2'd2;
      sw_out_tm[1884]=2'd2; sw_out_tm[1885]=2'd1; sw_out_tm[1886]=2'd2;
      sw_out_tm[1887]=2'd1; sw_out_tm[1888]=2'd2; sw_out_tm[1889]=2'd2;
      sw_out_tm[1890]=2'd1; sw_out_tm[1891]=2'd1; sw_out_tm[1892]=2'd1;
      sw_out_tm[1893]=2'd1; sw_out_tm[1894]=2'd2; sw_out_tm[1895]=2'd2;
      sw_out_tm[1896]=2'd1; sw_out_tm[1897]=2'd1; sw_out_tm[1898]=2'd2;
      sw_out_tm[1899]=2'd1; sw_out_tm[1900]=2'd1; sw_out_tm[1901]=2'd3;
      sw_out_tm[1902]=2'd2; sw_out_tm[1903]=2'd1; sw_out_tm[1904]=2'd1;
      sw_out_tm[1905]=2'd1; sw_out_tm[1906]=2'd1; sw_out_tm[1907]=2'd2;
      sw_out_tm[1908]=2'd1; sw_out_tm[1909]=2'd2; sw_out_tm[1910]=2'd1;
      sw_out_tm[1911]=2'd1; sw_out_tm[1912]=2'd1; sw_out_tm[1913]=2'd1;
      sw_out_tm[1914]=2'd1; sw_out_tm[1915]=2'd2; sw_out_tm[1916]=2'd1;
      sw_out_tm[1917]=2'd1; sw_out_tm[1918]=2'd1; sw_out_tm[1919]=2'd2;
      sw_out_tm[1920]=2'd2; sw_out_tm[1921]=2'd1; sw_out_tm[1922]=2'd2;
      sw_out_tm[1923]=2'd1; sw_out_tm[1924]=2'd1; sw_out_tm[1925]=2'd2;
      sw_out_tm[1926]=2'd2; sw_out_tm[1927]=2'd1; sw_out_tm[1928]=2'd1;
      sw_out_tm[1929]=2'd3; sw_out_tm[1930]=2'd2; sw_out_tm[1931]=2'd1;
      sw_out_tm[1932]=2'd1; sw_out_tm[1933]=2'd1; sw_out_tm[1934]=2'd1;
      sw_out_tm[1935]=2'd1; sw_out_tm[1936]=2'd1; sw_out_tm[1937]=2'd2;
      sw_out_tm[1938]=2'd2; sw_out_tm[1939]=2'd1; sw_out_tm[1940]=2'd1;
      sw_out_tm[1941]=2'd1; sw_out_tm[1942]=2'd2; sw_out_tm[1943]=2'd1;
      sw_out_tm[1944]=2'd2; sw_out_tm[1945]=2'd3; sw_out_tm[1946]=2'd2;
      sw_out_tm[1947]=2'd1; sw_out_tm[1948]=2'd1; sw_out_tm[1949]=2'd1;
      sw_out_tm[1950]=2'd2; sw_out_tm[1951]=2'd2; sw_out_tm[1952]=2'd1;
      sw_out_tm[1953]=2'd2; sw_out_tm[1954]=2'd2; sw_out_tm[1955]=2'd1;
      sw_out_tm[1956]=2'd1; sw_out_tm[1957]=2'd1; sw_out_tm[1958]=2'd2;
      sw_out_tm[1959]=2'd1; sw_out_tm[1960]=2'd2; sw_out_tm[1961]=2'd2;
      sw_out_tm[1962]=2'd1; sw_out_tm[1963]=2'd1; sw_out_tm[1964]=2'd1;
      sw_out_tm[1965]=2'd2; sw_out_tm[1966]=2'd2; sw_out_tm[1967]=2'd1;
      sw_out_tm[1968]=2'd1; sw_out_tm[1969]=2'd2; sw_out_tm[1970]=2'd2;
      sw_out_tm[1971]=2'd1; sw_out_tm[1972]=2'd2; sw_out_tm[1973]=2'd1;
      sw_out_tm[1974]=2'd1; sw_out_tm[1975]=2'd3; sw_out_tm[1976]=2'd1;
      sw_out_tm[1977]=2'd1; sw_out_tm[1978]=2'd1; sw_out_tm[1979]=2'd2;
      sw_out_tm[1980]=2'd2; sw_out_tm[1981]=2'd3; sw_out_tm[1982]=2'd2;
      sw_out_tm[1983]=2'd1; sw_out_tm[1984]=2'd1; sw_out_tm[1985]=2'd1;
      sw_out_tm[1986]=2'd1; sw_out_tm[1987]=2'd2; sw_out_tm[1988]=2'd1;
      sw_out_tm[1989]=2'd1; sw_out_tm[1990]=2'd1; sw_out_tm[1991]=2'd2;
      sw_out_tm[1992]=2'd1; sw_out_tm[1993]=2'd1; sw_out_tm[1994]=2'd2;
      sw_out_tm[1995]=2'd1; sw_out_tm[1996]=2'd1; sw_out_tm[1997]=2'd2;
      sw_out_tm[1998]=2'd1; sw_out_tm[1999]=2'd2; sw_out_tm[2000]=2'd2;
      sw_out_tm[2001]=2'd1; sw_out_tm[2002]=2'd1; sw_out_tm[2003]=2'd1;
      sw_out_tm[2004]=2'd2; sw_out_tm[2005]=2'd1; sw_out_tm[2006]=2'd1;
      sw_out_tm[2007]=2'd2; sw_out_tm[2008]=2'd2; sw_out_tm[2009]=2'd2;
      sw_out_tm[2010]=2'd1; sw_out_tm[2011]=2'd1; sw_out_tm[2012]=2'd2;
      sw_out_tm[2013]=2'd1; sw_out_tm[2014]=2'd1; sw_out_tm[2015]=2'd1;
      sw_out_tm[2016]=2'd1; sw_out_tm[2017]=2'd2; sw_out_tm[2018]=2'd2;
      sw_out_tm[2019]=2'd1; sw_out_tm[2020]=2'd1; sw_out_tm[2021]=2'd1;
      sw_out_tm[2022]=2'd2; sw_out_tm[2023]=2'd1; sw_out_tm[2024]=2'd2;
      sw_out_tm[2025]=2'd2; sw_out_tm[2026]=2'd1; sw_out_tm[2027]=2'd1;
      sw_out_tm[2028]=2'd2; sw_out_tm[2029]=2'd1; sw_out_tm[2030]=2'd1;
      sw_out_tm[2031]=2'd1; sw_out_tm[2032]=2'd2; sw_out_tm[2033]=2'd1;
      sw_out_tm[2034]=2'd1; sw_out_tm[2035]=2'd1; sw_out_tm[2036]=2'd2;
      sw_out_tm[2037]=2'd3; sw_out_tm[2038]=2'd0; sw_out_tm[2039]=2'd0;
      sw_out_tm[2040]=2'd0; sw_out_tm[2041]=2'd0; sw_out_tm[2042]=2'd0;
      sw_out_tm[2043]=2'd0; sw_out_tm[2044]=2'd0; sw_out_tm[2045]=2'd0;
      sw_out_tm[2046]=2'd0; sw_out_tm[2047]=2'd0;
      end

   // one shot model for the up button
   // this model will result in the sp_up_os signal pulsing one clock 
   // cycle from 1 to 0 and back to 1 whenever the input signal sp_up_os
   //  goes from 1 to 0
   always @ (posedge clk)
      begin:UP
         reg state = 0;
         if (reset)
            if (!state)
               if (!sp_up)
                  begin
                  sp_up_os <= 0;
                  state <= 1;
                  end 
               else
                  sp_up_os <= 1;
            else
               begin
               sp_up_os <= 1;
                if (sp_up)
                   state <= 0;
               end
         else
            sp_up_os <= 1;
      end

   // one shot model for the down button
   // this model will result in the sp_dwn_os signal pulsing one clock
   // cycle from 1 to 0 and back to 1 whenever the input signal sp_dwn
   // goes from 1 to 0
   always @ (posedge clk)
      begin:DWN
         reg state = 0; 
         if (reset)
            if (!state) 
               if (!sp_dwn)
                  begin
                  sp_dwn_os <= 0;
                  state <= 1;
                  end
               else
                  sp_dwn_os <= 1;
            else
               begin
               sp_dwn_os <= 1;
               if (sp_dwn)
                  state <= 0;
               end
         else
            sp_dwn_os <= 1;
      end

   // this process allows the speed of the sending routine to be
   // changed by the sp_up and the sp_dwn signals
   always @ (posedge clk)
      begin:SPEED_CH
         reg [2:0] state = 3'd0;
         if (!reset)
            begin
            state = 3'd0;
            sp_index = 3'd0;
            ledr = 8'd0; // clear out all Speed LED's
            end
         else
            begin
            ledr = 8'd0; // clear out all Speed LED's
            if (!sp_up_os) 
               if (state < 3'd7) 
                  state = state + 3'd1;
               else
                  state = 3'd0;
            else
               if (!sp_dwn_os)
                  if (state > 3'd0) 
                     state = state - 3'd1;
                  else
                     state = 3'd7;

            sp_index = state;
            ledr[state] = 1'd1;
            end
      end

   // this process outputs the proper timing for a pre-recorded message.
   // The message is encoded as an array of time durations in the 
   // sw_out_tm array where the values of 1 represents one unit, 2 
   // represents 2 units, 3 represents 3 units, and 0 indicates that
   // the message should start over again. The sw_out output should
   // begin at a logic 1 and toggle between a logic 0 and 1 after each
   // time duration. The message has been designed to represent valid 
   // encodings.
   always @ (posedge clk)
      begin:PLAY_BK
         reg [10:0] nxt_unit = 11'd0;
         reg [3:0] unit_cnt = 4'd0;
         reg [1:0] unit_val;
         reg [22:0] m_clk = 23'd0;
         reg key_out = 1'd0;

         // on/off keying timing where
         // 1 => one unit pulse, 2 => three unit pulses, 
         // 3 >= space timing 
         // 0 => restart at the beginning of the array

         // if reset button is pressed go back from the beginning and
         // make sure key switch is not pressed
         if (!reset)
            begin
               nxt_unit = 11'd0; // go back to beginning
               key_out = 1'd0;   // unpress key switch
            end
         else           
            if (m_clk < m_clk_range[sp_index])
               m_clk = m_clk + 1;
            else
               begin 
               m_clk = 23'd0;
               if (unit_cnt == 4'd0)
                  begin
                  key_out = ~key_out; // toggle sw to other state
                  sw_out = key_out;
                  unit_val = sw_out_tm[nxt_unit];
                  if (unit_val == 2'd0)
                     begin
                     nxt_unit = 11'd0;
                     unit_val = sw_out_tm[0];
                     end 
                  if (unit_val == 2'd1)
                     // time for dit or between dits and dashes in 
                     // a character
                     unit_cnt = 4'd1; 
                  else 
                     // time for a dash or time characters
                     if (unit_val == 2'd2) 
                        unit_cnt = 4'd3; 
                     else 
                        // space timing a bit longer than the 
                        // required 7 units
                        unit_cnt = 4'd10;
                  nxt_unit = nxt_unit + 11'd1;
                  end
               else
                  unit_cnt = unit_cnt - 4'd1;
               end
      end
 
endmodule
      

