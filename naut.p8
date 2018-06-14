pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function _init()
	palt(0, false)
	palt(1, true)
	jeu = new_game()
end

function _update()
	jeu:update()
end

function _draw()
	jeu:draw()
end

function new_game()
	return
	{ player = spawn_player()
	, actors = {}
	, sparks = {}
	, update = update_game
	, draw = draw_game
	}
end

function spawn_player()
	for x = 0, 15 do
		for y = 0, 15 do
			if mget(x, y) == 064 then
				return new_player(x*8, y*8)
			end
		end
	end
end

function update_game(game)
	if game.countin then
		game.countin -= 1
		if game.countin < 1 then
			jeu = new_game()
		end
	else
 	game.player:update()
 	update_all(game.actors)
 	update_all(game.sparks)
 end
end

function update_all(actors)
	for actor in all(actors) do
		actor:update()
	end
end

function draw_game(game)
	cls()
	draw_camera(game)
	draw_all(game.sparks)
	draw_room(game)
	draw_all(game.actors)
	game.player:draw()
end

function draw_all(actors)
	for actor in all(actors) do
		actor:draw()
	end
end

function shake(gx, gy, a)
	if a.hurt and a.hurt > 20 then
		return gx-1+rnd"3",gy-1+rnd"3"
	end
	return gx, gy
end

function draw_camera(game)
	local gx, gy = game.x, game.y
	if gx and gy then
		gx,gy=shake(gx,gy,game.player)
		camera(gx, gy)
	end
end

function draw_room(game)
	local gx, gy = game.x, game.y
	if gx and gy then
		map(gx/8,gy/8,gx,gy,16,16,4)
	end
end
-->8
-- make a delicious table soup!
function mix(tables)
	local soup = {}
	for table in all(tables) do
		for k, v in pairs(table) do
			soup[k] = v
		end
	end
	return soup
end

function point(x, y)
	return {x = x, y = y}
end

function motion(speed, dx, dy)
	return
	{ speed = speed
	, dx = dx or 0
	, dy = dy or 0
	}
end

function hitbox(ox, oy, w, h)
	return {ox=ox,oy=oy,w=w,h=h}
end

function hitpoints(hp)
	return {hp = hp}
end

function methods(table)
	return
	{ update = table.update
	, draw = table.draw
	}
end
-- the player -----------------

player = {}

function new_player(x, y)
	return mix
	{ point(x, y)
	, motion(2)
	, hitbox(2, 0, 3, 7)
	, hitpoints(6)
	, methods(player)
	}
end

function player.update(a)
	load_room(a)
	control_movement(a)
	slide(a)
	jetpack_sparks(a)
	control_shooting(a)
	enemy_damage(a)
end

function player.draw(a)
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

function load_room(a)
	local gx = flr(a.x/128)*128
	local gy = flr(a.y/128)*128
	if gx!=jeu.x or gy!=jeu.y then
		jeu.x = gx
		jeu.y = gy
		jeu.actors = {}
		jeu.sparks = {}
		spawn_enemies(gx, gy)
	end
end

function spawn_enemies(gx, gy)
	for i = 0, 15 do
		for j = 0, 15 do
			local x = gx / 8 + i
			local y = gy / 8 + j
			local n = mget(x, y)
			if fget(n, 0) then
				spawn(n, x*8, y*8)
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

function control_shooting(a)
	a.shooting = a.shooting or 0
	if btn"4" or btn"5" then
		a.f = btn"4"
		a.shooting += 1
		if a.shooting % 4 == 1
		and (not a.hurt or a.hurt < 0)
		then
			sfx"01"
			add(jeu.actors,
			lemon(a.x, a.y, a.f))
		end
	end
end
-->8
-- visual effects

-- kill when timer expires
function expiration(a)
	a.t -= 1
	if a.t < 1 then
		del(jeu.sparks, a)
	end
end

-- player shot hits wall
function plink(x, y, dx)
	local f = dx < 0
	return
	{ x = x - (f and 3 or 2)
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
			add(jeu.sparks,
			spark(a.x, a.y, a.f))
		end
	end
end

function explo(x, y)
	return
	{ x = x
	, y = y
	, t = 6
	, update = expiration
	, draw =
	function(a)
		local f
		if a.t > 4 then
			f = 068
		elseif a.t > 2 then
			f = 069
		else
			f = 070
		end
		spr(f, a.x, a.y)
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
		add(jeu.actors, drone(x, y))
	end
end

function lemon_hit(a, b)
	sfx(02)
	del(jeu.actors, b)
	a.hp -= b.damage
	add(jeu.sparks,explo(b.x,b.y))
end

function lemon_fatality(a)
	sfx(03)
	del(jeu.actors, a)
	local ex = a.x + a.w / 2
	local ey = a.y + a.h / 2
	add(jeu.sparks,explo(ex,ey))
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
			local pl = jeu.player
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
-->8
--------------- collisions ----

-- is tile under pixel solid?
function solid(x, y)
	local tile = mget(x / 8, y / 8)
	if fget(tile, 1) then
		return tile
	end
end

-- does rect overlap any solids?
-- todo: support large actors
function solid_area(x, y, w, h)
	return solid(x, y)
	or solid(x + w, y)
	or solid(x, y + h)
	or solid(x + w, y + h)
end

-- unpack hitbox
function unbox(a)
	return a.x + a.ox, a.y + a.oy,
	a.dx, a.dy, a.w, a.h
end

-- check moving actor on solids
function solid_collide(a)
	local x,y,dx,dy,w,h = unbox(a)
	return
	solid_area(x+dx, y, w, h),
	solid_area(x, y+dy, w, h),
	solid_area(x+dx, y+dy, w, h)
end

-- slide actor along solids
function slide(a)
	local cx, cy
	a.dx /= 4
	a.dy /= 4
	for i = 1, 4 do
		cx, cy = solid_collide(a)
		if (not cx) a.x += a.dx
		if (not cy) a.y += a.dy
	end
	a.dx *= 4
	a.dy *= 4
	return cx, cy
end

function enemy_damage(a)
	if (a.hurt) a.hurt -= 1
	if not a.hurt or a.hurt<1 then
		for b in all(jeu.actors) do
			if b.edamage then
				if touching(a, b) then
					sfx"04"
					a.hp -= b.edamage
					a.hurt = 24
					if a.hp < 1 then
						jeu.countin = 16
					end
				end
			end
		end
	end
end


function xleaving(a)
	local x = jeu.x
	if x then
		return a.x<x or a.x>x+128
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
		local cx, cy = slide(a)
		if cx or cy then
			add(jeu.sparks,
			plink(a.x,a.y,a.dx))
		end
		if cx or cy or xleaving(a) then
			del(jeu.actors, a)
		end
	end

	, draw =
	function(a)
		spr(065, a.x, a.y)
	end
	}
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

function drink_lemonade(a)
	for b in all(jeu.actors) do
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
__gfx__
11111111666666665111511111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111666666661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711711666666661151115111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111666666661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111666666665111511111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711711666666661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111666666661151115111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111666666661111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
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
111771111a111111111a111111177111111111111116611161111116111111111111111111111111111111111111111111111111111111111111111111111111
11170711a0a111111111a11117777771111661111611116111161111111111111111111111111111111111111111111111111111111111111111111111111111
117777111a1111111111111111700711116116111111611111111111111111111111111111111111111111111111111111111111111111111111111111111111
17771111111111111111a11111177111161661616161111611111161111111111111111111111111111111111111111111111111111111111111111111111111
1777777111111111111a111111711711161661616111161616111111111111111111111111111111111111111111111111111111111111111111111111111111
11771111111111111111111117111171116116111116111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11177111111111111111111170711707111661111611116111116111111111111111111111111111111111111111111111111111111111111111111111111111
11171711111111111111111117111171111111111116611161111116111111111111111111111111111111111111111111111111111111111111111111111111
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
0006040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101000001000001000001000001000001010000010000010000010000010000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010000010101010101010101010101000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010001000101010101000101010101000000000000004300000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000101010100000001010101000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010101010000000000000202000000000000000000000000000002020000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000001000000400000000202000000000000004300000000000002020000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000001010101010000000000000202000000000000000000000000000002020000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010000010101010100000001010101000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010001000101010101000101010101000000000000004300000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101000000000000000000000001010101010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010100000000000000010101010101010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101000000000001010101010101010000000000000000000000010000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

