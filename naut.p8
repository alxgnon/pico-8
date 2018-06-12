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
			if mget(x, y) == 068 then
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
		map(x/8,y/8,x,y,16,16,2)
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
			spr(068,x,y,1,1,a.f)
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
						a.x = -rnd"256"
						a.y = -rnd"256"
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
	return x or y
end

function control_shooting(a)
	a.shooting = a.shooting or 0
	if btn"4" or btn"5" then
		a.f = btn"4"
		a.shooting += 1
		if a.shooting % 4 == 1 then
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
		local coll = slide(a)
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
function dust(x,y,dx,dy)
	return
	{ x = x
	, y = y
	, dx = dx
	, dy = dy
	, t = 31

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
			local power = rnd(pow)
			local dx =
				dx and -dx * 0.3 * power
				or cos(o) * power
			local dy = sin(o) * power
			add(sparks,dust(x,y,dx,dy))
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
	a.shake = 3
	a.hp -= b.damage
	expl(b.x, b.y, 16, 0.4, b.dx)
end

function lemon_fatality(a)
	sfx(03)
	del(actors, a)
	local ex = a.x + a.w / 2
	local ey = a.y + a.h / 2
	expl(ex, ey, 1, 0.5)
end

function shake(a)
	if a.shake and a.shake>0 then
		a.shake -= 1
		local x, y = a.x-1, a.y-1
		return x+rnd"3", y+rnd"3"
	else
		return a.x, a.y
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
	, w = 8
	, h = 8
	, hp = 8
	, edamage = 1

	, update =
	function(a)
		drink_lemonade(a)
	end

	, draw =
	function(a)
		spr(067, shake(a))
	end
	}
end
__gfx__
00000000500050006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700005000506666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000500050006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005000506666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
000000001a111111111a111111177111111771110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a0a111111111a11117777771111707110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001a1111111111111111700711117777110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000111111111111a11111177111177711110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700011111111111a111111711711177777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700111111111111111117111171117711110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111170711707111771110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111117111171111717110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0004060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200101010101010101010101000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000044000000000000430000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000004300000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002f0502e0402d0302c0202b010290002600020000000000000018100000000000000000000000000000000000000000000000281000000011000000000c00000000110000000000000000000000000000
00000000206502405021050200501f0501f0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000160532c65027650216501c650186501565013640106000e6002a60027600156001560008600016001360008600086000860007600066000560005600046002a600046000260001600026000000017600
000100002966010073290602b0602f0603006031050000001d0001800016000200001c00014000110000d0000f00025000200001b000180002f0002d0002c0002a00029000270002600017000000000000000000
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

