pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function set_transparent(col)
	palt(0, false)
	palt(col, true)
end

function _init()
	set_transparent(1)
	player = new_player(25, 25)
end

function travel(a)
	a.x += a.dx
	a.y += a.dy
end

function _update()
	load_room(player)
	control_movement(player)
	travel(player)
	update_sparks(player)

	control_shooting(player)
	for a in all(player.lemons) do
		travel(a)
	end
end

function draw_sprite(a)
	spr(a.n,a.x,a.y,a.w,a.h,a.f)
end

function _draw()
	cls()
	draw_room(player)
	draw_sparks(player)
	for a in all(player.lemons) do
		draw_sprite(a)
	end
	draw_sprite(player)
end
-->8
function new_player(x, y)
	return
	{ n = 000
	, x = x
	, y = y
	, rx = 0
	, ry = 0
	, dx = 0
	, dy = 0
	, w = 1
	, h = 1
	, speed = 2
	, lemons = {}
	, sparks = {}
	}
end

function new_lemon(x, y, f)
	return
	{ n = 001
	, x = x + (f and 3 or 2)
	, y = y + 3
	, dx = f and -3 or 3
	, dy = 0
	, w = 1
	, h = 1
	}
end

function new_spark(x, y, f)
	return
	{ x = x + (f and 6 or 1)
	, y = y + 5
	, t = 16
	}
end

function control_movement(a)
	a.dx, a.dy = 0, 0
	local speed = a.speed
	if (btn"0") a.dx -= speed
	if (btn"1") a.dx += speed
	if (btn"2") a.dy -= speed
	if (btn"3") a.dy += speed
end

function control_shooting(a)
	if btn"4" or btn"5" then
		a.f = btn"4"
		shooting += 1
		if shooting % 4 == 1 then
			sfx"01"
			add(a.lemons,
			new_lemon(a.x, a.y, a.f))
 		end
	else
		shooting = 0
	end
end

function update_sparks(a)
	if a.dx != 0 or a.dy != 0 then
		moving += 1
	else
		moving = 0
	end

	for b in all(a.sparks) do
		b.t -= 1
		if b.t < 1 then
			del(a.sparks, b)
		end
	end

	if moving % 4 == 1 then
		add(a.sparks,
		new_spark(a.x, a.y, a.f))
 end
end

function draw_sparks(a)
	for b in all(a.sparks) do
		pset(b.x, b.y, 7)
	end
end
-->8
function load_room(a)
	local rx = flr(a.x/128)
	local ry = flr(a.y/128)
	if rx!=a.rx or ry!=a.ry then
		a.rx = rx
		a.ry = ry
	end
end

function draw_room(a)
	local x,y = a.rx*128,a.ry*128
	camera(x,y)
	map(x/8,y/8,x,y,16,16)
end
__gfx__
11177111171111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11170711707111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11777711171111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777771111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11771111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11171711111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000414243404142434000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000515253505152535000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000616263606162636000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000717273707172737000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000414243400000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000515253500000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000616263600000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000717273704142434041404040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000041424340005152535051504040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000051525350006162636061604040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000061626360007172737071704040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000071727370000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000040414243000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000050515253000000004040000000404142434041424300000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000060616263000000004040000000505152535051525300000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000070717273000000004040000000606162636061626300000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000040414243000000004040000000707172737071727300000040400000000040414243404142430000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000050515253000000004040000000404142434041424300000040400000000050515253505152530000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000060616263000000004040000000505152535051404142430040400000000060616263606162630000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000070717273000000004040000000606162636061505152530040400000000070717273707172730000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000707172737071606162630040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000707172730040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000404142430000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000040414243404142430000004040000000004041424300000000000040400000000000505152530000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000050515253505152530000004040000000005051525300000000000040400000000000606162630000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000060616263606162630000004040000000006061626300000000000040400000000000707172730000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000070717273707172730000004040000000007071727300000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000040414243404142430000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000050515253505152530000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000060616263606162630000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000070717273707172730000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000004040000000000000000000000000000040
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
__sfx__
00000000000000c2500c2500c2500c2500c2500c25000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002f0502e0402d0302c0202a010290002600020000000000000018100000000000000000000000000000000000000000000000281000000011000000000c00000000110000000000000000000000000000
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

