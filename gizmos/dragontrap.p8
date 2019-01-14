pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	palt(0,false)
	palt(1,true)
end

function _draw()
	cls()
	map(0,0,0,0,16,16)
	spr(000,38,64,4,4)
end
__gfx__
11111111111111111111111111111111000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111044444444444440011111111111111111111111111111111111111111111111111111111111111111111111111111111
11117111111111111111111111111111444444444444040011111111111111111111111111111111111111111111111111111111111111111111111111111111
11167611111111111111111111111111444444444404000011111111111111111111111111111111111111111111111111111111111111111111111111111111
11567651111111111111111111111111444444444440000011111111111111111111111111111111111111111111111111111111111111111111111111111111
11567651111111111111111111111111444440404404000011111111111111111111111111111111111111111111111111111111111111111111111111111111
1156765113333bbb11b1111111111111440404040400000011111111111111111111111111111111111111111111111111111111111111111111111111111111
1156765333333333bbb1111111111111400000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111
115676533333333333b1111111111111000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111
115676533333999333bb1111111111110ffffffffffffff911111111111111111111111111111111111111111111111111111111111111111111111111111111
1156765333b99999933b1111111111110ff9f9f9f9f9f9f411111111111111111111111111111111111111111111111111111111111111111111111111111111
1156765333b22299933b1111111111110f9f9f9f9f9f9f9411111111111111111111111111111111111111111111111111111111111111111111111111111111
115676593b97777977931111111111110ff9f9f99999999411111111111111111111111111111111111111111111111111111111111111111111111111111111
1156765f3977770907711111111111110f9f99999999999411111111111111111111111111111111111111111111111111111111111111111111111111111111
11567659b977770f07711111111111110f9494949494949411111111111111111111111111111111111111111111111111111111111111111111111111111111
11567653b97777797773b11111111111094444444444444411111111111111111111111111111111111111111111111111111111111111111111111111111111
22288888b99777fff288888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
12222220b99fffff2856776811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
112288033599ffff2858282811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
119999f9667999992826776811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1199f995665555952856776811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1199ff95556777562858282811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11199905556667062826776811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11122805655665652856776811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111156765656765285668111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111167650056765028881111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111665ff5567653f9111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111119fffff56765ffb111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111399fff91565bbbb311111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111333999911133bbbb311111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11113b3333311133bbb3331111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111113bbbb1111133bbbbb1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1415141514151415141514151415141500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1514151415141514151415141514151400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011d000036440364223642236422344403442233440334222f4402f4222f4222f4222f4222f420364403642236422364203b4403b4223a4403a42238440384223344033422334223342233422334223342033420
011d00003444034422334402f4402f4222f4222c4402c422344403442233440344403442234422364403642233440334223342233422334223342233422334223342233422334223342233422334223342033420
011d00003444034422334402f4402f4222f4222c4402c422344403442233440334222f4402f42231440314222f4402f4222f4222f4222f4222f4222f4222f4222f4222f4222f4222f4222f4222f4222f4202f420
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003535000000000000000000000000000000000000000000000000000
__music__
00 40420044
00 41420144
00 41420044
00 41420244

