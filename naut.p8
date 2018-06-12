pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function paltswap(old, new)
	palt(old, false)
	palt(new, true)
end

function spawn_player()
	actors = {}
	sparks = {}
	for x = 0, 15 do
		for y = 0, 15 do
			if mget(x, y) == 064 then
				pl = player(x * 8, y * 8)
				add(actors, pl)
				return
			end
		end
	end
end

function _init()
	paltswap(0, 1)
	spawn_player()
end

function _update()
	for a in all(sparks) do
		a:update()
	end
	for a in all(actors) do
		a:update()
	end
end

function draw_map(a)
	local x, y = a.rx, a.ry
	if x and y then
		if a.hurt and a.hurt>20 then
			camera(x-1+rnd"3",y-1+rnd"3")
		else
			camera(x, y)
		end
		map(x/8,y/8,x,y,16,16,4)
	end
end

function _draw()
	cls()
	for a in all(sparks) do
		a:draw()
	end
	draw_map(pl)
	for i = #actors, 1, -1 do
		actors[i]:draw()
	end
end
-->8
function player(x, y)
	return
	{ x = x
	, y = y
	, dx = 0
	, dy = 0
	, ox = 2
	, oy = 0
	, w = 2
	, h = 6
	, hp = 6
	, speed = 2

	, update =
	function(a)
		load_room(a)
		control_movement(a)
		slide(a)
		jetpack_sparks(a)
		control_shooting(a)
		enemy_damage(a)
	end

	, draw =
	function(a)
		local x, y = a.x, a.y
		if a.hp>0
		and a.hurt and a.hurt>0 then
			line(x+1,y-2,x+a.hp,y-2,8)
		end
		if not a.hurt
		or a.hurt < 1
		or a.hurt % 4 < 2 then
			spr(064,x,y,1,1,a.f)
		end
	end
	}
end

function load_room(a)
	local rx = flr(a.x/128)*128
	local ry = flr(a.y/128)*128
	if rx!=a.rx or ry!=a.ry then
		a.rx = rx
		a.ry = ry
		actors = {a}
		spawn_enemies(rx, ry)
	end
end

function spawn_enemies(rx, ry)
	for i = 0, 15 do
		for j = 0, 15 do
			local x = rx / 8 + i
			local y = ry / 8 + j
			local n = mget(x, y)
			if fget(n, 0) then
				spawn(n, x*8, y*8)
			end
		end
	end
end

function enemy_damage(a)
	if (a.hurt) a.hurt -= 1
	if not a.hurt or a.hurt<1 then
		for b in all(actors) do
			if b.edamage then
				if touching(a, b) then
					sfx"04"
					a.hp -= b.edamage
					a.hurt = 24
					if a.hp < 1 then
						a.hurt = 99999
						a.x = -68
						a.y = -68
						a.speed = 0
					end
				end
			end
		end
	end
end

function control_movement(a)
	a.dx, a.dy = 0, 0
	local speed = a.speed
	if (btn"0") a.dx -= speed
	if (btn"1") a.dx += speed
	if (btn"2") a.dy -= speed
	if (btn"3") a.dy += speed
end

function solid(x,y)
	local n = mget(x/8,y/8)
	if fget(n,1) then
		return n
	end
end

-- does rect overlap any solids?
-- todo: support large actors
function solid_area(x,y,w,h)
	return
	solid(x,y) or
	solid(x+w,y) or
	solid(x,y+h) or
	solid(x+w,y+h)
end

-- check moving actors on solids
function solid_collide(a)
	mult = mult or 1
	local x,y=a.x+a.ox,a.y+a.oy
	local w,h=a.w,a.h
	local dx,dy=a.dx,a.dy
	return
	solid_area(x+dx,y,w,h),
	solid_area(x,y+dy,w,h),
	solid_area(x+dx,y+dy,w,h)
end

function slide(a)
	local x, y = solid_collide(a)
	if (not x) a.x += a.dx
	if (not y) a.y += a.dy
	return x, y
end

function control_shooting(a)
	a.shooting = a.shooting or 0
	if btn"4" or btn"5" then
		a.f = btn"4"
		a.shooting += 1
		if a.shooting % 4 == 1
		and (not a.hurt or a.hurt < 0)
		then
			sfx"01"
			add(actors,
			lemon(a.x, a.y, a.f))
		end
	end
end

function lemon(x, y, f)
	return
	{ x = x + (f and 3 or 2)
	, y = y + 3
	, dx = f and -3 or 3
	, dy = 0
	, ox = 0
	, oy = 0
	, w = 2
	, h = 2
	, damage = 1

	, update =
	function(a)
		local x, y = slide(a)
		local coll = x or y
		if coll then
			add(sparks,
			plink(a.x,a.y,a.dx))
		end
		if coll or xleaving(a) then
			del(actors, a)
		end
	end

	, draw =
	function(a)
		spr(065, a.x, a.y)
	end
	}
end

function xleaving(a)
	local x = pl.rx
	if x then
		return a.x<x or a.x>x+128
	end
end
-->8
-- visual effects

-- kill when timer expires
function expiration(a)
	a.t -= 1
	if a.t < 1 then
		del(sparks, a)
	end
end

-- player shot hits wall
function plink(x, y, dx)
	local f = dx < 0
	return
	{ x = x - (f and 3 or 1)
	, y = y - 1
	, f = f
	, t = 2
	, update = expiration
	, draw =
	function(a)
		spr(066,a.x,a.y,1,1,a.f)
	end
	}
end

-- leave sparks while moving
function jetpack_sparks(a)
	if a.dx == 0 and a.dy == 0 then
		a.moving = 0
	else
		a.moving=(a.moving or 0) + 1
		if a.moving % 4 == 1 then
			add(sparks,
			spark(a.x, a.y, a.f))
		end
	end
end

-- explosion dust
function dust(x,y,dx,dy,yellow)
	return
	{ x = x
	, y = y
	, dx = dx
	, dy = dy
	, t = 31
	, yellow = yellow

	, update =
	function(a)
		a.x += a.dx
		a.y += a.dy
		expiration(a)
	end

	, draw =
	function(a)
		if a.t < 9 then
			pset(a.x, a.y, 5)
		elseif a.yellow then
			pset(a.x, a.y, 10)
		else
			pset(a.x, a.y, 6)
		end
	end
	}
end

-- left by player jetpack
function spark(x, y, f)
	return
	{ x = x + (f and 6 or 1)
	, y = y + 5
	, t = 16
	, update = expiration
	, draw =
	function(a)
		if a.t < 6 then
			pset(a.x, a.y, 5)
		else
			pset(a.x, a.y, 6)
		end
	end
	}
end

-->8
function spawn(n, x, y)
	if n == 067 then
		add(actors, drone(x, y))
	end
end

function touching(a, b)
	local ax = a.x + a.ox
	local ay = a.y + a.oy
	local bx = b.x + b.ox
	local by = b.y + b.oy
	return
	ax < bx + b.w and
	bx < ax + a.w and
	ay < by + b.h and
	by < ay + a.h
end

function expl(x,y,odd,pow,dx)
	for o = 0, 1, 0.03 do
		if rnd(odd) < 1 then
			local yellow = dx
			local power = rnd(pow)
			local dx =
				dx and -dx * 0.3 * power
				or cos(o) * power
			local dy = sin(o) * power
			add(sparks,
			dust(x,y,dx,dy,yellow))
		end
	end
end

function drink_lemonade(a)
	for b in all(actors) do
		if b.damage then
			if touching(a, b) then
				lemon_hit(a, b)
				if a.hp < 1 then
					lemon_fatality(a)
				end
			end
		end
	end
end

function lemon_hit(a, b)
	sfx(02)
	del(actors, b)
	a.hp -= b.damage
	expl(b.x, b.y, 9, 0.3, b.dx)
end

function lemon_fatality(a)
	sfx(03)
	del(actors, a)
	local ex = a.x + a.w / 2
	local ey = a.y + a.h / 2
	expl(ex, ey, 2, 0.3)
end

function drone_seeking(a)
	a.t = (a.t or 0) + 1
	if a.t < 1 then
		local x, y = slide(a)
		if (x) a.dx *= -1
		if (y) a.dy *= -1
	else
		a.dx = 0
		a.dy = 0
		if a.t>17 and rnd"22"<2 then
			local o =
			atan2(pl.x-a.x,pl.y-a.y)
			o = o - 0.1 + rnd"0.2"
			a.dx = cos(o) * 2
			a.dy = sin(o) * 2
			a.t = -a.t
		end
	end
end

function drone(x, y)
	return
	{ x = x
	, y = y
	, dx = 0
	, dy = 0
	, ox = 0
	, oy = 0
	, w = 7
	, h = 7
	, t = 0
	, hp = 2
	, edamage = 1

	, update =
	function(a)
		drink_lemonade(a)
		drone_seeking(a)
	end

	, draw =
	function(a)
		spr(067, a.x, a.y)
	end
	}
end
__gfx__
11111111511151116666666677767776111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111116666666666666666111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711711115111516666666676777677111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111111111116666666666666666111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111511151116666666677767776111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711711111111116666666666666666111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111115111516666666676777677111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111116666666666666666111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111771111a111111111a111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11170711a0a111111111a11117777771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
117777111a1111111111111111700711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17771111111111111111a11111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1777777111111111111a111111711711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11771111111111111111111117111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111111111111111111170711707111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11171711111111111111111117111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__gff__
0004060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0303030303030303030303030303030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300101000101010101010101000000303001010001010101010101010000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000444444440303000000000000000000004444444403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300004000000000000000000000000303000000000000000000004444444403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000303000000000000000000004443440003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000303000000000000000000000044440003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000101000000000000000000000044440003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000101000000000000000000004444440003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000101000000000000000000444443000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000303000000000000000000444444440003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000303000000000000004444004444000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300444444000000000000000000000303004444440000000044444443000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0344444444000000444444444400000303444444440000004444444444000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0344444444444444444444000000000303444444444444444444440000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000303000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002f0602e0502d0402c0302b020290002600020000000000000018100000000000000000000000000000000000000000000000281000000011000000000c00000000110000000000000000000000000000
000100002067026160261502414023130211201e100211001e100000000000000000000001420000000016000a600000000000000000000000000000000000000000000000000000000000000230000000000000
00020000376733166027660266602466022660206601e6501b650196401764016630146301262011600246002460024600056000c000046000960004600266000e6002d600000001760000000000000000000000
000100002967010073290702b0702f0703007031060000001d0001800016000200001c00014000110000d0000f00025000200001b000180002f0002d0002c0002a00029000270002600017000000000000000000
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

