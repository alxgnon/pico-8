pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- asura
--
function _init()
	world=_world()
	player=_player(0,110)
end

function _update()
	world:update()
	player:update()
	world:update_camera(player)
end

function _draw()
	world:draw()
	player:draw()
end
-->8
-- player
--
function _player(x,y)
	return{
		x=x,
		y=y,
		dx=0,
		dy=0,
		flap=0,
		--
		update=update_player,
		walk_input=walk_input,
		jump_input=jump_input,
		move=move_player,
		draw=draw_player
	}
end

function update_player(self)
	self:walk_input()
	self:jump_input()
	self:move()
end

function walk_input(self)
	local speed
	self.fly=self.y<190
	speed=self.fly and 4 or 3
	if(btn(0))self.dx=-speed
	if(btn(1))self.dx=speed
	if(stuck())self.dx=0
end

function jump_input(self)
	if btn(4) then
		if self.flap<=0 then
			self.flap=1
			self.dy=-14
		end
	elseif self.dy>=-3 then
		self.flap-=1
	end
end

function stuck()
	return btn(0) and btn(1)
end

function moving()
	return btn(0) or btn(1)
end

function flipped()
	return not btn(0) and btn(1)
end

function move_player(self)
	self.x+=self.dx
	self.y+=self.dy
	self.x=min(max(self.x,-514),507)
	self.y=min(max(self.y,50),192)
	self.dy+=abs(self.y*0.01)
	self.dx*=0.777
	self.dy*=0.777
end

function draw_player(self)
	draw_shadow(self.x,self.y)
	draw_halo(self.x,self.y,self.dy)
	draw_wings(self.x,self.y,self.dx,self.dy,self.flap)
	draw_body(self.x,self.y,self.fly)
end

function draw_shadow(x,y)
	if y>189 then
		spr(20,x,392-y)
	end
end

function draw_halo(x,y,dy)
	if y<180 and dy<4 then
		rectfill(x+2,y-4,x+5,y-2,0)
		rect(x+2,y-4,x+5,y-2,10)
	end
end

function draw_wings(x,y,dx,dy,flap)
	if y<180 and flap>-5 then
		dx=sgn(dx)*flr(abs(dx/2))
		dy=sgn(dy)*flr(abs(dy/2))
		flap=max(2+max(flap,-2),0)
		spr(flap,x-8,y-dx-dy,1,1,1)
		spr(flap,x+8,y+dx-dy)
	end
end

function draw_body(x,y,fly)
	if not moving() or stuck() then
		spr(4,x,y)
	elseif not fly then
		local frame,offset
		frame=flr(world.time/4%2)
		offset=flr(world.time/7%2)
		spr(6+frame,x,y-offset,1,1,flipped())
	else
		spr(5,x,y,1,1,flipped())
	end
end
-->8
-- world
--
function _world()
	prepare_map()
	return{
		time=0,
		rumble=0,
		--
		update=update_world,
		update_camera=update_camera,
		draw=draw_world,
		shake=shake
	}
end

function prepare_map()
	for i=0,127 do
		for j=9,9 do
			mset(i,j,64)
		end
	end
end

function update_world(self,x,y)
	self.time+=1
	self.rumble=max(self.rumble-1,0)
end

function update_camera(self,player)
	local x,y=player.x,player.y
	self.camx=min(max(x-60,-512),384)
	self.camy=min(y-8,100)
end

function draw_world(self)
	cls(13)
	self:shake(self.camx,self.camy)
	draw_land(self.camx)
end

function shake(self,x,y)
	if self.rumble>0 then
		x+=rnd(2)
		y+=rnd(2)
	end
	camera(x,y)
end

function draw_land(x)
	map(0,16,-512+x/3,136,128,8)
	rectfill(-512,200,512,232,4)
	line(-512,200,512,200,11)
	map(0,0,-512,136,128,16)
end
__gfx__
0000000000000000000000000000000000ffff000ffff0000ffff0000ffff0000000000000000000000000000000000000000000000000000000004005555550
060060007777770077777770aaaa000000ffff000ffff0000ffff0000ffff0000000000000000000000000000000000000000000000000000077774007777755
006600007777777077777777aaaaa00077ffff777ffff7777ffff7777ffff7770000000000000000000000000000000000000000000000000777774071171175
0066000007777700077777770aaaaa007777f777777f7777777f7777777f77770000000000000000000000000000000000000000000000007766664071171175
06006000007700000077077700aaaa00777797777779777077797770777977700000000000000000000000000000000000000000000000007600004077717775
000000000000000000000077000aaa00077797700779777007797770077977700000000000000000000000000000000000000000000000006000004055777555
000000000000000000000000000aaaa0009999000099990000999900009999000000000000000000000000000000000000000000000000000000004005555555
0000000000000000000000000000aaa000aaaa00000aaa0000aa00000000aa000000000000000000000000000000000000000000000000000000004005565555
00000000000000000000000000000000055555500000000000000000000000000000000000000000000000000000000000000000000000000000004055666555
00000000000000000000000000000000055555500000000000000000000000000000000000000000000000000000000000000000000000000000004055565555
00000000000000000000000000000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000004005666555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004005565550
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000555500
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000555000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000555000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000055000
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
000000000000000044bbbbbb5bbbbbb444bbbb55bbb5b444444bbb555bbbb44444b5bbb55bbbb444000000001111111100000000000000000000000b00000000
0000000000000000445555555555544444445555555444444444555555544444444455555554444400000001111111111111111110000000000000b3b0000000
000000000000000044444555544444444444444555444444444445555444444444444445554444440000001111111111111111111100000000000b343b000000
00000000000000004444444444444444444444444444444444444444444444444444444444444444000001111111111111111111111000000000b33433b00000
0000000000660000444444444444444444444444444444444444444444444444444444444444444400001115111111111111111111110000000b033b330b0000
0066660006666000444444444444444444444444444444444444444444444444444444444444444400011511111111111111111111111000000003b3b3000000
066666600666660044444444444444444444444444444444444444444444444444444444444444440011111111111111111111111111110000000b343b000000
06666660066666604444444444444444444444444444444444444444444444444444444444444444011151511111111111111111111111100000b34443b00000
4d6666d446666dd4444444444444444444444444444444444444444444444444444444444d6666d400000000000000000000000000000000000b334b433b0000
44dddd444dddd4444444444444444444444455444444444444444444444444444444444444dddd440000000000000000000000000000000000b333b3b333b000
44545454444444444444444444445444444555444554444444444444444444444445454444444444000000000000000000000000000000000b003b343b300b00
44454544444444444444444444444444444555444555444444454544444444444444444444444444000000000000000000000000000000000000b33433b00000
4444444444444444444444444444454444444444455544444444545444544444445454444444444400000000000000000000000000000000000b333b333b0000
444444444444444444444444444444444444444444444444444545444445444444444444444444440000000000000000000000000000000000b303b3b303b000
44444444444444444444444444444444444444444444444444445454444444444444444444444444000000000000000000000000000000000b000b343b000b00
44444444444444444444444444444444444444444444444444444444444444444444444444444444000000000000000000000000000000000000b34443b00000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b334b433b0000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b333b3b333b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b003b343b300b00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b33433b00000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b333b333b0000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b303b3b303b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b000b323b000b00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b32223b00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002220000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002220000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004420000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000004a4c4d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004a4c4c4c4d0000000000000000000000000000000000000000004a4b4b4b4c4d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004a4c4b4b4b4b4b4c4c4c4c4d00000000000000000000000000004a4c4b4b4b4b4b4b4d00000000000000000000000000000000000000000000000000004a4c4c4c4c4c4c4d0000000000004a4c4c4c4c4d0000000000000000000000000000000000000000004a4c4c4d0000000000000000004a4c4d000000000000
00004a4c4b4b4b4b4b4b4b4b4b4b4b4b4d000000000000000000004a4c4c4b4b4b4b4b4b4b4b4b4d00000000000000004a4c4c4c4c4c4d0000000000004a4c4c4c4b4b4b4b4b4b4b4b000000004a4c4b4b4b4b4b4b4c4c4c4c4c4c4c4d000000000000004a4c4c4c4c4c4b4b4b4b4c4c4d000000004a4c4b4b4b4c4c4d000000
4c4c4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4c4d0000000000004a4c4b4b4b4b4b4b4b4b4b4b4b4b4b4c4d00000000004a4b4b4b4b4b4b4b4c4c4d00004a4b4b4b4b4b4b4b4b4b4b4b4b000000004b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4c4d00000000004b4b4b4b4b4b4b4b4b4b4b4b4b4c4c4c4c4b4b4b4b4b4b4b4b4c4c4c
4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4d0000004a4c4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4d00004a4c4b4b4b4b4b4b4b4b4b4b4b4c4c4b4b4b4b4b4b4b4b4b4b4b4b4b4d00004a4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4d0000004a4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b
4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4c4c4c4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4c4c4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b00004b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4d00004b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b
