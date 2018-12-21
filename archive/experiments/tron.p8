pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- player =====================
function move_player(a)
	if (btn"0" and a.d!=0) a.d=2
	if (btn"1" and a.d!=2) a.d=0
	if (btn"2" and a.d!=1) a.d=3
	if (btn"3" and a.d!=3) a.d=1

	pset(a.x, a.y, 11)

	local x, y = a.x, a.y
	if a.d == 1 then
		y += 1
	elseif a.d == 2 then
		x -= 1
	elseif a.d == 3 then
		y -= 1
	else
		x += 1
	end
	
	x %= 128
	y %= 128
	
	a.rub = min(a.rub+0.25,8)
	
	if pget(x, y) == 11 then
		a.rub -= 1
		if a.rub < 1 then
			a.d = 4
			circfill(a.x, a.y, 4, 0)
		end
	else
		a.x = x
		a.y = y
	end
end

-- callbacks ==================
function clear()
	cls()
	rect(0,0,127,127,1)
end

function _init()
	clear()
	pl = {x=16,y=64,rub=8}
end

function _update()
	if (pl.d==4) return
	move_player(pl)
end

function _draw()
	if (pl.d==4) return
	pset(pl.x, pl.y, 7)
end
