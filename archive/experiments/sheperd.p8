pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- dog ========================

function make_dog(x, y)
	return {
		x = x,
		y = y,
		flipx = false,
		walkframe = 0
	}
end

function move_dog(a)
	local dx, dy = 0, 0
	
	if btn"0" then
		dx -= 3
		a.flipx = false
	end
	
	if btn"1" then
		dx += 3
		a.flipx = true
	end
	
	if btn"2" then
		dy -= 3
	end
	
	if btn"3" then
		dy += 3
	end
	
	if dx != 0 or dy != 0 then
		a.walkframe += 1
	end

	a.x = min(max(a.x+dx,0),496)
	a.y = min(max(a.y+dy,0),504)
end

function draw_dog(a)
	local sp = 001
	
	if a.walkframe % 6 > 2 then
		sp = 003
	end
	
	spr(sp,a.x,a.y,2,1,a.flipx)
end

-- sheep ======================

function make_sheep()
	local sheep = {}
	
	for i = 1, 50 do
		sheep[i] = {
			x = rnd"503",
			y = rnd"503"
		}
	end
	
	return sheep
end

function move_sheep(sheep)
	for a in all(sheep) do
		local scare = 1 / (
			2 * max(
				abs(a.x - dog.x),
				abs(a.y - dog.y)
			)
		)
		
		a.x += (a.x-dog.x)*scare/rnd(4)
		a.y += (a.y-dog.y)*scare/rnd(4)
		a.x = min(max(a.x,0),503)
		a.y = min(max(a.y,0),503)
	end
end

function draw_sheep(sheep)
	for a in all(sheep) do
		spr(005, a.x, a.y)
	end
end

-- main =======================

function _init()
	dog = make_dog(55, 55)
	sheep = make_sheep()
end

function _update()
	move_dog(dog)
	move_sheep(sheep)
end

function _draw()
	cls()
	camera(dog.x-64,dog.y-64)
	rectfill(0,0,511,511,1)
	draw_sheep(sheep)
	draw_dog(dog)
end
__gfx__
00000000000000000000000000000000000000000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ffff000000004000ffff0000000000777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000ffffffffffff0400ffffffffffff007111111700000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000f1ff44ffffff4400f1ff44ffffff447711117700000000000000000000000000000000000000000000000000000000000000000000000000000000
000770004ff1ff444fffff004ff1ff444fffff047711117700000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700fffff0444ffff000fffff0444ffff0047711117700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000fffff04440000000fffff044400000000777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000440000000000000044000000000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000
