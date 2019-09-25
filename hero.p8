pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- hero --------------------

function move_hero(a)
	local dx,dy=0,0
	if(btn"0")dx=-3
	if(btn"1")dx=3
	if(btn"2")dy=-3
	if(btn"3")dy=3
	if(btn"4")a.f=true
	if(btn"5")a.f=false
	a.x+=dx
	a.y+=dy
	walls_hero(a)
end

function walls_hero(a)
	a.x=min(max(a.x,-1),121)
	a.y=max(a.y,1)
	if a.y>528 then
		lv+=1
		a.y=1
	end
end

function camera_hero(a)
	camera(0,min(max(a.y-32,-16),384))
end

function draw_hero(a)
	spr(001,a.x,a.y,1,1,a.f)
end

-- callbacks ---------------

function _init()
	lv=0
	pl={x=16,y=16}
end

function _update()
	move_hero(pl)
end

function _draw()
	cls()
	camera_hero(pl)
	rect(0,0,127,512,07)
	map(lv*16,0,0,0,16,64)
	draw_hero(pl)
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
