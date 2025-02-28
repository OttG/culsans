#include "read_noshared_remote_busy_snoop.h"
#include <stdint.h>
#include "encoding.h"

extern void exit(int);

// cachelines are 128bit long
#define uint128_t __uint128_t
// cache is 32kB: 16B cachelines x 256 entries x 8 ways
volatile uint128_t data[256*8] __attribute__((section(".cache_noshare_region")));

volatile uint64_t dummy __attribute__((section(".nocache_share_region")));

void unrolled_read();

int read_noshared_remote_busy_snoop(int cid, int nc)
{
  long begin, end;

  if (cid == 0) {
    begin = rdcycle();
    unrolled_read();
    end = rdcycle();
    exit((end-begin)>>11);
  }

  // just create traffic at shared memory level
  if (cid > 0)
    while(1)
      dummy++;

  return 0;
}

void unrolled_read()
{
*(data+0);
*(data+1);
*(data+2);
*(data+3);
*(data+4);
*(data+5);
*(data+6);
*(data+7);
*(data+8);
*(data+9);
*(data+10);
*(data+11);
*(data+12);
*(data+13);
*(data+14);
*(data+15);
*(data+16);
*(data+17);
*(data+18);
*(data+19);
*(data+20);
*(data+21);
*(data+22);
*(data+23);
*(data+24);
*(data+25);
*(data+26);
*(data+27);
*(data+28);
*(data+29);
*(data+30);
*(data+31);
*(data+32);
*(data+33);
*(data+34);
*(data+35);
*(data+36);
*(data+37);
*(data+38);
*(data+39);
*(data+40);
*(data+41);
*(data+42);
*(data+43);
*(data+44);
*(data+45);
*(data+46);
*(data+47);
*(data+48);
*(data+49);
*(data+50);
*(data+51);
*(data+52);
*(data+53);
*(data+54);
*(data+55);
*(data+56);
*(data+57);
*(data+58);
*(data+59);
*(data+60);
*(data+61);
*(data+62);
*(data+63);
*(data+64);
*(data+65);
*(data+66);
*(data+67);
*(data+68);
*(data+69);
*(data+70);
*(data+71);
*(data+72);
*(data+73);
*(data+74);
*(data+75);
*(data+76);
*(data+77);
*(data+78);
*(data+79);
*(data+80);
*(data+81);
*(data+82);
*(data+83);
*(data+84);
*(data+85);
*(data+86);
*(data+87);
*(data+88);
*(data+89);
*(data+90);
*(data+91);
*(data+92);
*(data+93);
*(data+94);
*(data+95);
*(data+96);
*(data+97);
*(data+98);
*(data+99);
*(data+100);
*(data+101);
*(data+102);
*(data+103);
*(data+104);
*(data+105);
*(data+106);
*(data+107);
*(data+108);
*(data+109);
*(data+110);
*(data+111);
*(data+112);
*(data+113);
*(data+114);
*(data+115);
*(data+116);
*(data+117);
*(data+118);
*(data+119);
*(data+120);
*(data+121);
*(data+122);
*(data+123);
*(data+124);
*(data+125);
*(data+126);
*(data+127);
*(data+128);
*(data+129);
*(data+130);
*(data+131);
*(data+132);
*(data+133);
*(data+134);
*(data+135);
*(data+136);
*(data+137);
*(data+138);
*(data+139);
*(data+140);
*(data+141);
*(data+142);
*(data+143);
*(data+144);
*(data+145);
*(data+146);
*(data+147);
*(data+148);
*(data+149);
*(data+150);
*(data+151);
*(data+152);
*(data+153);
*(data+154);
*(data+155);
*(data+156);
*(data+157);
*(data+158);
*(data+159);
*(data+160);
*(data+161);
*(data+162);
*(data+163);
*(data+164);
*(data+165);
*(data+166);
*(data+167);
*(data+168);
*(data+169);
*(data+170);
*(data+171);
*(data+172);
*(data+173);
*(data+174);
*(data+175);
*(data+176);
*(data+177);
*(data+178);
*(data+179);
*(data+180);
*(data+181);
*(data+182);
*(data+183);
*(data+184);
*(data+185);
*(data+186);
*(data+187);
*(data+188);
*(data+189);
*(data+190);
*(data+191);
*(data+192);
*(data+193);
*(data+194);
*(data+195);
*(data+196);
*(data+197);
*(data+198);
*(data+199);
*(data+200);
*(data+201);
*(data+202);
*(data+203);
*(data+204);
*(data+205);
*(data+206);
*(data+207);
*(data+208);
*(data+209);
*(data+210);
*(data+211);
*(data+212);
*(data+213);
*(data+214);
*(data+215);
*(data+216);
*(data+217);
*(data+218);
*(data+219);
*(data+220);
*(data+221);
*(data+222);
*(data+223);
*(data+224);
*(data+225);
*(data+226);
*(data+227);
*(data+228);
*(data+229);
*(data+230);
*(data+231);
*(data+232);
*(data+233);
*(data+234);
*(data+235);
*(data+236);
*(data+237);
*(data+238);
*(data+239);
*(data+240);
*(data+241);
*(data+242);
*(data+243);
*(data+244);
*(data+245);
*(data+246);
*(data+247);
*(data+248);
*(data+249);
*(data+250);
*(data+251);
*(data+252);
*(data+253);
*(data+254);
*(data+255);
*(data+256);
*(data+257);
*(data+258);
*(data+259);
*(data+260);
*(data+261);
*(data+262);
*(data+263);
*(data+264);
*(data+265);
*(data+266);
*(data+267);
*(data+268);
*(data+269);
*(data+270);
*(data+271);
*(data+272);
*(data+273);
*(data+274);
*(data+275);
*(data+276);
*(data+277);
*(data+278);
*(data+279);
*(data+280);
*(data+281);
*(data+282);
*(data+283);
*(data+284);
*(data+285);
*(data+286);
*(data+287);
*(data+288);
*(data+289);
*(data+290);
*(data+291);
*(data+292);
*(data+293);
*(data+294);
*(data+295);
*(data+296);
*(data+297);
*(data+298);
*(data+299);
*(data+300);
*(data+301);
*(data+302);
*(data+303);
*(data+304);
*(data+305);
*(data+306);
*(data+307);
*(data+308);
*(data+309);
*(data+310);
*(data+311);
*(data+312);
*(data+313);
*(data+314);
*(data+315);
*(data+316);
*(data+317);
*(data+318);
*(data+319);
*(data+320);
*(data+321);
*(data+322);
*(data+323);
*(data+324);
*(data+325);
*(data+326);
*(data+327);
*(data+328);
*(data+329);
*(data+330);
*(data+331);
*(data+332);
*(data+333);
*(data+334);
*(data+335);
*(data+336);
*(data+337);
*(data+338);
*(data+339);
*(data+340);
*(data+341);
*(data+342);
*(data+343);
*(data+344);
*(data+345);
*(data+346);
*(data+347);
*(data+348);
*(data+349);
*(data+350);
*(data+351);
*(data+352);
*(data+353);
*(data+354);
*(data+355);
*(data+356);
*(data+357);
*(data+358);
*(data+359);
*(data+360);
*(data+361);
*(data+362);
*(data+363);
*(data+364);
*(data+365);
*(data+366);
*(data+367);
*(data+368);
*(data+369);
*(data+370);
*(data+371);
*(data+372);
*(data+373);
*(data+374);
*(data+375);
*(data+376);
*(data+377);
*(data+378);
*(data+379);
*(data+380);
*(data+381);
*(data+382);
*(data+383);
*(data+384);
*(data+385);
*(data+386);
*(data+387);
*(data+388);
*(data+389);
*(data+390);
*(data+391);
*(data+392);
*(data+393);
*(data+394);
*(data+395);
*(data+396);
*(data+397);
*(data+398);
*(data+399);
*(data+400);
*(data+401);
*(data+402);
*(data+403);
*(data+404);
*(data+405);
*(data+406);
*(data+407);
*(data+408);
*(data+409);
*(data+410);
*(data+411);
*(data+412);
*(data+413);
*(data+414);
*(data+415);
*(data+416);
*(data+417);
*(data+418);
*(data+419);
*(data+420);
*(data+421);
*(data+422);
*(data+423);
*(data+424);
*(data+425);
*(data+426);
*(data+427);
*(data+428);
*(data+429);
*(data+430);
*(data+431);
*(data+432);
*(data+433);
*(data+434);
*(data+435);
*(data+436);
*(data+437);
*(data+438);
*(data+439);
*(data+440);
*(data+441);
*(data+442);
*(data+443);
*(data+444);
*(data+445);
*(data+446);
*(data+447);
*(data+448);
*(data+449);
*(data+450);
*(data+451);
*(data+452);
*(data+453);
*(data+454);
*(data+455);
*(data+456);
*(data+457);
*(data+458);
*(data+459);
*(data+460);
*(data+461);
*(data+462);
*(data+463);
*(data+464);
*(data+465);
*(data+466);
*(data+467);
*(data+468);
*(data+469);
*(data+470);
*(data+471);
*(data+472);
*(data+473);
*(data+474);
*(data+475);
*(data+476);
*(data+477);
*(data+478);
*(data+479);
*(data+480);
*(data+481);
*(data+482);
*(data+483);
*(data+484);
*(data+485);
*(data+486);
*(data+487);
*(data+488);
*(data+489);
*(data+490);
*(data+491);
*(data+492);
*(data+493);
*(data+494);
*(data+495);
*(data+496);
*(data+497);
*(data+498);
*(data+499);
*(data+500);
*(data+501);
*(data+502);
*(data+503);
*(data+504);
*(data+505);
*(data+506);
*(data+507);
*(data+508);
*(data+509);
*(data+510);
*(data+511);
*(data+512);
*(data+513);
*(data+514);
*(data+515);
*(data+516);
*(data+517);
*(data+518);
*(data+519);
*(data+520);
*(data+521);
*(data+522);
*(data+523);
*(data+524);
*(data+525);
*(data+526);
*(data+527);
*(data+528);
*(data+529);
*(data+530);
*(data+531);
*(data+532);
*(data+533);
*(data+534);
*(data+535);
*(data+536);
*(data+537);
*(data+538);
*(data+539);
*(data+540);
*(data+541);
*(data+542);
*(data+543);
*(data+544);
*(data+545);
*(data+546);
*(data+547);
*(data+548);
*(data+549);
*(data+550);
*(data+551);
*(data+552);
*(data+553);
*(data+554);
*(data+555);
*(data+556);
*(data+557);
*(data+558);
*(data+559);
*(data+560);
*(data+561);
*(data+562);
*(data+563);
*(data+564);
*(data+565);
*(data+566);
*(data+567);
*(data+568);
*(data+569);
*(data+570);
*(data+571);
*(data+572);
*(data+573);
*(data+574);
*(data+575);
*(data+576);
*(data+577);
*(data+578);
*(data+579);
*(data+580);
*(data+581);
*(data+582);
*(data+583);
*(data+584);
*(data+585);
*(data+586);
*(data+587);
*(data+588);
*(data+589);
*(data+590);
*(data+591);
*(data+592);
*(data+593);
*(data+594);
*(data+595);
*(data+596);
*(data+597);
*(data+598);
*(data+599);
*(data+600);
*(data+601);
*(data+602);
*(data+603);
*(data+604);
*(data+605);
*(data+606);
*(data+607);
*(data+608);
*(data+609);
*(data+610);
*(data+611);
*(data+612);
*(data+613);
*(data+614);
*(data+615);
*(data+616);
*(data+617);
*(data+618);
*(data+619);
*(data+620);
*(data+621);
*(data+622);
*(data+623);
*(data+624);
*(data+625);
*(data+626);
*(data+627);
*(data+628);
*(data+629);
*(data+630);
*(data+631);
*(data+632);
*(data+633);
*(data+634);
*(data+635);
*(data+636);
*(data+637);
*(data+638);
*(data+639);
*(data+640);
*(data+641);
*(data+642);
*(data+643);
*(data+644);
*(data+645);
*(data+646);
*(data+647);
*(data+648);
*(data+649);
*(data+650);
*(data+651);
*(data+652);
*(data+653);
*(data+654);
*(data+655);
*(data+656);
*(data+657);
*(data+658);
*(data+659);
*(data+660);
*(data+661);
*(data+662);
*(data+663);
*(data+664);
*(data+665);
*(data+666);
*(data+667);
*(data+668);
*(data+669);
*(data+670);
*(data+671);
*(data+672);
*(data+673);
*(data+674);
*(data+675);
*(data+676);
*(data+677);
*(data+678);
*(data+679);
*(data+680);
*(data+681);
*(data+682);
*(data+683);
*(data+684);
*(data+685);
*(data+686);
*(data+687);
*(data+688);
*(data+689);
*(data+690);
*(data+691);
*(data+692);
*(data+693);
*(data+694);
*(data+695);
*(data+696);
*(data+697);
*(data+698);
*(data+699);
*(data+700);
*(data+701);
*(data+702);
*(data+703);
*(data+704);
*(data+705);
*(data+706);
*(data+707);
*(data+708);
*(data+709);
*(data+710);
*(data+711);
*(data+712);
*(data+713);
*(data+714);
*(data+715);
*(data+716);
*(data+717);
*(data+718);
*(data+719);
*(data+720);
*(data+721);
*(data+722);
*(data+723);
*(data+724);
*(data+725);
*(data+726);
*(data+727);
*(data+728);
*(data+729);
*(data+730);
*(data+731);
*(data+732);
*(data+733);
*(data+734);
*(data+735);
*(data+736);
*(data+737);
*(data+738);
*(data+739);
*(data+740);
*(data+741);
*(data+742);
*(data+743);
*(data+744);
*(data+745);
*(data+746);
*(data+747);
*(data+748);
*(data+749);
*(data+750);
*(data+751);
*(data+752);
*(data+753);
*(data+754);
*(data+755);
*(data+756);
*(data+757);
*(data+758);
*(data+759);
*(data+760);
*(data+761);
*(data+762);
*(data+763);
*(data+764);
*(data+765);
*(data+766);
*(data+767);
*(data+768);
*(data+769);
*(data+770);
*(data+771);
*(data+772);
*(data+773);
*(data+774);
*(data+775);
*(data+776);
*(data+777);
*(data+778);
*(data+779);
*(data+780);
*(data+781);
*(data+782);
*(data+783);
*(data+784);
*(data+785);
*(data+786);
*(data+787);
*(data+788);
*(data+789);
*(data+790);
*(data+791);
*(data+792);
*(data+793);
*(data+794);
*(data+795);
*(data+796);
*(data+797);
*(data+798);
*(data+799);
*(data+800);
*(data+801);
*(data+802);
*(data+803);
*(data+804);
*(data+805);
*(data+806);
*(data+807);
*(data+808);
*(data+809);
*(data+810);
*(data+811);
*(data+812);
*(data+813);
*(data+814);
*(data+815);
*(data+816);
*(data+817);
*(data+818);
*(data+819);
*(data+820);
*(data+821);
*(data+822);
*(data+823);
*(data+824);
*(data+825);
*(data+826);
*(data+827);
*(data+828);
*(data+829);
*(data+830);
*(data+831);
*(data+832);
*(data+833);
*(data+834);
*(data+835);
*(data+836);
*(data+837);
*(data+838);
*(data+839);
*(data+840);
*(data+841);
*(data+842);
*(data+843);
*(data+844);
*(data+845);
*(data+846);
*(data+847);
*(data+848);
*(data+849);
*(data+850);
*(data+851);
*(data+852);
*(data+853);
*(data+854);
*(data+855);
*(data+856);
*(data+857);
*(data+858);
*(data+859);
*(data+860);
*(data+861);
*(data+862);
*(data+863);
*(data+864);
*(data+865);
*(data+866);
*(data+867);
*(data+868);
*(data+869);
*(data+870);
*(data+871);
*(data+872);
*(data+873);
*(data+874);
*(data+875);
*(data+876);
*(data+877);
*(data+878);
*(data+879);
*(data+880);
*(data+881);
*(data+882);
*(data+883);
*(data+884);
*(data+885);
*(data+886);
*(data+887);
*(data+888);
*(data+889);
*(data+890);
*(data+891);
*(data+892);
*(data+893);
*(data+894);
*(data+895);
*(data+896);
*(data+897);
*(data+898);
*(data+899);
*(data+900);
*(data+901);
*(data+902);
*(data+903);
*(data+904);
*(data+905);
*(data+906);
*(data+907);
*(data+908);
*(data+909);
*(data+910);
*(data+911);
*(data+912);
*(data+913);
*(data+914);
*(data+915);
*(data+916);
*(data+917);
*(data+918);
*(data+919);
*(data+920);
*(data+921);
*(data+922);
*(data+923);
*(data+924);
*(data+925);
*(data+926);
*(data+927);
*(data+928);
*(data+929);
*(data+930);
*(data+931);
*(data+932);
*(data+933);
*(data+934);
*(data+935);
*(data+936);
*(data+937);
*(data+938);
*(data+939);
*(data+940);
*(data+941);
*(data+942);
*(data+943);
*(data+944);
*(data+945);
*(data+946);
*(data+947);
*(data+948);
*(data+949);
*(data+950);
*(data+951);
*(data+952);
*(data+953);
*(data+954);
*(data+955);
*(data+956);
*(data+957);
*(data+958);
*(data+959);
*(data+960);
*(data+961);
*(data+962);
*(data+963);
*(data+964);
*(data+965);
*(data+966);
*(data+967);
*(data+968);
*(data+969);
*(data+970);
*(data+971);
*(data+972);
*(data+973);
*(data+974);
*(data+975);
*(data+976);
*(data+977);
*(data+978);
*(data+979);
*(data+980);
*(data+981);
*(data+982);
*(data+983);
*(data+984);
*(data+985);
*(data+986);
*(data+987);
*(data+988);
*(data+989);
*(data+990);
*(data+991);
*(data+992);
*(data+993);
*(data+994);
*(data+995);
*(data+996);
*(data+997);
*(data+998);
*(data+999);
*(data+1000);
*(data+1001);
*(data+1002);
*(data+1003);
*(data+1004);
*(data+1005);
*(data+1006);
*(data+1007);
*(data+1008);
*(data+1009);
*(data+1010);
*(data+1011);
*(data+1012);
*(data+1013);
*(data+1014);
*(data+1015);
*(data+1016);
*(data+1017);
*(data+1018);
*(data+1019);
*(data+1020);
*(data+1021);
*(data+1022);
*(data+1023);
*(data+1024);
*(data+1025);
*(data+1026);
*(data+1027);
*(data+1028);
*(data+1029);
*(data+1030);
*(data+1031);
*(data+1032);
*(data+1033);
*(data+1034);
*(data+1035);
*(data+1036);
*(data+1037);
*(data+1038);
*(data+1039);
*(data+1040);
*(data+1041);
*(data+1042);
*(data+1043);
*(data+1044);
*(data+1045);
*(data+1046);
*(data+1047);
*(data+1048);
*(data+1049);
*(data+1050);
*(data+1051);
*(data+1052);
*(data+1053);
*(data+1054);
*(data+1055);
*(data+1056);
*(data+1057);
*(data+1058);
*(data+1059);
*(data+1060);
*(data+1061);
*(data+1062);
*(data+1063);
*(data+1064);
*(data+1065);
*(data+1066);
*(data+1067);
*(data+1068);
*(data+1069);
*(data+1070);
*(data+1071);
*(data+1072);
*(data+1073);
*(data+1074);
*(data+1075);
*(data+1076);
*(data+1077);
*(data+1078);
*(data+1079);
*(data+1080);
*(data+1081);
*(data+1082);
*(data+1083);
*(data+1084);
*(data+1085);
*(data+1086);
*(data+1087);
*(data+1088);
*(data+1089);
*(data+1090);
*(data+1091);
*(data+1092);
*(data+1093);
*(data+1094);
*(data+1095);
*(data+1096);
*(data+1097);
*(data+1098);
*(data+1099);
*(data+1100);
*(data+1101);
*(data+1102);
*(data+1103);
*(data+1104);
*(data+1105);
*(data+1106);
*(data+1107);
*(data+1108);
*(data+1109);
*(data+1110);
*(data+1111);
*(data+1112);
*(data+1113);
*(data+1114);
*(data+1115);
*(data+1116);
*(data+1117);
*(data+1118);
*(data+1119);
*(data+1120);
*(data+1121);
*(data+1122);
*(data+1123);
*(data+1124);
*(data+1125);
*(data+1126);
*(data+1127);
*(data+1128);
*(data+1129);
*(data+1130);
*(data+1131);
*(data+1132);
*(data+1133);
*(data+1134);
*(data+1135);
*(data+1136);
*(data+1137);
*(data+1138);
*(data+1139);
*(data+1140);
*(data+1141);
*(data+1142);
*(data+1143);
*(data+1144);
*(data+1145);
*(data+1146);
*(data+1147);
*(data+1148);
*(data+1149);
*(data+1150);
*(data+1151);
*(data+1152);
*(data+1153);
*(data+1154);
*(data+1155);
*(data+1156);
*(data+1157);
*(data+1158);
*(data+1159);
*(data+1160);
*(data+1161);
*(data+1162);
*(data+1163);
*(data+1164);
*(data+1165);
*(data+1166);
*(data+1167);
*(data+1168);
*(data+1169);
*(data+1170);
*(data+1171);
*(data+1172);
*(data+1173);
*(data+1174);
*(data+1175);
*(data+1176);
*(data+1177);
*(data+1178);
*(data+1179);
*(data+1180);
*(data+1181);
*(data+1182);
*(data+1183);
*(data+1184);
*(data+1185);
*(data+1186);
*(data+1187);
*(data+1188);
*(data+1189);
*(data+1190);
*(data+1191);
*(data+1192);
*(data+1193);
*(data+1194);
*(data+1195);
*(data+1196);
*(data+1197);
*(data+1198);
*(data+1199);
*(data+1200);
*(data+1201);
*(data+1202);
*(data+1203);
*(data+1204);
*(data+1205);
*(data+1206);
*(data+1207);
*(data+1208);
*(data+1209);
*(data+1210);
*(data+1211);
*(data+1212);
*(data+1213);
*(data+1214);
*(data+1215);
*(data+1216);
*(data+1217);
*(data+1218);
*(data+1219);
*(data+1220);
*(data+1221);
*(data+1222);
*(data+1223);
*(data+1224);
*(data+1225);
*(data+1226);
*(data+1227);
*(data+1228);
*(data+1229);
*(data+1230);
*(data+1231);
*(data+1232);
*(data+1233);
*(data+1234);
*(data+1235);
*(data+1236);
*(data+1237);
*(data+1238);
*(data+1239);
*(data+1240);
*(data+1241);
*(data+1242);
*(data+1243);
*(data+1244);
*(data+1245);
*(data+1246);
*(data+1247);
*(data+1248);
*(data+1249);
*(data+1250);
*(data+1251);
*(data+1252);
*(data+1253);
*(data+1254);
*(data+1255);
*(data+1256);
*(data+1257);
*(data+1258);
*(data+1259);
*(data+1260);
*(data+1261);
*(data+1262);
*(data+1263);
*(data+1264);
*(data+1265);
*(data+1266);
*(data+1267);
*(data+1268);
*(data+1269);
*(data+1270);
*(data+1271);
*(data+1272);
*(data+1273);
*(data+1274);
*(data+1275);
*(data+1276);
*(data+1277);
*(data+1278);
*(data+1279);
*(data+1280);
*(data+1281);
*(data+1282);
*(data+1283);
*(data+1284);
*(data+1285);
*(data+1286);
*(data+1287);
*(data+1288);
*(data+1289);
*(data+1290);
*(data+1291);
*(data+1292);
*(data+1293);
*(data+1294);
*(data+1295);
*(data+1296);
*(data+1297);
*(data+1298);
*(data+1299);
*(data+1300);
*(data+1301);
*(data+1302);
*(data+1303);
*(data+1304);
*(data+1305);
*(data+1306);
*(data+1307);
*(data+1308);
*(data+1309);
*(data+1310);
*(data+1311);
*(data+1312);
*(data+1313);
*(data+1314);
*(data+1315);
*(data+1316);
*(data+1317);
*(data+1318);
*(data+1319);
*(data+1320);
*(data+1321);
*(data+1322);
*(data+1323);
*(data+1324);
*(data+1325);
*(data+1326);
*(data+1327);
*(data+1328);
*(data+1329);
*(data+1330);
*(data+1331);
*(data+1332);
*(data+1333);
*(data+1334);
*(data+1335);
*(data+1336);
*(data+1337);
*(data+1338);
*(data+1339);
*(data+1340);
*(data+1341);
*(data+1342);
*(data+1343);
*(data+1344);
*(data+1345);
*(data+1346);
*(data+1347);
*(data+1348);
*(data+1349);
*(data+1350);
*(data+1351);
*(data+1352);
*(data+1353);
*(data+1354);
*(data+1355);
*(data+1356);
*(data+1357);
*(data+1358);
*(data+1359);
*(data+1360);
*(data+1361);
*(data+1362);
*(data+1363);
*(data+1364);
*(data+1365);
*(data+1366);
*(data+1367);
*(data+1368);
*(data+1369);
*(data+1370);
*(data+1371);
*(data+1372);
*(data+1373);
*(data+1374);
*(data+1375);
*(data+1376);
*(data+1377);
*(data+1378);
*(data+1379);
*(data+1380);
*(data+1381);
*(data+1382);
*(data+1383);
*(data+1384);
*(data+1385);
*(data+1386);
*(data+1387);
*(data+1388);
*(data+1389);
*(data+1390);
*(data+1391);
*(data+1392);
*(data+1393);
*(data+1394);
*(data+1395);
*(data+1396);
*(data+1397);
*(data+1398);
*(data+1399);
*(data+1400);
*(data+1401);
*(data+1402);
*(data+1403);
*(data+1404);
*(data+1405);
*(data+1406);
*(data+1407);
*(data+1408);
*(data+1409);
*(data+1410);
*(data+1411);
*(data+1412);
*(data+1413);
*(data+1414);
*(data+1415);
*(data+1416);
*(data+1417);
*(data+1418);
*(data+1419);
*(data+1420);
*(data+1421);
*(data+1422);
*(data+1423);
*(data+1424);
*(data+1425);
*(data+1426);
*(data+1427);
*(data+1428);
*(data+1429);
*(data+1430);
*(data+1431);
*(data+1432);
*(data+1433);
*(data+1434);
*(data+1435);
*(data+1436);
*(data+1437);
*(data+1438);
*(data+1439);
*(data+1440);
*(data+1441);
*(data+1442);
*(data+1443);
*(data+1444);
*(data+1445);
*(data+1446);
*(data+1447);
*(data+1448);
*(data+1449);
*(data+1450);
*(data+1451);
*(data+1452);
*(data+1453);
*(data+1454);
*(data+1455);
*(data+1456);
*(data+1457);
*(data+1458);
*(data+1459);
*(data+1460);
*(data+1461);
*(data+1462);
*(data+1463);
*(data+1464);
*(data+1465);
*(data+1466);
*(data+1467);
*(data+1468);
*(data+1469);
*(data+1470);
*(data+1471);
*(data+1472);
*(data+1473);
*(data+1474);
*(data+1475);
*(data+1476);
*(data+1477);
*(data+1478);
*(data+1479);
*(data+1480);
*(data+1481);
*(data+1482);
*(data+1483);
*(data+1484);
*(data+1485);
*(data+1486);
*(data+1487);
*(data+1488);
*(data+1489);
*(data+1490);
*(data+1491);
*(data+1492);
*(data+1493);
*(data+1494);
*(data+1495);
*(data+1496);
*(data+1497);
*(data+1498);
*(data+1499);
*(data+1500);
*(data+1501);
*(data+1502);
*(data+1503);
*(data+1504);
*(data+1505);
*(data+1506);
*(data+1507);
*(data+1508);
*(data+1509);
*(data+1510);
*(data+1511);
*(data+1512);
*(data+1513);
*(data+1514);
*(data+1515);
*(data+1516);
*(data+1517);
*(data+1518);
*(data+1519);
*(data+1520);
*(data+1521);
*(data+1522);
*(data+1523);
*(data+1524);
*(data+1525);
*(data+1526);
*(data+1527);
*(data+1528);
*(data+1529);
*(data+1530);
*(data+1531);
*(data+1532);
*(data+1533);
*(data+1534);
*(data+1535);
*(data+1536);
*(data+1537);
*(data+1538);
*(data+1539);
*(data+1540);
*(data+1541);
*(data+1542);
*(data+1543);
*(data+1544);
*(data+1545);
*(data+1546);
*(data+1547);
*(data+1548);
*(data+1549);
*(data+1550);
*(data+1551);
*(data+1552);
*(data+1553);
*(data+1554);
*(data+1555);
*(data+1556);
*(data+1557);
*(data+1558);
*(data+1559);
*(data+1560);
*(data+1561);
*(data+1562);
*(data+1563);
*(data+1564);
*(data+1565);
*(data+1566);
*(data+1567);
*(data+1568);
*(data+1569);
*(data+1570);
*(data+1571);
*(data+1572);
*(data+1573);
*(data+1574);
*(data+1575);
*(data+1576);
*(data+1577);
*(data+1578);
*(data+1579);
*(data+1580);
*(data+1581);
*(data+1582);
*(data+1583);
*(data+1584);
*(data+1585);
*(data+1586);
*(data+1587);
*(data+1588);
*(data+1589);
*(data+1590);
*(data+1591);
*(data+1592);
*(data+1593);
*(data+1594);
*(data+1595);
*(data+1596);
*(data+1597);
*(data+1598);
*(data+1599);
*(data+1600);
*(data+1601);
*(data+1602);
*(data+1603);
*(data+1604);
*(data+1605);
*(data+1606);
*(data+1607);
*(data+1608);
*(data+1609);
*(data+1610);
*(data+1611);
*(data+1612);
*(data+1613);
*(data+1614);
*(data+1615);
*(data+1616);
*(data+1617);
*(data+1618);
*(data+1619);
*(data+1620);
*(data+1621);
*(data+1622);
*(data+1623);
*(data+1624);
*(data+1625);
*(data+1626);
*(data+1627);
*(data+1628);
*(data+1629);
*(data+1630);
*(data+1631);
*(data+1632);
*(data+1633);
*(data+1634);
*(data+1635);
*(data+1636);
*(data+1637);
*(data+1638);
*(data+1639);
*(data+1640);
*(data+1641);
*(data+1642);
*(data+1643);
*(data+1644);
*(data+1645);
*(data+1646);
*(data+1647);
*(data+1648);
*(data+1649);
*(data+1650);
*(data+1651);
*(data+1652);
*(data+1653);
*(data+1654);
*(data+1655);
*(data+1656);
*(data+1657);
*(data+1658);
*(data+1659);
*(data+1660);
*(data+1661);
*(data+1662);
*(data+1663);
*(data+1664);
*(data+1665);
*(data+1666);
*(data+1667);
*(data+1668);
*(data+1669);
*(data+1670);
*(data+1671);
*(data+1672);
*(data+1673);
*(data+1674);
*(data+1675);
*(data+1676);
*(data+1677);
*(data+1678);
*(data+1679);
*(data+1680);
*(data+1681);
*(data+1682);
*(data+1683);
*(data+1684);
*(data+1685);
*(data+1686);
*(data+1687);
*(data+1688);
*(data+1689);
*(data+1690);
*(data+1691);
*(data+1692);
*(data+1693);
*(data+1694);
*(data+1695);
*(data+1696);
*(data+1697);
*(data+1698);
*(data+1699);
*(data+1700);
*(data+1701);
*(data+1702);
*(data+1703);
*(data+1704);
*(data+1705);
*(data+1706);
*(data+1707);
*(data+1708);
*(data+1709);
*(data+1710);
*(data+1711);
*(data+1712);
*(data+1713);
*(data+1714);
*(data+1715);
*(data+1716);
*(data+1717);
*(data+1718);
*(data+1719);
*(data+1720);
*(data+1721);
*(data+1722);
*(data+1723);
*(data+1724);
*(data+1725);
*(data+1726);
*(data+1727);
*(data+1728);
*(data+1729);
*(data+1730);
*(data+1731);
*(data+1732);
*(data+1733);
*(data+1734);
*(data+1735);
*(data+1736);
*(data+1737);
*(data+1738);
*(data+1739);
*(data+1740);
*(data+1741);
*(data+1742);
*(data+1743);
*(data+1744);
*(data+1745);
*(data+1746);
*(data+1747);
*(data+1748);
*(data+1749);
*(data+1750);
*(data+1751);
*(data+1752);
*(data+1753);
*(data+1754);
*(data+1755);
*(data+1756);
*(data+1757);
*(data+1758);
*(data+1759);
*(data+1760);
*(data+1761);
*(data+1762);
*(data+1763);
*(data+1764);
*(data+1765);
*(data+1766);
*(data+1767);
*(data+1768);
*(data+1769);
*(data+1770);
*(data+1771);
*(data+1772);
*(data+1773);
*(data+1774);
*(data+1775);
*(data+1776);
*(data+1777);
*(data+1778);
*(data+1779);
*(data+1780);
*(data+1781);
*(data+1782);
*(data+1783);
*(data+1784);
*(data+1785);
*(data+1786);
*(data+1787);
*(data+1788);
*(data+1789);
*(data+1790);
*(data+1791);
*(data+1792);
*(data+1793);
*(data+1794);
*(data+1795);
*(data+1796);
*(data+1797);
*(data+1798);
*(data+1799);
*(data+1800);
*(data+1801);
*(data+1802);
*(data+1803);
*(data+1804);
*(data+1805);
*(data+1806);
*(data+1807);
*(data+1808);
*(data+1809);
*(data+1810);
*(data+1811);
*(data+1812);
*(data+1813);
*(data+1814);
*(data+1815);
*(data+1816);
*(data+1817);
*(data+1818);
*(data+1819);
*(data+1820);
*(data+1821);
*(data+1822);
*(data+1823);
*(data+1824);
*(data+1825);
*(data+1826);
*(data+1827);
*(data+1828);
*(data+1829);
*(data+1830);
*(data+1831);
*(data+1832);
*(data+1833);
*(data+1834);
*(data+1835);
*(data+1836);
*(data+1837);
*(data+1838);
*(data+1839);
*(data+1840);
*(data+1841);
*(data+1842);
*(data+1843);
*(data+1844);
*(data+1845);
*(data+1846);
*(data+1847);
*(data+1848);
*(data+1849);
*(data+1850);
*(data+1851);
*(data+1852);
*(data+1853);
*(data+1854);
*(data+1855);
*(data+1856);
*(data+1857);
*(data+1858);
*(data+1859);
*(data+1860);
*(data+1861);
*(data+1862);
*(data+1863);
*(data+1864);
*(data+1865);
*(data+1866);
*(data+1867);
*(data+1868);
*(data+1869);
*(data+1870);
*(data+1871);
*(data+1872);
*(data+1873);
*(data+1874);
*(data+1875);
*(data+1876);
*(data+1877);
*(data+1878);
*(data+1879);
*(data+1880);
*(data+1881);
*(data+1882);
*(data+1883);
*(data+1884);
*(data+1885);
*(data+1886);
*(data+1887);
*(data+1888);
*(data+1889);
*(data+1890);
*(data+1891);
*(data+1892);
*(data+1893);
*(data+1894);
*(data+1895);
*(data+1896);
*(data+1897);
*(data+1898);
*(data+1899);
*(data+1900);
*(data+1901);
*(data+1902);
*(data+1903);
*(data+1904);
*(data+1905);
*(data+1906);
*(data+1907);
*(data+1908);
*(data+1909);
*(data+1910);
*(data+1911);
*(data+1912);
*(data+1913);
*(data+1914);
*(data+1915);
*(data+1916);
*(data+1917);
*(data+1918);
*(data+1919);
*(data+1920);
*(data+1921);
*(data+1922);
*(data+1923);
*(data+1924);
*(data+1925);
*(data+1926);
*(data+1927);
*(data+1928);
*(data+1929);
*(data+1930);
*(data+1931);
*(data+1932);
*(data+1933);
*(data+1934);
*(data+1935);
*(data+1936);
*(data+1937);
*(data+1938);
*(data+1939);
*(data+1940);
*(data+1941);
*(data+1942);
*(data+1943);
*(data+1944);
*(data+1945);
*(data+1946);
*(data+1947);
*(data+1948);
*(data+1949);
*(data+1950);
*(data+1951);
*(data+1952);
*(data+1953);
*(data+1954);
*(data+1955);
*(data+1956);
*(data+1957);
*(data+1958);
*(data+1959);
*(data+1960);
*(data+1961);
*(data+1962);
*(data+1963);
*(data+1964);
*(data+1965);
*(data+1966);
*(data+1967);
*(data+1968);
*(data+1969);
*(data+1970);
*(data+1971);
*(data+1972);
*(data+1973);
*(data+1974);
*(data+1975);
*(data+1976);
*(data+1977);
*(data+1978);
*(data+1979);
*(data+1980);
*(data+1981);
*(data+1982);
*(data+1983);
*(data+1984);
*(data+1985);
*(data+1986);
*(data+1987);
*(data+1988);
*(data+1989);
*(data+1990);
*(data+1991);
*(data+1992);
*(data+1993);
*(data+1994);
*(data+1995);
*(data+1996);
*(data+1997);
*(data+1998);
*(data+1999);
*(data+2000);
*(data+2001);
*(data+2002);
*(data+2003);
*(data+2004);
*(data+2005);
*(data+2006);
*(data+2007);
*(data+2008);
*(data+2009);
*(data+2010);
*(data+2011);
*(data+2012);
*(data+2013);
*(data+2014);
*(data+2015);
*(data+2016);
*(data+2017);
*(data+2018);
*(data+2019);
*(data+2020);
*(data+2021);
*(data+2022);
*(data+2023);
*(data+2024);
*(data+2025);
*(data+2026);
*(data+2027);
*(data+2028);
*(data+2029);
*(data+2030);
*(data+2031);
*(data+2032);
*(data+2033);
*(data+2034);
*(data+2035);
*(data+2036);
*(data+2037);
*(data+2038);
*(data+2039);
*(data+2040);
*(data+2041);
*(data+2042);
*(data+2043);
*(data+2044);
*(data+2045);
*(data+2046);
*(data+2047);
}

