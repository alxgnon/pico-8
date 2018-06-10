pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- astrodragonaut
-- ::::::::::::::

function _init()
	gt = 0
	pl = player(52, 84)
	shots = {}
	bads = {}
	eshots = {}
end

function _update()
	gt += 1

	drive(pl)

	for a in all(shots) do
		a.x += a.dx
		a.y += a.dy
		if a.y < -5 then
			del(shots, a)
		end
	end

	for a in all(bads) do
		a:update()
	end

	for a in all(eshots) do
		a.x += a.dx
		a.y += a.dy
		if a.x < -40 or a.x > 168
		or a.y < -40 or a.y > 168
		then
			del(eshots, a)
		end
	end

	softwall(pl,-10,-24,115,101)
	casting(pl)
	refill_power(pl)
end

function _draw()
	cls()
	spr(pl.f,pl.x,pl.y,pl.w,pl.h)
	for a in all(shots) do
		spr(a.f,a.x,a.y,a.w,a.h)
	end
	for a in all(bads) do
		a:draw()
	end
	for a in all(eshots) do
		spr(a.f,a.x,a.y,a.w,a.h)
	end
	print(#shots + #bads + #eshots)
end
-->8
function player(x, y)
	return
	{ f = 000
	, x = x
	, y = y
	, dx = 0
	, dy = 0
	, w = 3
	, h = 4
	, speed = 5
	, power = 8
	, maxpower = 8
	, refill = 4
	}
end

function drive(a)
	a.dx, a.dy = 0, 0
	if (btn"0") a.dx -= a.speed
	if (btn"1") a.dx += a.speed
	if (btn"2") a.dy -= a.speed
	if (btn"3") a.dy += a.speed
	a.x += a.dx
	a.y += a.dy
end

function softwall(a,x1,y1,x2,y2)
	a.x = min(max(a.x, x1), x2)
	a.y = min(max(a.y, y1), y2)
end

function refill_power(a)
	a.power += a.refill
	a.power=min(a.power,a.maxpower)
end

function casting(a)
	if a.power > 0 then
		if btn"4" and btn"5" then
			if gt % 12 < 6 then
				cast_charm(a)
			else
				cast_spell(a)
			end
		elseif btn"4" then
			cast_charm(a)
		elseif btn"5" then
			cast_spell(a)
		end
	end
end

-- charm charm charm charm
function cast_charm(a)
	sfx"01"
	a.power -= 4
	add(shots,
	charm(a.x+2,a.y+12,-1.5))
	add(shots,
	charm(a.x+16,a.y+12,1.5))
end
function charm(x, y, dx)
	return
	{ f = 003 + rnd"4"
	, x = x
	, y = y
	, dx = dx
	, dy = -7
	, w = 1
	, h = 1
	}
end

-- spell spell spell spell
function cast_spell(a)
	sfx"02"
	a.power -= 4
	add(shots,
	spell(a.x+2,a.y+10))
	add(shots,
	spell(a.x+17,a.y+10))
end
function spell(x, y)
	return
	{ f = 019 + rnd"4"
	, x = x
	, y = y
	, dx = 0
	, dy = -9
	, w = 1
	, h = 1
	}
end
__gfx__
00000000000000000000000009990000099900000999000009990000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000009aaa900099a9900099a990009aaa9000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003300000000000009a9a900099a990009aaa900099a99000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003330000000000009a9a90009aaa900099a9900099a99000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033330000000000009990000099900000999000009990000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b31333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033313b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b31333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033313b00000000009900000099000000990000009900000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003333300000000009a9900009aa900009aa9000099a90000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000333000000000009aa900009a99000099a900009aa90000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbb0000000000099a9000099a900009aa9000099a90000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000333000000000009aa900009a99000099a900009aa90000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbb000000000009a9900009aa9000099a900009a990000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003330000000000009900000099000000990000009900000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbb00bbb00bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bb3b330333033b3bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b3b3b333333333b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb3b3b333333333b3b3bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b3b3b331111133b3b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b3b3b331e1e133b3b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b3b00031eee13000b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b00003311e11330000b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b000003331111133300000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000300033333000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888800000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888800000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000000000088828888800000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088800000088828882288888882288000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888088888888228888111888222800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888882811222112222280
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888811118888111212111822222
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888881122211118111222111182228
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088111121211188811111111882218
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888811122218888822111128222218
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888888882888221212280
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888111111182888811222880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088880888111112221111188888888880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088800088881112121118888888800800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000088888882221888880800800800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888228888888800800000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008822222222880000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008822222222800000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008822822228800000000000080000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888288222228880800000080088000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000882228882228888800800088088000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000228882288888280220288828800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002288888888288228888800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008880088008888880000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008242200042222000804008000820000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002228820882888202288848802428288
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088822248482824808288228828288448
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028248822484882800882288228248282
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028842880228288282288428242248222
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084482828028882488822288808222888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082228822822882880228842022288488
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088480040028800008280000228880
__label__
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000009900000999000009900000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009a9900099aa90009a990000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009aa90009aaa90009aa90000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000099a90009aa9900099a90000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009aa90009aaa90009aa90000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009a9900099aa90009a990000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000009900009aaa900009900000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000009990000000000000000000000000000000000000000000000099900000000000000000000000000000000000000
00000000000000000000000000000000000099a9900000000000000000000099900000000000000000000099a990000000000000000000000000000000000000
00000000000000000000000000000000000099a99000000000000000000009aaa9000000000000000000009aaa90000000000000000000000000000000000000
0000000000000000000000000000000000009aaa9000000000000000000009aaa90000000000000000000099a990000000000000000000000000000000000000
00000000000000000000000000000000000009990000000000000000000009aa9900000000000000000000099900000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000009990000000000000000000099aa900000000000000000009990000000000000000000000000000000000000000
00000000000000000000000000000000000009aaa90000000000000000000099900000000000000000009aaa9000000000000000000000000000000000000000
00000000000000000000000000000000000009a9a90000000000000000000000000000000000000000009a9a9000000000000000000000000000000000000000
00000000000000000000000000000000000009a9a90000000000000000000099900000000000000000009a9a9000000000000000000000000000000000000000
00000000000000000000000000000000000000999000000000000000000009aaa900000000000000000009990000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aa9900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aa9900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aa9900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000999000000000000000000000000009990000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000099a9900000000000000000000000099a99000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009aaa900000000000000000000000099a99000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000099a990000000000000000000000009aaa9000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000999000000000000000000000000009990000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aa9900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099aa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000099a9900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aaa900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000009aa9900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000009900000999000009900000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009aa90009aa990009a990000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000099a900099aa90009aa90000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000009aa90009aaa900099a90000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000099a900099a990009aa90000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000099a90009aaa90009a990000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000009900009aa9900009900000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000003330000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000003333000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000b3133300000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000033313b0000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000b3133300000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000033313b0000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000003333300000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000333000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000bbbb00bbb00bbbb000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000bb1b130111031b1bb00000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000b1b1b133333331b1b1b0000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000bb1b1b133333331b1b1bb000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b1b1b1b131111131b1b1b1b00000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b1b1b1b131e1e131b1b1b1b00000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b1b1b00031eee13000b1b1b00000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b1b00003311e11330000b1b00000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b000003331111133300000b00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000033333333333330000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000030003333300030000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000333000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000000
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

