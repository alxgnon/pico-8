pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	px,py=6,0
	step=0
end

function getjoy()
	if(btn"0")return -1,0
	if(btn"1")return 1,0
	if(btn"2")return 0,-1
	if(btn"3")return 0,1
	return 0,0
end

function getdir(dx)
	if(dx<0)return 0
	if(dx>0)return 1
	return 2
end

function check(x,y)
	x=min(max(x,0),15)--127)
	y=min(max(y,0),15)--63)
	return x,y,mget(x,y)
end

function _update()
	step+=1
	local dx,dy=getjoy()
	if dx!=0 or dy!=0 then
		local frame=8+getdir(dx)
		local x,y,t=check(px+dx,py+dy)
		if t==0 then
			mset(px,py,0)
			mset(x,y,frame)
			px,py=x,y
		elseif t>0 and t<6 then
			mset(x,y,t-1)
			mset(px,py,frame)
		elseif t>15 and t<19 then
			if(step%12>0)return
			if(t==16)mset(x,y,17)
			if(t==17)mset(x,y,18)
			if(t==18)mset(x,y,16)
			mset(px,py,frame)
		end
	end
end

function _draw()
	cls()
	map(0,0,0,0,16,16)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000fff000000000000000000000000000000000000000000
000000000d0d0d0e0d0d0d0e0d0d0d0e0d0d0d0e044444440dddddd4000000006600ff0000ff006600f111f00000000005555555555555556666666666555555
0060060000d0d0d000d0d0d000d0d0d000d0d0d0044444440dddddd400000000060ffff00ffff0600ff1b1ff0000000005555555555566666666666666665555
000660000d0d0d0e0d0d0d0e0d0d0d0e0dddddde044444440dddddd400000000660f111ff111f0660ff111ff0000000005555555556666666666666666665555
0006600000d0d0d000d0d0d000d0d0d00dddddde044444440dddddd400000000066f1b1ff1b1f66000fffff00000000005555555666666666666666666665555
006006000d0d0d0e0d0d0d0e0dddddde0dddddde044444440dddddd400000000660f111ff111f066000060000000000005555556666666666666666666666555
0000000000d0d0d00dddddde0dddddde0dddddde044444440dddddd400000000060ffff00ffff060066666660000000005555556666666666666666666666555
000000000e0e0e0e0eeeeeee0eeeeeee0eeeeeee0444444404444444000000006600ff0000ff0066060606060000000005555566666666666666666666666555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555566666666666666666666666655
0eeeeee20eeeeee20eeeeee20e0e0e020e0e0e020e0e0e020e0e0e020eeeeee20000000000000000000000000000000005555666666666666666666666666655
0ee00ee20eee0ee20e000ee200e0e0e000e0e0e000e0e0e000e0e0e20eeeeee20000000000000000000000000000000005555666666666666666666666666655
0e0000e20e0e00e20e00eee20e0e0e020e0e0e020e0e0e020eeeeee20eeeeee20000000000000000000000000000000005555666666666666666666666666655
0e000ee20e0000e20ee000e200e0e0e000e0e0e000e0e0e00eeeeee20eeeeee20000000000000000000000000000000005555666666666666666666666666665
0ee00ee20eee0ee20ee00ee20e0e0e020e0e0e020eeeeee20eeeeee20eeeeee20000000000000000000000000000000005556666666666666666666666666665
0eeeeee20eeeeee20eeeeee200e0e0e00eeeeee20eeeeee20eeeeee20eeeeee20000000000000000000000000000000005556666666666666666666666666665
02222222022222220222222202020202022222220222222202222222022222220000000000000000000000000000000005556666666666666666666666666665
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005566666666666666666666666666665
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005566666666666666666666666666665
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005566666666666666666666666666665
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde000000000000000000000000000000000556666c666666666666666ccccc6665
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde00000000000000000000000000000000055666cc66666666666666cccc6c6665
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde00000000000000000000000000000000055666c6c6666666666666cccc6c6655
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde00000000000000000000000000000000055666c6c6cc66c66666ccccc6cc6655
0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee00000000000000000000000000000000055566c6c6cc66c6666ccccc66c66555
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055556ccccccccccccccccc66cc65555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde00000000000000000000000000000000055555c6cc6c6cccc6cccc66cc655555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005555555566cc666cccc666cc5555555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde000000000000000000000000000000000555555555556ccccccccccc55555555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005555555555555666666655555555555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005555555555555556666555555555555
0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0dddddde0000000000000000000000000000000005555555555555555555555555555555
0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0eeeeeee0000000000000000000000000000000005555555555555555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000
__map__
0000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505051011100505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505051211050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050c0d0e0f0505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505051c1d1e1f0505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505052c2d2e2f0505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505053c3d3e3f0505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
