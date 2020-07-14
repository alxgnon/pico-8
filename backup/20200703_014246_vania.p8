pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- vania
--
function _init()
	state=game()
end

function _update()
	update_game(state)
end

function _draw()
	draw_game(state)
end


-- game -----------------------

function game()
	prepare_world(128,64)
	return{
		hero=hero(32,480),
		cam={x=0,y=0}
	}
end

function update_game(a)
	update_hero(a.hero)
	update_cam(a.cam,a.hero)
end

function draw_game(a)
	cls()
	draw_cam(a.cam)
	map(0,0,0,0,128,64,5)
	draw_hero(a.hero)
	map(0,0,0,0,128,64,2)
end


-- world ----------------------

function prepare_world(w,h)
	for i=0,w-1 do
		for j=0,h-1 do
			if mget(i,j)==1 then
				if rnd(99)>94 then
					mset(i,j,3)
				elseif rnd(99)>76 then
					mset(i,j,2)
				end
			end
		end
	end
end


-- cam ------------------------

function update_cam(a,b)
	a.x=min(max(b.x-60,0),896)
	a.y=min(max(b.y-56,0),384)
end

function draw_cam(a)
	camera(a.x,a.y)
end
-->8
-- hero -----------------------
--

function hero(x,y)
	return{
		x=x,
		y=y,
		f=52,
		dx=0,
		dy=3,
		t=0,
		air_t=10,
		dash_t=0,
		hat=36+flr(rnd(2)),
		tail={}
	}
end

function update_hero(a)
	player_input(a)
	update_physics(a)
	animate_hero(a)
	physics_timer(a)
	dash_tail(a)
end


-- physics --------------------

function update_physics(a)
	horiz_movement(a)
	vert_movement(a)
	apply_friction(a)
	apply_gravity(a)
end

function horiz_movement(a)
	if a.dy<0 then
		a.x=collide(a,a.dy,a.dy-11,true)
	elseif abs(a.dx)>=1 then
		a.x=collide(a,a.x,a.dx)
	end
	a.x=min(max(a.x,0),1017)
	if a.x==0 or a.x==1017 then
		a.dash_t=0
	end
end

function vert_movement(a)
	if a.dy<0 then
		a.y=collide(a,a.y-11,a.dy,true)+11
	else
		local oy=a.y
		local land=a.land
		a.y=collide(a,a.y,a.dy,true)
		if land and not a.land then
			a.air_t=0
			a.dy=3
		end
		if a.air_t<3 and oy<a.y then
			a.y=oy
		end
	end
end

function apply_friction(a)
	if abs(a.dx)>1 then
		a.dx-=sgn(a.dx)
	else
		if abs(a.dx)>0 then
			a.t=0
		end
		a.dx=0
	end
end

function apply_gravity(a)
	a.dy=min(a.dy+1,6)
end

function physics_timer(a)
	a.t+=1
	if not a.land then
		a.air_t+=1
	end
end

-- collision ------------------

function collide(a,v,dv,vert)
	local tx,ty,tile
	for i=1,abs(dv) do
		v+=sgn(dv)
		for j=1,6,5 do
			tx,ty=curr_tile(a,v,j,vert)
			tile=mget(tx,ty)
			if fget(tile,1) and vert then
				if a.land==false then
					a.t=0
				end
				a.land=true
				return v-sgn(dv)
			elseif fget(tile,1) then
				a.dx=0
				a.dash_t=0
				return v-sgn(dv)
			elseif vert then
				a.land=false
			end
		end
	end
	return v
end

function curr_tile(a,v,j,vert)
	local tx,ty
	if vert then
		tx=flr((a.x+j)/8)
		ty=flr(v/8)
	else
		tx=flr((v+j)/8)
		ty=flr(a.y/8)
	end
	return tx,ty
end


-- input ----------------------

function player_input(a)
	walk_input(a)
	jump_input(a)
	a.release=not btn(4)
end

function walk_input(a)
	if btn(0) and btn(1) then
		a.dx=0
	elseif btn(0) then
		a.dx=-5
		a.z=true
		a.dash_t+=1
	elseif btn(1) then
		a.dx=5
		a.z=false
		a.dash_t+=1
	else
		a.dash_t=0
	end
end

function jump_input(a)
	if btn(4) and a.release then
		a.land=false
		a.air_t=0
		a.dash_t=0
		a.dy=-8
		a.t=0
	end
end


-- render ---------------------

function animate_hero(a)
	if true then
		a.f_y=a.y-(flr(a.t/12)-1)%2-10
	else
		a.f_y=a.y-10
	end
	a.hat_y=a.f_y-8
end

function draw_hero(a)
	hero_effects(a)
	spr(a.f,a.x,a.f_y,1,1,a.z)
	spr(a.hat,a.x,a.hat_y,1,1,a.z)
end

function hero_effects(a)
	draw_dash(a)
	if a.dy<2 then
		draw_thrust(a)
	end
	if a.land and abs(a.dx)<=2 then
		draw_beam(a)
	end
end

function dash_tail(a)
	if a.dash_t>10 and a.land then
		local t_x,t_y
		t_x=a.z and a.x+8 or a.x-8
		t_y=a.f_y+10
		add(a.tail,{x=t_x,y=t_y,z=a.z})
		if #a.tail>4 then
			del(a.tail,a.tail[1])
		end
	else
		del(a.tail,a.tail[1])
	end
end

function draw_dash(a)
	local b
	pal(9,dash_color(a,3))
	pal(10,dash_color(a,2))
	pal(12,dash_color(a,1))
	pal(13,dash_color(a,0))
	for i=#a.tail,1,-1 do
		b=a.tail[i]
		spr(47+i,b.x,b.y-11,1,1,b.z)
	end
	pal()
end

function dash_color(a,offset)
	local col=9+(a.t+offset)/2%4
	if col>=11 then
		col+=1
	end
	return col
end

function draw_thrust(a)
	local b_x,b_y
	b_x=a.z and a.x+4 or a.x+3
	b_y=a.y+1+a.dy
	for i=0,1 do
		circfill(b_x,b_y+i*3,2-i,12)
	end
end

function draw_beam(a)
	local b_x=a.z and a.x+1 or a.x
	local b_y=a.y-3+(a.t/2%12)
	local sz=3
	if a.t/2%12<2 then
		sz=2
	end
	for i=0,4,2 do
		line(b_x+3-sz,b_y+i,b_x+3+sz,b_y+i,12)
	end
end
__gfx__
00000000665566666655665655666655550055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666566666665665556666665555055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700666556666665566556656665555005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555555555555556555565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000566666655665566566665665055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700666666656665666566666665555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666556666665566666655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000ccc0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000ccc0000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000ccccc000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000088880000ccccc000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007000007088877700011aa1000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000077777007000007088888888ccccccc00000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0dd00000cc00000a0a0000099090711111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d0dd00000cc00000a0a0000099099071b11b100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0dd00000cc00000a0a000009909900711111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0dd00000cc00000a0a0000099099000777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0dd00000cc00000a0a000009909900999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d0dd00000cc00000a0a00000990990044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0dd00000cc00000a0a0000099090099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010000000000000000000001010
10101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010000000000000000000001010
10101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000001010000000000000000000001010
00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000000000004040000000000000000000004040
00000000000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000000000004040000000000000000000004040
00000000000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000000000004040000000000000000000004040
00000000000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000000000004040000000000000000000004040
00000000000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010000000000000000000001010
10101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010000000000000000000001010
10101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010000000000000000000001010
10101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
__gff__
0002020204000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
