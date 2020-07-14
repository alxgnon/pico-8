pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- impish
--

-- resets the cartridge.
function _init()
	tick=0
	wait={[4]=0,[5]=0}
	rel={[4]=false,[5]=false}
	shot={}
	px,py=56,24
	palt(0,false)
	palt(1,true)
end

-- runs the game loop.
function _update()
	tick+=1
	move_shot()
	input()
	move_player()
	shooting(4,-8)
	shooting(5,16)
end

-- moves the shots on screen.
function move_shot()
	for e in all(shot) do
		e.y+=12
		if e.y>138 then
			del(shot,e)
		end
	end
end

-- receives input from player.
function input()
	p_dx,p_dy=0,0
	if(btn"0")p_dx-=5
	if(btn"1")p_dx+=5
	if(btn"2")p_dy-=5
	if(btn"3")p_dy+=5
end

-- moves the player character.
function move_player()
	if p_dx*p_dy!=0 then
		p_dx*=0.707
		p_dy*=0.707
	end
	px=min(max(px+p_dx,-4),117)
	py=min(max(py+p_dy,-4),117)
end

-- controls shooting.
function shooting(n,ox)
	if(wait[n]>0)wait[n]-=1
	if btn(n) then
		if wait[n]==0 and rel[n] then
			add(shot,{x=px+ox,y=py-4})
			wait[n]=88
		end
	end
	rel[n]=not btn(n)
end

-- draws the screen.
function _draw()
	cls()
	map(0,0,7,0,32,32)
	draw_player()
	draw_arm(4,-8)
	draw_arm(5,16)
	for e in all(shot) do
		spr(4,e.x,e.y,1,4)
	end
end

-- draws the player character.
function draw_player()
	if wait[4]*wait[5]==0 then
		spr(2,px,py,2,2)
	else
		spr(34,px,py,2,2)
	end
end

-- draws the player's arm.
function draw_arm(n,ox)
	if wait[n]==0 then
		spr(4,px+ox,py-4,1,4)
	else
		ox+=sgn(ox)*16*wait[n]
		spr(5,px+ox,py-4,1,4)
	end
end
__gfx__
000000000000000011111aaaaa11111111aaa1111199911100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000111aaa888aaa111111aaa1111199911105555555555555555555555555555550000000000000000000000000000000000000000000000000
007007000000000011aaa87888aaa111119991111199911105555555555555555555555555555550000000000000000000000000000000000000000000000000
00077000000000001aaaa88888aaaa11119991111199911105555555555555555555555555555550000000000000000000000000000000000000000000000000
00077000000000001aaaaa888aaaaa11119991111199911105555555555555555555555555555550000000000000000000000000000000000000000000000000
0070070000000000aa000aaaaa000aa1119991111199911105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000aa0c00aaa00c0aa1aaaaaaa19999999105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000aa0cc00000cc0aa1aaaaaaa19999999105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000aa0ccc000ccc0aa1176666111999991105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000aa00cc000cc00aa1176666111999991105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000aaa000000000aaa1176666111999991105555555555555555555555555555550000000000000000000000000000000000000000000000000
00000000000000001aaa0000000aaa11176076111990991105555555555555555555555555555550000000000000000000000000000000000000000000000000
00000000000000001aaaa00000aaaa11176076111990991105555555555555555555555555555550000000000000000000000000000000000000000000000000
000000000000000011aaaa000aaaa111176076111990991105555555555555555555555555555550000000000000000000000000000000000000000000000000
0000000000000000111aaa000aaa1111176076111990991105555555555555555555555555555550000000000000000000000000000000000000000000000000
00000000000000001111111111111111176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000011111aaaaa111111176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000111aaaeeeaaa1111176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000011aaae7eeeaaa111176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001aaaaeeeeeaaaa11176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001aaaaaeeeaaaaa11176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aa000aaaaa000aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aa0000aaa0000aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aa0d0000000d0aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aa0dd00000dd0aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aa00dd000dd00aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000aaa000000000aaa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001aaa0000000aaa11176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001aaaa00000aaaa11176666111999991100000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000011aaaa000aaaa111176666111999991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000111aaa000aaa1111117661111199911100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001111111111111111111711111119111100000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607080906070809060708090607080906070809060708090607080906070809000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617181916171819161718191617181916171819161718191617181916171819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0809060708090607080906070809060708090607080906070809060708090607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819161718191617181916171819161718191617181916171819161718191617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
