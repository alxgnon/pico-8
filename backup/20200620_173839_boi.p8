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
	start(3,0,83)
	spawn(10,100,91)
	camx=0
	camdx=0
	bills={}
end

function makebills(x,y,n)
		for i=1,n do
			add(bills,{
				r=0,
				dr=-0.125,
				x=x,
				y=y-16-rnd(16),
				dx=-4-rnd(6),
				dy=-2-rnd(4)
			})
		end
		xp+=n*2
		if(xp>(pl+1)*8)pl,xp=pl+1,0
		upgrade(pl,true)
	end

function start(h,l,wp)
	pt=0
	px=31
	py=100
	pz=0
	head=h
	pl=l
	xp=0
	weapon=wp
	upgrade(pl,true)
end

function upgrade(l,player)
	local dc,dl,df,da
	if player then
		dc,dl,df,da=upgr(l)
		chest=19+dc
		arms=18+da*16
		legs=35+dl
		feet=30+df*16
	else
		dc,dl,df,da=upgr(l)
		echest=19+dc
		earms=18+da*16
		elegs=35+dl
		efeet=30+df*16
	end
end

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

function spawn(h,l,wp)
	et=0
	ex=px+177
	ey=100
	ez=0
	ehead=h
	el=l
	eweapon=wp
	upgrade(el)
end

function _update()
	gt+=1
	move()
	follow()
	for b in all(bills) do
		b.x+=b.dx
		b.y+=b.dy
		b.dx=min(b.dx+0.5,0)
		b.dy=min(b.dy+0.5,2)
		b.r=(b.r+b.dr)%4
	end
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
			makebills(ex,ey,3)
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
		if(r==1)spr(1,x,y)
		if(r==2)spr(2,x,y)
		if(r==3)spr(1,x,y,1,1,true)
		if(r==0)spr(2,x,y,1,1,false,true)
	end
end

function draw_hearts()
	spr(71,px-8,48-flr((gt+6)%64/32))
	spr(71,px,48-flr((gt+3)%64/32))
	spr(71,px+8,48-flr(gt%64/32))
	rectfill(px-8,42,px+12,44,3)
	local mxp=(pl+1)*8
	if(xp>0)rectfill(px-8,42,px-8+min(xp,mxp)/mxp*20,44,11)
	print(pl>=10 and flr(pl) or "0"..flr(pl),px+8,py-60,7)
	spr(69,ex-8,48-flr((gt-3)%64/32))
	spr(69,ex,48-flr((gt-6)%64/32))
	spr(69,ex+8,48-flr((gt-9)%64/32))
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
00000000000700000bbbbb000444444409999999055555550ccccccc0eeeeeee0666666607777777007777000000000000000000660000000000000000000000
00000000b33773bb0bbbbb00440040049900900955555555cccccccceeeeeeee6600600677007007077777700044444444444444660000000000000000000000
00700700b37333bb03333300440040049900900959009009c0555000e05550006600600677007007777888870444444444444444666666660000000000000000
00077000b37773bb07377300444444449999999959999999c0055500e00555006666666677777777777800874440000000000000666666660000000000000000
00077000b33373bb77373770444444449000000955555555c0005550e00055506666666677777777777800870444444444444444666666660000000000000000
00700700b37733bb03773700409090909000000955555555c0000555e00005556060606070808080777888870044444444444444660000000000000000000000
000000000007000003333300040909099099990905555555cccccccceeeeeeee0606060607080808077777700000000000000000660000000000000000000000
00000000000000000bbbbb00004444449990099900555550cccccccceeeeeeee0066666600788887007777000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000990000004400440000000000
444000000000444400000044440000444f0000f46600006677000077cc0000ccbb0000bb88000088220000220066666666666666990000004400440000000000
444444400000444400000444444004444f4004f46660066677700777ccc00cccbbb00bbb88800888222002220666666666666666999999994440444000440000
444444400000440000000444444444444f4444f46666666677777777ccccccccbbbbbbbb88888888222222226660000000000000999999994440444044440000
000000000000440000000444042442400ffffff006666660077777700cccccc00bbbbbb008888880022222200666666666666666999999990000000044440000
000000000000440000000044044444400ffffff006666660077777700cccccc00bbbbbb008888880022222200066666666666666990000000000000000000000
000000000000440000000044044444400ffffff006666660077777700cccccc00bbbbbb008888880022222200000000000000000990000000000000000000000
000000000000000000000044044444400ffffff006666660077777700cccccc00bbbbbb008888880022222200000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0000004400440000000000
44400000000044440000004404444440044499400222aa200222aa200333aa30044499400dddaad00dddaad00077777777777777cc0000006600660000000000
444446400000444400000444066666600cccccc008888880099999900bbbbbb00aaaaaa00eeeeee0055555500777777777777777cccccccc6660666000660000
444446400000440000000444066666600cccccc008888880099999900bbbbbb00aaaaaa00eeeeee0055555507770000000000000cccccccc6660666046660000
000000000000440000000444066606600ccc0cc008880880099909900bbb0bb00aaa0aa00eee0ee0055505500777777777777777cccccccc0000000046660000
000000000000660000000044066606600ccc0cc008880880099909900bbb0bb00aaa0aa00eee0ee0055505500077777777777777cc0000000000000000000000
000000000000440000000066066606600ccc0cc008880880099909900bbb0bb00aaa0aa00eee0ee0055505500000000000000000cc0000000000000000000000
000000000000000000000044066006600cc00cc008800880099009900bb00bb00aa00aa00ee00ee0055005500000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000005500550000000000
44400000000044440000004404444440044499400222aa200222aa200333aa30044499400dddaad00dddaad00088888777777777aa0000005500550000000000
44444a400000444400000444066666600cccccc008888880099999900bbbbbb00aaaaaa00eeeeee0055555500888888777777777aaaaaaaa5550555000560000
44444a40000044000000044466666666cccccccc8888888899999999bbbbbbbbaaaaaaaaeeeeeeee555555558880000000000000aaaaaaaa6660666055560000
00000000000044000000044466666666cccccccc8888888899999999bbbbbbbbaaaaaaaaeeeeeeee555555550888888877777777aaaaaaaa0000000055560000
000000000000aa000000004400000000000000000000000000000000000000000000000000000000000000000088887877777777aa0000000000000000000000
0000000000004400000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000444000000006666666066566650330003303300000088000880880000000000000000000000000000000000000088000000cc00cc0000000000
444000000000444400000044666666606656655033303330333000008880888088800000000000000000000000aaaaaaaaaaaaaa88000000cc00cc0000000000
44444b40000044440000044466666660665655603333333033330000888888808888000000000000000000000aaaaaaaaaaaaaaa88888888ccc0ccc000c60000
44444b4000004400000004446666666066656660333333303333000088888880888800000000000000000000aaa00000000000008888888866606660ccc60000
00000000000044000000044466666660655566600333330003330000088888000888000000000000000000000aaaaaaaaaaaaaaa8888888800000000ccc60000
000000000000bb0000000044666666605665566000333000003300000088800000880000000000000000000000aaaaaaaaaaaaaa880000000000000000000000
0000000000004400000000bb55555550555555500003000000030000000800000008000000000000000000000000000000000000880000000000000000000000
00000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000060000000000000009000000000000000c000000000000000a0000000000000008000000000000000000000008800880000000000
44400000000044440000004464444444444444409666666666666660c777777777777770a7777777778888808aaaaaaaaaaaaaa0000000008800880000000000
44444cc0000044440000044460000000000000449000000000000006c000000000000007a000000000000008800000000000000a000000008880888000860000
44444cc0000044000000044464444444444444409666666666666660c777777777777770a7777778788888808aaaaaaaaaaaaaa0000000006660666088860000
00000000000044000000044460000000000000009000000000000000c000000000000000a0000000000000008000000000000000000000000000000088860000
000000000000cc000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cc00000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000066666000000000009999900000000000ccccc00000000000aaaaa00000000000888880000000000000000000aa00aa0000000000
44400000000044440000004404040000000000000606000000000000070700000000000007070000000000000a0a00000000000000000000aa00aa0000000000
44444770000044440000044404040000000000000606000000000000070700000000000007070000000000000a0a00000000000000000000aaa0aaa000a60000
44444770000044000000044404040000000000000606000000000000070700000000000007070000000000000a0a0000000000000000000066606660aaa60000
00000000000044000000044404040000000000000606000000000000070700000000000007070000000000000a0a0000000000000000000000000000aaa60000
00000000000077000000004404040000000000000606000000000000070700000000000007070000000000000a0a000000000000000000000000000000000000
00000000000077000000007704040000000000000606000000000000070700000000000007070000000000000a0a000000000000000000000000000000000000
00000000000000000000007704040000000000000606000000000000070700000000000007080000000000000a0a000000000000000000000000000000000000
00000000000004440000000004040000000000000606000000000000070700000000000007070000000000000a0a000000000000000000007700770000000000
44400000000044440000004404040000000000000606000000000000070700000000000007080000000000000a0a000000000000000000007700770000000000
44444aa0000044440000044404040000000000000606000000000000070700000000000008080000000000000a0a000000000000000000007770777000760000
44444aa0000044000000044404040000000000000606000000000000070700000000000008080000000000000a0a000000000000000000006660666077760000
00000000000044000000044404040000000000000606000000000000070700000000000008080000000000000a0a000000000000000000000000000077760000
000000000000aa000000004404040000000000000606000000000000070700000000000008080000000000000a0a000000000000000000000000000000000000
000000000000aa00000000aa04040000000000000606000000000000070700000000000008080000000000000a0a000000000000000000000000000000000000
0000000000000000000000aa004000000000000000600000000000000070000000000000008000000000000000a0000000000000000000000000000000000000
__map__
4343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
