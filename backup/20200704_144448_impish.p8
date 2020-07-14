pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- impish
--

-- resets the cartridge.
function _init()
	tick=0
	ready=20
	wait={[4]=0,[5]=0}
	rel={[4]=false,[5]=false}
	shot={}
	mob={}
	px,py=56,24
	palt(0,false)
	palt(1,true)
end

-- runs the game loop.
function _update()
	if(ready>0)ready-=1
	tick+=1
	move_shot()
	move_mob()
	input()
	move_player()
	shooting(4,-8)
	shooting(5,16)
	spawner()
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

-- moves all active mobs.
function move_mob()
	for e in all(mob) do
		e:move()
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

-- spawns enemies to fight.
function spawner()
	if #mob==0 and ready==0 then
		add(mob,pigg())
	end
end

-- draws the screen.
function _draw()
	cls()
	map(0,0,-8,-(tick%32),17,20)
	draw_player()
	draw_arm(4,-8)
	draw_arm(5,16)
	for e in all(shot) do
		spr(1,e.x,e.y,1,4)
	end
	draw_mob()
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

-- draw all active mobs.
function draw_mob()
	for e in all(mob) do
		e:draw()
	end
end

-->8
function pigg()
	return{
		x=56,
		y=128,
		move=function(a)
			a.y=max(a.y-0.25,100)
		end,
		draw=function(a)
			spr(10,a.x,a.y,2,2)
		end
	}
end
__gfx__
000000001177711111111aaaaa11111111aaa1111199911100000000000000000000000000000000111118888811111100000000000000000000000000000000
0000000011777111111aaa888aaa111111aaa1111199911100022222222222222222200000000000111880000088111100000000000000000000000000000000
0070070011ccc11111aaa87888aaa111119991111144411100402020202020202020040000000000118000000000811100000000000000000000000000000000
0007700011ccc1111aaaa88888aaaa11119991111144411102002020202020202020002000000000180000000000081100000000000000000000000000000000
0007700011ccc1111aaaaa888aaaaa11119991111144411102000000000000000000222000000000180000000000081100000000000000000000000000000000
0070070011ccc111aa000aaaaa000aa1119991111144411102220000000000000000002000000000800000000000008100000000000000000000000000000000
0000000077777771aa0c00aaa00c0aa1aaaaaaa19999999102000000000000000000222000000000800880000088008100000000000000000000000000000000
0000000077777771aa0cc00000cc0aa1aaaaaaa19999999102220000000000000000002000000000800808000808008100000000000000000000000000000000
0000000017777711aa0ccc000ccc0aa1176666111999991102000000000000000000222000000000800808000808008100000000000000000000000000000000
0000000017777711aa00cc000cc00aa1176666111999991102220000000000000000002000000000800000000000008100000000000000000000000000000000
0000000017777711aaa000000000aaa117666611199999110200000000000000000022200000000080000eeeee00008100000000000000000000000000000000
00000000177077111aaa0000000aaa111760761119909911022200000000000000000020000000001800ee0e0ee0081100000000000000000000000000000000
00000000177077111aaaa00000aaaa111760761119909911020002020202020202020020000000001800ee0e0ee0081100000000000000000000000000000000
000000001770771111aaaa000aaaa11117607611199099110040020202020202020204000000000011800eeeee00811100000000000000000000000000000000
0000000017707711111aaa000aaa1111176076111990991100022222222222222222200000000000111000000000111100000000000000000000000000000000
00000000177077111111111111111111176076111990991100000000000000000000000000000000111111111111111100000000000000000000000000000000
000000001770771111111aaaaa111111176076111990991102220202020202020202222000000000000000000000000000000000000000000000000000000000
0000000017707711111aaaeeeaaa1111176076111990991102222222222222222222222000000000000000000000000000000000000000000000000000000000
000000001770771111aaae7eeeaaa111176076111990991102222020202020202022222000000000000000000000000000000000000000000000000000000000
00000000177077111aaaaeeeeeaaaa11176076111990991102222222222222222222222000000000000000000000000000000000000000000000000000000000
00000000177077111aaaaaeeeaaaaa11176076111990991102220202020202020202222000000000000000000000000000000000000000000000000000000000
0000000017707711aa000aaaaa000aa1176076111990991102222222222222222222222000000000000000000000000000000000000000000000000000000000
0000000017707711aa0000aaa0000aa1176076111990991102222020202020202022222000000000000000000000000000000000000000000000000000000000
0000000017707711aa0d0000000d0aa1176076111990991102222222222222222222222000000000000000000000000000000000000000000000000000000000
0000000017707711aa0dd00000dd0aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000017707711aa00dd000dd00aa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000017707711aaa000000000aaa1176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177077111aaa0000000aaa11176076111990991100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777111aaaa00000aaaa11176666111999991100000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001777771111aaaa000aaaa111176666111999991100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011777111111aaa000aaa1111117661111199911100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111711111111111111111111111711111119111100000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0607070806070726272728080607070806070708060707080607070806070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1617171816171726272728181617171816171718161717181617171816171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0708060707080626272728070708060707080607070806070708060707080607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1718161717181626272728171718161717181617171816171718161717181617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
