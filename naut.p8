pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function player(x, y)
	return
	{ x = x, y = y
	, dx = 0, dy = 0

	, move =
function(a)
	local dx, dy = 0, 0
	-- directional input
	if (btn"0") dx -= 4
	if (btn"1") dx += 4
	if (btn"2") dy -= 3
	if (btn"3") dy += 3
	a.dx,a.dy=dx,dy

	-- keep player inside
	a.x=min(max(a.x+dx,-5),120)
	a.y=min(max(a.y+dy,-23),98)
end

	, draw =
function(a)
	spr(001, a.x, a.y, 2, 4)
end
	}
end

function blue(x, y)
	return
	{ x = x, y = y
	, dx = 0, dy = -5

	, move =
function(a)
	a.x += a.dx
	a.y += a.dy
	if a.y < -3 then
		-- clear shot offscreen
		del(actors, a)
	end
end

	, draw =
function(a)
	spr(003, a.x, a.y)
end
	}
end

function _init()
	actors = {}
	pl = player(56, 84)
	pl.shots = 8
	add(actors, pl)
end

function _update()
	if btn"4" and pl.shots>0 then
		-- shooting
		sfx"01"
		pl.shots -= 4
		for i = #actors, 1, -1 do
			actors[i+1] = actors[i]
		end
		local sx = pl.x+3+pl.dx
		local sy = pl.y+24+pl.dy
		actors[1]=blue(sx,sy)
	else
		-- recharging
		pl.shots=min(pl.shots+4,60)
	end

	for actor in all(actors) do
		actor:move()
	end
end

function _draw()
	cls"2"
	for i = #actors, 1, -1 do
		actors[i]:draw()
	end
end
__gfx__
000000000000990000000000001c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099900000000001c1c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000009999000000000c1c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000f94999000000001c1c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000099949f0000000c111c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000f949990000000001c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099949f00000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099999000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099004440099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099900fff0099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999004440099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099990fff0999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099911111999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000991ccc1990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000991c1c1990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009991ccc1999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999911111999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999911711999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999917771999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099911711999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009991119990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001f0202b010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000270302b010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000290302d010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

