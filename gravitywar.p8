pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
players = {}
planets = {}
shots = {}

function player(x, y, col)
	return {
		x = x,
		y = y,
		d = 0,
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
	add(planets, planet(64, 64, 20))
	add(players, player(15, 15, 8))
	add(players, player(113, 113, 12))
	playing = 1
end

function _update()
	if playing == 0 then
		for a in all(shots) do
			a.ox = a.x
			a.oy = a.y
			a.x += a.dx
			a.y += a.dy
		end
		return
	end

	local a = players[playing]
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
		circfill(a.x, a.y, 2, a.col)
		line(a.x, a.y, a.x + cos(a.d) * 6, a.y + sin(a.d) * 6, a.col)

		if i == playing then
			circfill(a.x, a.y, 1, 0)
		end
	end
end

function _draw()
	if playing == 0 then
		for a in all(shots) do
			line(a.ox, a.oy, a.x, a.y, a.col + 1)
		end
	else
		cls()
	end

	for a in all(planets) do
		circfill(a.x, a.y, a.r, 15)
	end

	draw_players()
end
