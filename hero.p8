pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- hero
-- i want to make a videogame!
--

-- player ---------------------

function init_player(x,y)
	return{
		e=001,
		x=x,
		y=y,
		speed=3
	}
end

function move_player(a)
	local dx,dy=pad(a.speed)
	a.x=a.x+dx
	a.y=a.y+dy
end

function pad(speed)
	local dx,dy=0,0
	if(btn"0")dx-=speed
	if(btn"1")dx+=speed
	if(btn"2")dy-=speed
	if(btn"3")dy+=speed
	return dx,dy
end

function camera_player(a)
	camera(flr(a.x/128)*128,
		flr(a.y/128)*128)
end

function draw_player(a)
	spr(a.e,a.x,a.y)
end

-- main -----------------------

function _init()
	pl=init_player(32,32)
end

function _update()
	move_player(pl)
end

function _draw()
	cls()
	camera_player(pl)
	draw_player(pl)
end
__gfx__
00000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
