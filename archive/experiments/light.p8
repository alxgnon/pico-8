pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
------------------- player ----

function player(x, y)
	return
	{ x = x
	, y = y
	, d = 0
	, r = 3

	, move = move_player
	, draw = draw_player
	}
end

function aim_player(a)
	a.dx, a.dy = 0, 0
	if (btn"0") a.dx -= 2
	if (btn"1") a.dx += 2
	if (btn"2") a.dy -= 2
	if (btn"3") a.dy += 2
end

function express_player(a)
	if btn"4" then
		a.d += 0.005
	else
		a.d -= 0.005
	end
	
	a.shine = btn"5"
end

function move_player(a)
	aim_player(a)
	a.x += a.dx
	a.y += a.dy
	express_player(a)
end

function draw_ray(a)
	local x1, y1 = a.x, a.y
	local x2 = x1 + cos(a.d) * 256
	local y2 = y1 + sin(a.d) * 256
	local col = 1
	if (a.shine) col = 10
	for i = -16, 16 do
	for j = -16, 16 do
	line(x1, y1, x2+i, y2+j, col)
	end
	end
end

function draw_player(a)
	draw_ray(a)
	circfill(a.x, a.y, a.r, 12)
end

------------------- bullet ----

function border_bullets(n)
	local a = gamestate.player
	for i = 0, n do
		local x, y = rnd(128), 130
		local d = atan2(a.x-x,a.y-y)
		local b = bullet(x,130,d-0.05+rnd(0.1))
		add(gamestate.bullets, b)
	end
end

function bullet(x, y, d)
	return
	{ x = x
	, y = y
	, dx = cos(d)
	, dy = sin(d)
	, draw = draw_bullet
	}
end

function draw_bullet(a)

end
-->8
---------------- gamestate ----

function game()
	return
	{ player = player(50, 50)
	, t = 0
	, bullets = {}

	, move = move_game
	, draw = draw_game
	}
end

function move_game(a)
	a.t += 1
	a.player:move()
	
	border_bullets(rnd(8))
	for b in all(a.bullets) do
		b.x += b.dx
		b.y += b.dy
	end
end

function draw_game(a)
	cls()
	a.player:draw()
	for b in all(a.bullets) do
		if pget(b.x, b.y) == 10 then
			del(a.bullets, b)
		else
			pset(b.x, b.y, 8)
		end
	end
end
-->8
---------------- callbacks ----

function _init()
	gamestate = game()
end

function _update()
	gamestate:move()
end

function _draw()
	gamestate:draw()
end
