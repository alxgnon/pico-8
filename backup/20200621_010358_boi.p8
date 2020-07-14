pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- boi
--
function _init()
	for i=0,127 do
		if(rnd(100)>78)mset(i,0,68)
	end
	gt=0
	state=-1
	start(3,0)
	spawn(4,4)
	camx=0
	camdx=0
	bills={}
end

function start(h,l)
	pt=0
	px=31
	py=100
	pz=0
	head=h
	pl=l
	xp=0
	xt=0
	lt=0
	upgrade(pl,true)
end

function spawn(h,l)
	et=0
	ex=px+177
	ey=100
	ez=0
	ehead=h
	el=l
	upgrade(el)
end

function _update()
	gt+=1
	move()
	follow()
	update_bills()
end

function move()
	if state==-1 and gt>2 then
		if not(btn(4) or btn(5)) then
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
	elseif state==3 then
		if btn(4) or btn(5) then
			state=4
			makebills(ex,ey,el)
		end
	elseif state==4 then
		if not(btn(4) or btn(5)) then
			state=3
		end
	end
end

function follow()
	if state==1 then
		if px>ex-184 then
			camdx=8
			state=2
		end
	elseif state==2 then
		camx=camx+flr(camdx)
		camdx=max(camdx*0.965,0)
		if camx>ex-88 then
			camx=ex-88
			if state==2 then
			 state=3
			end
		end
	end
end
-->8
-- draw
function _draw()
	cls()
	palt(0,false)
	camera(camx,0)
	draw_hearts()
	draw_actors()
	draw_ground()
	camera(camx,0)
	palt(0,true)
	for b in all(bills) do
		local r,x,y=flr(b.r),b.x,b.y
		local f=b.t<0 and 14 or 1
		if(r==1)spr(f,x,y)
		if(r==2)spr(f+1,x,y)
		if(r==3)spr(f,x,y,1,1,true)
		if(r==0)spr(f+1,x,y,1,1,false,true)
	end
	xt=max(xt-0.5,0)
	lt=max(lt-0.5,0)
end

function draw_hearts()
	spr(70,px-8,48-flr((gt+6)%64/32))
	spr(70,px,48-flr((gt+3)%64/32))
	spr(70,px+8,48-flr(gt%64/32))
	rectfill(px-8+xt,42,px+6+xt,44,3)
	local text="lv"..flr(pl)
	local mxp=(pl+1)*8
	if lt>0 then
		rectfill(px-8+xt,42,px+6+xt,44,9)
		if xp>0 then
			rectfill(px-8+xt,42,px-8+xt+min(xp,mxp)/mxp*14,44,10)
		end
		print(text,px+8+xt,py-60,10)
	else
		if xp>0 then
			rectfill(px-8+xt,42,px-8+xt+min(xp,mxp)/mxp*14,44,11)
		end
		print(text,px+8+xt,py-60,7)
	end
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
	if lt>0 and lt%6<4 then
		spr(108,px,y-28)
		spr(124,px,y-20)
	else
		spr(head,px,y-28)
		spr(chest,px,y-20)
	end
end

function draw_legs(y)
	if lt>0 and lt%6<4 then
		spr(109,px,y-12)
		spr(76,px+1,y-4)
	else
		if pt%12>1 and pt%12<9 then
			spr(legs+16,px,y-12)
			spr(feet+1,px-8,y-12,1,1,true,true)
			spr(feet+1,px+8,y-12)
		else
			spr(legs,px,y-12)
			spr(feet,px+1,y-4)
		end
	end
end

function draw_arms(y)
	if lt>0 and lt%6<4 then
		spr(75,px-8,y-20)
		spr(73,px+8,y-20)
		spr(71,px+16,y-20,2,1)
	else
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
-->8
-- money
--
function upgr(l)
	local dc,dl,df,da
	l=min(l,26)
	if(i==0)return 0,0,0,0
	dc,dl,df,da=0,0,0,0
	for i=1,l do
		if(i%4==1)dc+=1
		if(i%4==2)dl+=1
		if(i%4==3)df+=1
		if(i%4==0)da+=1
	end
	return dc,dl,df,da
end

function upgrade(l,player)
	local dc,dl,df,da
	local weap=83
	if(l>=4)weap=85
	if(l>=8)weap=87
	if(l>=16)weap=89
	if(l>=20)weap=91
	if player then
		dc,dl,df,da=upgr(l)
		chest=19+dc
		arms=18+da*16
		legs=35+dl
		feet=30+df*16
		weapon=weap
	else
		dc,dl,df,da=upgr(l)
		echest=19+dc
		earms=18+da*16
		elegs=35+dl
		efeet=30+df*16
		eweapon=weap
	end
end

function makebills(x,y,n)
	for i=1,n do
		add(bills,{
			t=11,
			r=0,
			dr=-0.25,
			x=x,
			y=y-16-rnd(16),
			dx=-4-rnd(2),
			dy=-2-rnd(2)
		})
	end
end

function update_bills()
	for b in all(bills) do
		b.x+=b.dx
		b.y+=b.dy
		b.dx=min(b.dx+0.5,0)
		b.dy=min(b.dy+0.5,6)
		b.r=(b.r+b.dr)%4
		b.t-=1
		if b.y>93 then
			del(bills,b)
			xp+=2
			xt=1
			if xp>(pl+1)*8 then
				pl+=1
				xp=0
				lt=18
			end
			upgrade(pl,true)
		end
	end
end
__gfx__
00000000000700000bbbbb000444444409999999055555550ccccccc0eeeeeee0666666607777777007777000000000000000000990000000006000003333300
00000000b33773bb0bbbbb00440040049900900955555555cccccccceeeeeeee6600600677007007077777700066666666666666990000003006603303333300
00700700b37333bb03333300440040049900900959009009c0555000e05550006600600677007007777888870666666666666666999999993060003300000000
00077000b37773bb07377300444444449999999959999999c0055500e00555006666666677777777777800876660000000000000999999993066603306066000
00077000b33373bb77373770444444449000000955555555c0005550e00055506666666677777777777800870666666666666666999999993000603366060660
00700700b37733bb03773700409090909000000955555555c0000555e00005556060606070808080777888870066666666666666990000003066003300660600
000000000007000003333300040909099099990905555555cccccccceeeeeeee0606060607080808077777700000000000000000990000000006000000000000
00000000000000000bbbbb00004444449990099900555550cccccccceeeeeeee0066666600788887007777000000000000000000000000000000000003333300
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000004400440000000000
444000000000444400000044440000444f0000f44600006477000077cc0000ccdd0000dd88000088220000220077777777777777cc0000004400440000000000
444444400000444400000444444004444f4004f44660066477700777ccc00cccddd00ddd88800888222002220777777777777777cccccccc4440444000440000
444444400000440000000444444444444f4444f44666666477777777ccccccccdddddddd88888888222222227770000000000000cccccccc4440444044440000
000000000000440000000444042442400ffffff006666660077777700cccccc00dddddd008888880022222200777777777777777cccccccc0000000044440000
000000000000440000000044044444400ffffff006666660077777700cccccc00dddddd008888880022222200077777777777777cc0000000000000000000000
000000000000440000000044044444400ffffff006666660077777700cccccc00dddddd008888880022222200000000000000000cc0000000000000000000000
000000000000000000000044044444400ffffff006666660077777700cccccc00dddddd008888880022222200000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000004400440000000000
444000000000444400000044044444400444aa400444aa400222aa200444aa400333aa300dddaad00dddaad00088888777777777aa0000004400440000000000
44444640000044440000044406666660066666600cccccc008888880099999900bbbbbb00eeeeee0055555500888888777777777aaaaaaaa6660666000660000
44444640000044000000044406666660066666600cccccc008888880099999900bbbbbb00eeeeee0055555508880000000000000aaaaaaaa6660666044660000
00000000000044000000044406660660066606600ccc0cc008880880099909900bbb0bb00eee0ee0055505500888888877777777aaaaaaaa0000000044660000
00000000000066000000004406660660066606600ccc0cc008880880099909900bbb0bb00eee0ee0055505500088887877777777aa0000000000000000000000
00000000000044000000006604400440066606600ccc0cc008880880099909900bbb0bb00eee0ee0055505500000000000000000aa0000000000000000000000
00000000000000000000004404400440066006600cc00cc008800880099009900bb00bb00ee00ee0055005500000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000005500550000000000
444000000000444400000044044444400444aa400444aa400222aa200444aa400333aa300dddaad00dddaad000aaaaaaaaaaaaaa880000005500550000000000
44444a40000044440000044406666660066666600cccccc008888880099999900bbbbbb00eeeeee0055555500aaaaaaaaaaaaaaa888888885550555000560000
44444a4000004400000004444666666466666666cccccccc8888888899999999bbbbbbbbeeeeeeee55555555aaa0000000000000888888886660666055560000
0000000000004400000004444666666466666666cccccccc8888888899999999bbbbbbbbeeeeeeee555555550aaaaaaaaaaaaaaa888888880000000055560000
000000000000aa0000000044000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaaaa880000000000000000000000
0000000000004400000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000066666660665666508800000088000880a0000000000000000000000000000aaa00000000aa00aa0000000000cc00cc0000000000
44400000000044440000004466666660665665508880000088808880aaaaaaaaaaaaaaa0aaa000000000aaaa000000aaaa00aa0000000000cc00cc0000000000
44444b40000044440000044466666660665655608888000088888880aaaaaaaaaaaaaaaaaaaaaaa00000aaaa00000aaaaaa0aaa000aa0000ccc0ccc000c60000
44444b40000044000000044466666660666566608888000088888880aaaaaaaaaaaaaaa0aaaaaaa00000aa0000000aaaaaa0aaa0aaaa000066606660ccc60000
00000000000044000000044466666660655566600888000008888800a000000000000000000000000000aa0000000aaa00000000aaaa000000000000ccc60000
000000000000bb0000000044666666605665566000880000008880000000000000000000000000000000aa00000000aa00000000000000000000000000000000
0000000000004400000000bb555555505555555000080000000800000000000000000000000000000000aa00000000aa00000000000000000000000000000000
0000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000aa00000000000000000000000000000000
00000000000004440000000060000000000000009000000000000000c000000000000000a0000000000000008000000000000000000000008800880000000000
44400000000044440000004464444444444444409666666666666660c777777777777770a7777777778888808aaaaaaaaaaaaaa0000000008800880000000000
44444cc0000044440000044460000000000000449000000000000006c000000000000007a000000000000008800000000000000a000000008880888000860000
44444cc0000044000000044464444444444444409666666666666660c777777777777770a7777778788888808aaaaaaaaaaaaaa0000000006660666088860000
00000000000044000000044460000000000000009000000000000000c000000000000000a0000000000000008000000000000000000000000000000088860000
000000000000cc000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cc00000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000066666000000000009999900000000000ccccc00000000000aaaaa00000000000888880000aaaaaaa000000009900990000000000
44400000000044440000004404040000000000000606000000000000070700000000000007070000000000000a0a0000aaaaaaaa0aaaaaa09900990000000000
44444770000044440000044404040000000000000606000000000000070700000000000007070000000000000a0a0000aaaaaaaa0aaaaaa09990999000960000
44444770000044000000044404040000000000000606000000000000070700000000000007070000000000000a0a0000aaaaaaaa0aaaaaa06660666099960000
00000000000044000000044404040000000000000606000000000000070700000000000007070000000000000a0a0000aaaaaaaa0aaa0aa00000000099960000
00000000000077000000004404040000000000000606000000000000070700000000000007070000000000000a0a0000aaaaaaaa0aaa0aa00000000000000000
00000000000077000000007704040000000000000606000000000000070700000000000007070000000000000a0a00000aaaaaaa0aa00aa00000000000000000
00000000000000000000007704040000000000000606000000000000070700000000000007080000000000000a0a000000aaaaaa0aa00aa00000000000000000
00000000000004440000000004040000000000000606000000000000070700000000000007070000000000000a0a000000000000000000007700770000000000
44400000000044440000004404040000000000000606000000000000070700000000000007080000000000000a0a0000aa0000aa0aaaaaa07700770000000000
44444aa0000044440000044404040000000000000606000000000000070700000000000008080000000000000a0a0000aaa00aaa0aaaaaa07770777000760000
44444aa0000044000000044404040000000000000606000000000000070700000000000008080000000000000a0a0000aaaaaaaaaaaaaaaa6660666077760000
00000000000044000000044404040000000000000606000000000000070700000000000008080000000000000a0a00000aaaaaa0aaaaaaaa0000000077760000
000000000000aa000000004404040000000000000606000000000000070700000000000008080000000000000a0a00000aaaaaa0000000000000000000000000
000000000000aa00000000aa04040000000000000606000000000000070700000000000008080000000000000a0a00000aaaaaa0000000000000000000000000
0000000000000000000000aa004000000000000000600000000000000070000000000000008000000000000000a000000aaaaaa0000000000000000000000000
__map__
4343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
