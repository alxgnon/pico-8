pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- boi
--
function _init()
	palt(0,false)
	gt=0
	state=-1
	for i=0,127 do
		if(rnd(100)>78)mset(i,0,65)
	end
	start()
	spawn(8)
	camx=-1
	camdx=0
end

function start()
	pt=0
	px=31
	py=100
	pz=0
	head=4
	chest=19
	arms=18
	weapon=80
	legs=35
	feet=14
end

function spawn(h,l)
	et=0
	ex=px+176
	ey=100
	ez=0
	ehead=h
	echest=21
	earms=34
	eweapon=82
	elegs=36
	efeet=30
end

function _update()
	gt+=1
	walk()
	follow()
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
		if px>ex-56 then
			state=3
			px=ex-56
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
	spr(2,px-8,40-flr((gt+6)%64/32))
	spr(2,px,40-flr((gt+3)%64/32))
	spr(2,px+8,40-flr(gt%64/32))
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
		spr(legs+1,px,y-12)
		spr(feet+1,px-8,y-12,1,1,true,true)
		spr(feet+1,px+8,y-12)
	else
		spr(legs,px,y-12)
		spr(feet,px,y-4)
	end
end

function draw_arms(y)
	pz=1
	spr(arms,px-8,y-20)
	if pz==1 then
		spr(arms-2,px+8,y-25,1,1,true,true)
		spr(weapon+16,px+9,y-41,1,2,false,true)
	elseif pz==3 then
		spr(arms,px+8,y-20,1,1,true)
		spr(weapon+16,px+8,y-11,1,2)
	else
		spr(arms,px+8,y-20)
		spr(weapon,px+16,y-20,2,1)
	end
end

function draw_ebody(y)
	spr(ehead,ex,y-28,1,1,true)
	spr(echest,ex,y-20,1,1,true)
end

function draw_elegs(y)
	spr(elegs,ex,y-12,1,1,true)
	spr(efeet,ex,y-4,1,1,true)
end

function draw_earms(y)
	spr(earms-2,ex+8,y-20,1,1,true)
	if ez==1 then
		spr(earms-3,ex-8,y-25,1,1,false,true)
		spr(eweapon+16,ex-9,y-41,1,2,true,true)
	elseif ez==3 then
		spr(earms-2,ex-8,y-20)
		spr(eweapon+16,ex-8,y-11,1,2,true)
	else
		spr(earms,ex-8,y-20,1,1,true)
		spr(eweapon,ex-24,y-20,2,1,true)
	end
end
__gfx__
0000000000000000000000000666666604444444099999990ccccccc000000000000000000000000000000000000000000000000000000004400440000000000
000000000007000088000880660060064400400499009009cccccccc000000000000000000000000000000000000000000000000000000004400440000440000
00700700b33773bb88808880660060064400400499009009c0555000000000000000000000000000000000000000000000000000000000004440444044440000
00077000b37333bb88888880666666664444444499999999c0055500000000000000000000000000000000000000000000000000000000004440444044440000
00077000b37773bb88888880666666664444444490000009c0005550000000000000000000000000000000000000000000000000000000000000000000000000
00700700b33373bb08888800606060604090909090000009c0000555000000000000000000000000000000000000000000000000000000000000000000000000
00000000b37733bb00888000060606060409090990999909cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000007000000080000006666660044444499900999cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006600660000000000
444000000000444400000044440000444f0000f46600006677000077000000000000000000000000000000000000000000000000000000006600660000660000
444444400000444400000444444004444f4004f46660066677700777000000000000000000000000000000000000000000000000000000006660666066660000
444444400000440000000444444444444f4444f46666666677777777000000000000000000000000000000000000000000000000000000006660666066660000
000000000000440000000444042442400ffffff00666666007777770000000000000000000000000000000000000000000000000000000000000000000000000
000000000000440000000044044444400ffffff00666666007777770000000000000000000000000000000000000000000000000000000000000000000000000
000000000000440000000044044444400ffffff00666666007777770000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000044044444400ffffff00666666007777770000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44400000000044440000004404444440044499400222aa200222aa20000000000000000000000000000000000000000000000000000000000000000000000000
444446400000444400000444066666600cccccc00888888009999990000000000000000000000000000000000000000000000000000000000000000000000000
444446400000440000000444066666600cccccc00888888009999990000000000000000000000000000000000000000000000000000000000000000000000000
000000000000440000000444066606600ccc0cc00888088009990990000000000000000000000000000000000000000000000000000000000000000000000000
000000000000660000000044066606600ccc0cc00888088009990990000000000000000000000000000000000000000000000000000000000000000000000000
000000000000440000000066066606600ccc0cc00888088009990990000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000044066006600cc00cc00880088009900990000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44400000000044440000004404444440044499400222aa200222aa20000000000000000000000000000000000000000000000000000000000000000000000000
44444a400000444400000444066666600cccccc00888888009999990000000000000000000000000000000000000000000000000000000000000000000000000
44444a40000044000000044466666666cccccccc8888888899999999000000000000000000000000000000000000000000000000000000000000000000000000
00000000000044000000044466666666cccccccc8888888899999999000000000000000000000000000000000000000000000000000000000000000000000000
000000000000aa000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004400000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660665666500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660665665500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660665655600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660666566600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660655566600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666660566556600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555550555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000000000000009000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
64444444444444409666666666666660c77777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000000000000449000000000000006c00000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000
64444444444444409666666666666660c77777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000000000000009000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666000000000009999900000000000ccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040000000000000606000000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00400000000000000060000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
