pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- boi
--
function _init()
	palt(0,false)
	for i=0,127 do
		if(rnd(100)>78)mset(i,0,68)
	end
	gt=0
	state=-1
	start(6,22)
	spawn(5,0)
	camx=0
	camdx=0
end

function start(h,l)
	pt=0
	px=31
	py=100
	pz=0
	head=h
	pl=l
	local dc,dl,df,da=upgrade(l)
	chest=19+dc
	arms=18+da*16
	weapon=83
	legs=35+dl
	feet=30+df*16
end

function spawn(h,l)
	et=0
	ex=px+177
	ey=100
	ez=0
	ehead=h
	el=l
	local dc,dl,df,da=upgrade(l)
	echest=19+dc
	earms=18+da
	eweapon=83
	elegs=35+dl
	efeet=30+df
end

function _update()
	gt+=1
	walk()
	follow()
end

function upgrade(l)
	if(i==0)return 0,0,0,0
	local dc,dl,df,da=0,0,0,0
	for i=1,l do
		if(i%4==1)dc+=1
		if(i%4==2)dl+=1
		if(i%4==3)df+=1
		if(i%4==0)da+=1
	end
	return dc,dl,df,da
end

function walk()
	if state==-1 and gt>2 then
		if not (btn(4) or btn(5)) then
			state=0
		end
	elseif state==0 then
		if btn(4) or btn(5) then
			state=1
		end
	elseif state==1 or state==2 then
		px+=5
		pt=(pt+1)%12
		if px>ex-57 then
			state=3
			px=ex-57
			pt=0
		end
	end
end

function follow()
	if state==1 then
		if px>ex-184 then
			camdx=8
			state=2
		end
	elseif state==2 or state==3 then
		camx=camx+flr(camdx)
		camdx=max(camdx*0.965,0)
		if camx>ex-88 then
			camx=ex-88
			if state==2 then
			 state=4
			end
		end
	end
end

function _draw()
	cls()
	camera(camx,0)
	draw_hearts()
	draw_actors()
	draw_ground()
end

function draw_hearts()
	spr(2,px-8,48-flr((gt+6)%64/32))
	spr(2,px,48-flr((gt+3)%64/32))
	spr(2,px+8,48-flr(gt%64/32))
end

function draw_actors()
	local y=py-7+abs(pt%11-6)
	draw_legs(y)
	y-=flr(gt%128/64-1)
	draw_body(y)
	draw_arms(y)
	y=ey-1
	draw_elegs(y)
	y-=flr((gt-12)%128/64-1)
	draw_ebody(y)
	draw_earms(y)
end

function draw_ground()
	map(0,0,0,100,128,1)
	camera(0,0)
	rectfill(0,108,128,128,5)
end

function draw_body(y)
	spr(head,px,y-28)
	spr(chest,px,y-20)
end

function draw_legs(y)
	if pt%12>1 and pt%12<9 then
		spr(legs+16,px,y-12)
		spr(feet+1,px-8,y-12,1,1,true,true)
		spr(feet+1,px+8,y-12)
	else
		spr(legs,px,y-12)
		spr(feet,px+1,y-4)
	end
end

function draw_arms(y)
	spr(arms,px-8,y-20)
	if pz==1 then
		spr(arms-1,px+8,y-25,1,1,true,true)
		spr(weapon+16,px+9,y-41,1,2,false,true)
	elseif pz==3 then
		spr(arms,px+8,y-20,1,1,true)
		spr(weapon+16,px+8,y-11,1,2)
	else
		spr(arms-2,px+8,y-20)
		spr(weapon,px+16,y-20,2,1)
	end
end

function draw_ebody(y)
	spr(ehead,ex,y-28,1,1,true)
	spr(echest,ex,y-20,1,1,true)
end

function draw_elegs(y)
	spr(elegs,ex,y-12,1,1,true)
	spr(efeet,ex-1,y-4,1,1,true)
end

function draw_earms(y)
	spr(earms,ex+8,y-20,1,1,true)
	if ez==1 then
		spr(earms-1,ex-8,y-25,1,1,false,true)
		spr(eweapon+16,ex-9,y-41,1,2,true,true)
	elseif ez==3 then
		spr(earms,ex-8,y-20)
		spr(eweapon+16,ex-8,y-11,1,2,true)
	else
		spr(earms-2,ex-8,y-20,1,1,true)
		spr(eweapon,ex-24,y-20,2,1,true)
	end
end
__gfx__
0000000000070000880008800666666604444444099999990ccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000b33773bb88808880660060064400400499009009cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00700700b37333bb88888880660060064400400499009009c0555000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b37773bb88888880666666664444444499999999c0055500000000000000000000000000000000000000000000000000000000000000000000000000
00077000b33373bb08888800666666664444444490000009c0005550000000000000000000000000000000000000000000000000000000000000000000000000
00700700b37733bb00888000606060604090909090000009c0000555000000000000000000000000000000000000000000000000000000000000000000000000
000000000007000000080000060606060409090990999909cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000006666660044444499900999cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400440000000000
444000000000444400000044440000444f0000f46600006677000077cc0000ccbb0000bb88000088bb0000bb0000000000000000000000004400440000000000
444444400000444400000444444004444f4004f46660066677700777ccc00cccbbb00bbb88800888bbb00bbb0000000000000000000000004440444000440000
444444400000440000000444444444444f4444f46666666677777777ccccccccbbbbbbbb88888888bbbbbbbb0000000000000000000000004440444044440000
000000000000440000000444042442400ffffff006666660077777700cccccc00bbbbbb0088888800bbbbbb00000000000000000000000000000000044440000
000000000000440000000044044444400ffffff006666660077777700cccccc00bbbbbb0088888800bbbbbb00000000000000000000000000000000000000000
000000000000440000000044044444400ffffff006666660077777700cccccc00bbbbbb0088888800bbbbbb00000000000000000000000000000000000000000
000000000000000000000044044444400ffffff006666660077777700cccccc00bbbbbb0088888800bbbbbb00000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400440000000000
44400000000044440000004404444440044499400222aa200222aa200333aa300dddaad0044499400dddaad00000000000000000000000006600660000000000
444446400000444400000444066666600cccccc008888880099999900bbbbbb00eeeeee00aaaaaa00eeeeee00000000000000000000000006660666000660000
444446400000440000000444066666600cccccc008888880099999900bbbbbb00eeeeee00aaaaaa00eeeeee00000000000000000000000006660666046660000
000000000000440000000444066606600ccc0cc008880880099909900bbb0bb00eee0ee00aaa0aa00eee0ee00000000000000000000000000000000046660000
000000000000660000000044066606600ccc0cc008880880099909900bbb0bb00eee0ee00aaa0aa00eee0ee00000000000000000000000000000000000000000
000000000000440000000066066606600ccc0cc008880880099909900bbb0bb00eee0ee00aaa0aa00eee0ee00000000000000000000000000000000000000000
000000000000000000000044066006600cc00cc008800880099009900bb00bb00ee00ee00aa00aa00ee00ee00000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005500550000000000
44400000000044440000004404444440044499400222aa200222aa200333aa300dddaad0044499400dddaad00000000000000000000000005500550000000000
44444a400000444400000444066666600cccccc008888880099999900bbbbbb00eeeeee00aaaaaa00eeeeee00000000000000000000000005550555000560000
44444a40000044000000044466666666cccccccc8888888899999999bbbbbbbbeeeeeeeeaaaaaaaaeeeeeeee0000000000000000000000006660666055560000
00000000000044000000044466666666cccccccc8888888899999999bbbbbbbbeeeeeeeeaaaaaaaaeeeeeeee0000000000000000000000000000000055560000
000000000000aa000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004400000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000444000000006666666066566650330003300000000000000000000000880000000000000000000000000000000000000000cc00cc0000000000
4440000000004444000000446666666066566550333033300088888888888888888888880000000000000000000000000000000000000000cc00cc0000000000
44444b4000004444000004446666666066565560333333300888888888888888888888888888888800000000000000000000000000000000ccc0ccc000c60000
44444b400000440000000444666666606665666033333330888000000000000000000088888888880000000000000000000000000000000066606660ccc60000
000000000000440000000444666666606555666003333300088888888888888888888888888888880000000000000000000000000000000000000000ccc60000
000000000000bb000000004466666660566556600033300000888888888888888888888800000000000000000000000000000000000000000000000000000000
0000000000004400000000bb55555550555555500003000000000000000000000000008800000000000000000000000000000000000000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000060000000000000009000000000000000c00000000000000000000000000000000000000000000000000000008800880000000000
44400000000044440000004464444444444444409666666666666660c77777777777777000000000000000000000000000000000000000008800880000000000
44444cc0000044440000044460000000000000449000000000000006c00000000000000700000000000000000000000000000000000000008880888000860000
44444cc0000044000000044464444444444444409666666666666660c77777777777777000000000000000000000000000000000000000006660666088860000
00000000000044000000044460000000000000009000000000000000c00000000000000000000000000000000000000000000000000000000000000088860000
000000000000cc000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cc00000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000066666000000000009999900000000000ccccc000000000000000000000000000000000000000000000000000aa00aa0000000000
4440000000004444000000440404000000000000060600000000000007070000000000000000000000000000000000000000000000000000aa00aa0000000000
4444477000004444000004440404000000000000060600000000000007070000000000000000000000000000000000000000000000000000aaa0aaa000a60000
444447700000440000000444040400000000000006060000000000000707000000000000000000000000000000000000000000000000000066606660aaa60000
000000000000440000000444040400000000000006060000000000000707000000000000000000000000000000000000000000000000000000000000aaa60000
00000000000077000000004404040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000
00000000000077000000007704040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000007704040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000
0000000000000444000000000404000000000000060600000000000007070000000000000000000000000000000000000000000000000000aa00aa0000000000
4440000000004444000000440404000000000000060600000000000007070000000000000000000000000000000000000000000000000000aa00aa0000000000
4444288000004444000004440404000000000000060600000000000007070000000000000000000000000000000000000000000000000000aaa0aaa000a60000
444428800000440000000444040400000000000006060000000000000707000000000000000000000000000000000000000000000000000066606660aaa60000
000000000000220000000444040400000000000006060000000000000707000000000000000000000000000000000000000000000000000000000000aaa60000
00000000000088000000002204040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000
00000000000088000000008804040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000008800400000000000000060000000000000007000000000000000000000000000000000000000000000000000000000000000000000
__map__
4343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
