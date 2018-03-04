pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
rylander_dither = {
	0x0000, 0x8000, 0x8020, 0xA020,
	0xA0A0, 0xA8A0, 0xA8A2, 0xAAA2,
	0xAAAA, 0xEAAA, 0xEABA, 0xFABA,
	0xFAFA, 0xFEFA, 0xFEFB, 0xFFFB,
}

planet_colors = {15, 14, 4, 2, 5}

players = {}
planets = {}
shots = {}

local power_limit = 2.0
expl_radius = 15

function player(x, y, col)
	local d = atan2(64-x,64-y,x,y)
	return {
		x = x,
		y = y,
		d = d,
		od = d,
		r = 2,
		power = 1.0,
		col = col,
	}
end

function planet(x, y, r, mass)
	return {
		x = x,
		y = y,
		r = r,
		mass = mass,
	}
end

function shot(x, y, d, v, col)
	return {
		x = x,
		y = y,
		ox = x,
		oy = y,
		dx = cos(d) * v,
		dy = sin(d) * v,
		col = col,
		expl = 0,
	}
end

function _init()
	cls()
	add(planets, planet(64, 64, 20, 150))
	add(players, player(15, 15, 8))
	add(players, player(113, 113, 12))
	playing = 0
end

function collides(shot, other)
	local sx, sy = shot.x, shot.y
	local ox, oy, r = other.x, other.y, other.r
	return sqrt(sqr(ox-sx)+sqr(oy-sy)) < r
end

function sqr(x) return x * x end

function simulate_shot(a)
	a.ox = a.x
	a.oy = a.y
	a.x += a.dx
	a.y += a.dy

	for b in all(players) do
		if collides(a, b) then
			a.expl = 0.01
			a.x = b.x
			a.y = b.y
			a.dx = 0
			a.dy = 0
			del(players, b)
		end
	end

	if a.expl > 0 then
		a.expl += 0.01
		if (a.expl > 0.5) del(shots, a)
		return
	end

	for b in all(planets) do
		local d = atan2(b.x-a.x,b.y-a.y,a.x,a.y)
		local grav = b.mass / abs(sqr(b.x-a.x)+sqr(b.y-a.y))
		a.dx += grav * cos(d)
		a.dy += grav * sin(d)

		if collides(a, b) then
			del(shots, a)
		end
	end

	if a.x < 0 or a.x > 128 or a.y < 0 or a.y > 128 then
		del(shots, a)
	end
end

function _update()
	if playing == 0 then
		for a in all(shots) do
			simulate_shot(a)
		end

		if #shots == 0 then
			playing += 1
		end

		return
	end

	local a = players[playing]
	if (not a) return
	a.od = a.d
	if (btn"0") a.d += 0.005
	if (btn"1") a.d -= 0.005
	if (btn"2") a.power += 0.03
	if (btn"3") a.power -= 0.03

	if(btnp(2, 1)) planets[1].mass += 4
	if(btnp(3, 1)) planets[1].mass -= 4

	a.power = max(min(a.power, 2), 0)

	if not btn"4" then
		hold4 = false
	elseif not hold4 and btn"4" then
		hold4 = true
		playing += 1
	end

	if playing > #players then
		for a in all(players) do
			add(shots, shot(a.x + cos(a.d) * 4, a.y + sin(a.d) * 4, a.d, 2 * a.power, a.col))
		end
		playing = 0
	end
end

function draw_players()
	for i, a in pairs(players) do
		line(a.x, a.y, a.x + cos(a.od) * 7, a.y + sin(a.od) * 7, 0)
		line(a.x, a.y, a.x + cos(a.d) * 7, a.y + sin(a.d) * 7, a.col)
		circfill(a.x, a.y, a.r, a.col)

		if i == playing then
			circfill(a.x, a.y, 1, 0)
		end
	end
end

function draw_planets()
	for a in all(planets) do
		local dither_idx = flr((a.mass/4)%16 + 1)
		local color_idx = flr((a.mass/4)/16 + 1)
		local color1 = planet_colors[min(color_idx, #planet_colors)]
		local color2 = planet_colors[min(color_idx + 1, #planet_colors)]
		local dither = rylander_dither[dither_idx]

		local color = color1 + (color2 * 0x10)
		fillp(dither)
		circfill(a.x, a.y, a.r, color)
		print(a.mass, a.x - 5, a.y - 2, 0)
		fillp(0)
	end
end

function maybe_clear()
	if playing == 0 then
		if not cleared then
			cls()
			cleared = true
		end
	else
		cleared = false
	end
end

function _draw()
	maybe_clear()

	for a in all(shots) do
		if (a.expl == 0) then
			line(a.ox, a.oy, a.x, a.y, a.col + 1)
		else
			if (a.expl > 0.25) circfill(a.x, a.y, expl_radius, 0)
			circfill(a.x, a.y, expl_radius * -sin(a.expl), a.col + 1)
		end
	end

	draw_planets()

	draw_players()

	local a = players[playing]
	if a then
		rectfill(0, 0, 128, 3, 10)
		rectfill(a.power * (128/power_limit), 0, 128, 3, 0)
	end
end
