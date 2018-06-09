pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function spawn(a)
	add(actors, a)
end

function control_drive(a)
	a.dx, a.dy = 0, 0
	if (btn"0") a.dx -= a.speed
	if (btn"1") a.dx += a.speed
	if (btn"2") a.dy -= a.speed
	if (btn"3") a.dy += a.speed
end

function cast_charm(a)
	sfx"01"
	a.power -= 4
	spawn(charm(a.x+2,a.y+12,-1.5))
	spawn(charm(a.x+16,a.y+12,1.5))
end

function cast_spell(a)
	sfx"02"
	a.power -= 4
	spawn(spell(a.x+2,a.y+10))
	spawn(spell(a.x+17,a.y+10))
end

function cast_grace(a)
	sfx"03"
	a.power -= 4
	spawn(grace(a.x+9,a.y-8))
end

function casting(a)
	if a.power > 0 then
		if btn"4" and btn"5" then
			cast_grace(a)
		elseif btn"4" then
			cast_charm(a)
		elseif btn"5" then
			cast_spell(a)
		end
	end
end

function softwall(a,x1,y1,x2,y2)
	a.x = min(max(a.x, x1), x2)
	a.y = min(max(a.y, y1), y2)
end

function refill_power(a)
	a.power += a.refill
	a.power=min(a.power,a.maxpower)
end

function player(x, y)
	return
	{ f = 001
	, x = x, y = y
	, dx = 0, dy = 0
	, w = 3, h = 4
	, speed = 5
	, power = 8
	, maxpower = 8
	, refill = 4
	}
end

function charm(x, y, dx)
	return
	{ f = 004 + rnd"4"
	, x = x, y = y
	, dx = dx, dy = -7
	, w = 1, h = 1
	}
end

function spell(x, y)
	return
	{ f = 020 + rnd"4"
	, x = x, y = y
	, dx = 0, dy = -9
	, w = 1, h = 1
	}
end

function grace(x, y)
	return
	{ f = 036 + rnd"4"
	, x = x, y = y
	, dx = 0, dy = -9
	, w = 1, h = 1
	}
end

function _init()
	gt = 0

	pl = player(52, 84)

	actors = {}
	add(actors, pl)
end

function _update()
	gt += 1

	control_drive(pl)

	for a in all(actors) do
		if a.x < -88
		or a.x > 188
		or a.y < -88
		or a.y > 188 then
			del(actors, a)
		end

		a.x += a.dx
		a.y += a.dy
	end

	softwall(pl,-10,-24,115,101)
	casting(pl)
	refill_power(pl)
end

function _draw()
	cls()
	for a in all(actors) do
		spr(a.f, a.x, a.y, a.w, a.h)
	end
end
__gfx__
00000000000000000000000000000000099900000999000009990000099900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000009aaa900099a9900099a990009aaa90000000000000000000000000000000000000000000000000000000000000000000
007007000000000003300000000000009a9a900099a990009aaa900099a990000000000000000000000000000000000000000000000000000000000000000000
000770000000000003330000000000009a9a90009aaa900099a9900099a990000000000000000000000000000000000000000000000000000000000000000000
00077000000000000333300000000000099900000999000009990000099900000000000000000000000000000000000000000000000000000000000000000000
0070070000000000b313330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000033313b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000b313330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000033313b000000000099000000990000009900000099000000000000000000000000000000000000000000000000000000000000000000000
000000000000000003333300000000009a9900009aa900009aa9000099a900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000333000000000009aa900009a99000099a900009aa900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000bbb0000000000099a9000099a900009aa9000099a900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000111000000000009aa900009a99000099a900009aa900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000bbb000000000009a9900009aa9000099a900009a9900000000000000000000000000000000000000000000000000000000000000000000
00000000000000000011100000000000099000000990000009900000099000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000011100000000000099900000999000009990000099900000000000000000000000000000000000000000000000000000000000000000000
000000000000000000bbb000000000009aaa90009aaa90009aaa9000999990000000000000000000000000000000000000000000000000000000000000000000
000000000000000000111000000000009aaa9000999990009aaa90009aaa90000000000000000000000000000000000000000000000000000000000000000000
000000000000bbbb00bbb00bbbb000009aaa90009aaa900099999000999990000000000000000000000000000000000000000000000000000000000000000000
00000000000bb1b130111031b1bb00009aaa9000999990009aaa90009aaa90000000000000000000000000000000000000000000000000000000000000000000
0000000000b1b1b133333331b1b1b0009aaa90009aaa90009aaa9000999990000000000000000000000000000000000000000000000000000000000000000000
000000000bb1b1b133333331b1b1bb009aaa900099999000999990009aaa90000000000000000000000000000000000000000000000000000000000000000000
00000000b1b1b1b131111131b1b1b1b0099900000999000009990000099900000000000000000000000000000000000000000000000000000000000000000000
00000000b1b1b1b131e1e131b1b1b1b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b1b1b00031eee13000b1b1b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b1b00003311e11330000b1b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b000003331111133300000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000003333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000003000333330003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001f01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001a01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001d01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000

