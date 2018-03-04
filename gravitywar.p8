pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
players = {}
planets = {}
shots = {}

function player(x, y, col)
	local d = atan2(64-x,64-y,x,y)
	return {
		x = x,
		y = y,
		d = d,
		od = d,
		r = 2,
		col = col,
	}
end

function planet(x, y, r)
	return {
		x = x,
		y = y,
		r = r,
		mass = 1,
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
	}
end

function _init()
	cls()
	add(planets, planet(64, 64, 20))
	add(players, player(15, 15, 8))
	add(players, player(113, 113, 12))
	playing = 0
end

function collides(shot, other)
	local sx, sy = shot.x, shot.y
	local ox, oy, r = other.x, other.y, other.r
	return sqrt((ox-sx)*(ox-sx)+(oy-sy)*(oy-sy)) < r
end

function _update()
	if playing == 0 then
		for a in all(shots) do
			a.ox = a.x
			a.oy = a.y
			a.x += a.dx
			a.y += a.dy

			for b in all(players) do
				if collides(a, b) then
					del(shots, a)
					del(players, b)
				end
			end

			for b in all(planets) do
				if collides(a, b) then
					del(shots, a)
				end
			end

			if a.x < 0 or a.x > 128 or a.y < 0 or a.y > 128 then
				del(shots, a)
			end
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

	if not btn"4" then
		hold4 = false
	elseif not hold4 and btn"4" then
		hold4 = true
		playing += 1
	end

	if playing > #players then
		for a in all(players) do
			add(shots, shot(a.x, a.y, a.d, 2, a.col))
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
		line(a.ox, a.oy, a.x, a.y, a.col + 1)
	end

	for a in all(planets) do
		circfill(a.x, a.y, a.r, 15)
	end

	draw_players()
end
