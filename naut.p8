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
__gfx__
11177111171111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11170711707111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11777711171111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777771111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11771111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11171711111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
