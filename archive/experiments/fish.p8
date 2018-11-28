pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fish
-- fishy

-- todo: progression

-- tweaks

-- todo: better game over
-- todo: bubbles
-- todo: refactor hitbox


-- fish -----------------------

function make_fish(x, y)
	return {
		x = x,
		y = y,
		dx = 0,
		dy = 0
	}
end

function btn_direction()
	local dx, dy = 0, 0
	if (btn"0") dx -= 1
	if (btn"1") dx += 1
	if (btn"2") dy -= 1
	if (btn"3") dy += 1
	return dx, dy
end

function control_fish(a)
	local dx, dy = btn_direction()
	
	if btnp"4" or btnp"5" then
		a.dx += dx
		a.dy += dy
		a.flipx = a.dx < 0
		
		add(medusas, make_medusa())
		for a in all(medusas) do
			control_medusa(a)
		end
	end
end

function move_fish(a)
	a.x += a.dx
	a.y += a.dy
	a.x %= 128
	a.y = max(min(a.y,125),-2)
	a.dx *= 0.95
	a.dy *= 0.95
end

function draw_fish(a)
	spr(001, a.x, a.y, 1,1,a.flipx)
end


-- medusa ---------------------

function make_medusa()
	return {
		x = 3 + rnd"120",
		y = 128,
		dx = 0,
		dy = 0
	}
end

function control_medusa(a)
	a.dy -= 0.8
end

function move_medusa(a)
	a.x += a.dx
	a.y += a.dy - 0.1
	a.dx *= 0.91
	a.dy *= 0.91
	
	local px,py=player.x,player.y
	if px > a.x - 5 and
			px < a.x + 4 and
			py > a.y - 4 and
			py < a.y + 4 then
		_init()
	end
end

function draw_medusa(a)
	spr(002, a.x, a.y)
end


-- callbacks ------------------

function _init()
	player = make_fish(60, 60)
	medusas = {}
end

function _update()
	control_fish(player)
	move_fish(player)
	
	for a in all(medusas) do
		move_medusa(a)
	end
end

function _draw()
	cls(1)
	draw_fish(player)
	
	for a in all(medusas) do
		draw_medusa(a)
	end
end
__gfx__
00000000000a000000eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a09999000e222e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000a991990e22222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a0999900e22222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000a00000e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
