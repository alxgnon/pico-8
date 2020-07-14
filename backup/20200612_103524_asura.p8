pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- asura
--
-- init
function _init()
	gt=0
	actors={}
	pl=_deva(0,64)
	add(actors,pl)
end

-- update
function _update()
	gt+=1
	for a in all(actors) do
		if a==pl then
			a:input()
		end
		a:update()
	end
end

-- draw
function _draw()
	cls(13)
	local camx,camy=pl:camera()
	camx=min(max(camx,-512),384)
	smap(0,16,-512+camx,136,128,8)
	camera(camx,camy)
	rectfill(-512,200,512,232,4)
	line(-512,200,512,200,11)
	map(0,0,-512,136,128,16)
	for a in all(actors) do
		a:draw()
	end
end
-->8
-- deva
function _deva(x,y)
	return{
		x=x,
		y=y,
		dx=0,
		dy=0,
		flap=0,
		fly=true,
		-- deva:input
		input=function(a)
			local speed=a.fly and 4 or 3
			if(btn(0))a.dx=-speed
			if(btn(1))a.dx=speed
			if btn(4) and a.flap<=0 then
				a.flap=1
				a.dy=-14
			elseif not btn(4) and a.dy>=-3 then
				a.flap-=1
			end
		end,
		-- deva:update
		update=function(a)
			a.x+=a.dx
			a.y+=a.dy
			a.dy=a.dy+abs(a.y*0.01)
			a.dx*=0.777
			a.dy*=0.777
			a.x=min(max(a.x,-514),507)
			a.y=min(max(a.y,50),192)
			a.fly=a.y<190
		end,
		-- deva:camera
		camera=function(a)
			return a.x-60,min(a.y-8,100)
		end,
		-- deva:draw
		draw=function(a)
			local x,y=a.x,a.y
			-- deva wings
			local fx,fy=a.dx/2,a.dy/2
			local f=max(a.flap,-2)
			if a.y<180 then
				if a.dy<4 then
					rect(x+2,y-4,x+5,y-2,10)
				end
				if	a.flap>-5 then
					spr(max(2+f,0),x-8,y-fx-fy,1,1,1)
					spr(max(2+f,0),x+8,y+fx-fy)
				end
			end
			-- deva body
			local flip=not btn(0) and btn(1)
			if not btn(0) and not btn(1) then
				spr(4,x,y)
			elseif not a.fly then
				f=flr(gt/4%2)
				fy=flr(gt/7%2)
				spr(6+f,x,y-fy,1,1,flip)
			else
				spr(5,x,y,1,1,flip)
			end
		end
	}
end
__gfx__
0000000000000000000000000000000000ffff000ffff0000ffff0000ffff0000000000000000000000000000000000000000000000000000000000000000000
060060007777770077777770aaaa000000ffff000ffff0000ffff0000ffff0000000000000000000000000000000000000000000000000000000000000000000
006600007777777077777777aaaaa00077ffff777ffff7777ffff7777ffff7770000000000000000000000000000000000000000000000000000000000000000
0066000007777700077777770aaaaa007777f777777f7777777f7777777f77770000000000000000000000000000000000000000000000000000000000000000
06006000007700000077077700aaaa00777797777779777077797770777977700000000000000000000000000000000000000000000000000000000000000000
000000000000000000000077000aaa00077797700779777007797770077977700000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000aaaa0009999000099990000999900009999000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000aaa000aaaa00000aaa0000aa00000000aa000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000004444444444444444444444444444444444444444000000000000000000000000000000001111111144bbbbbb2bbbbbb40000000b00000000
0000000000000000444455444444444444444444444444444444444400000000000000000000000000000000111111114454545454545444000000b3b0000000
000000000000000044455544455444444444444444444444444545440000000000000000000000000000000011111111444545454545444400000b343b000000
00000000000000004445554445554444444545444444444444444444000000000000000000000000000000001111111144444444545444440000b33433b00000
0000000000660000444444444555444444445454445444444454544400000000000000000000000000000000111111114444444444444444000b033b330b0000
0066660006666000444444444444444444454544444544444444444400000000000000000000000000000000111111114444444444444444000003b3b3000000
066666600666660044444444444444444444545444444444444444440000000000000000000000000000000011111111444444444444444400000b343b000000
06666660066666604444444444444444444444444444444444444444000000000000000000000000000000001111111144444444444444440000b34443b00000
4444444446666dd44d6666d455555455000000000000000000000000000000000000000000000000000000000000000044bbbb22bbb22244000b334b433b0000
444444444dddd44444dddd44444444440000000000000000000000000000000000000000000000000000000000000000444454545454444400b333b3b333b000
44444444444444444454545444444444000000000000000000000000000000000000000000000000000000000000000044454545454444440b003b343b300b00
44444444444444444445454444444444000000000000000000000000000000000000000000000000000000000000000044445454444444440000b33433b00000
4444444444444444444444444444444400000000000000000000000000000000000000000000000000000000000000004444444444444444000b333b333b0000
444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000444444444444444400b303b3b303b000
44444444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000044444444444444440b000b343b000b00
44444444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000044444444444444440000b34443b00000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004455522222222224000b334b433b0000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444454545454444400b333b3b333b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444545454544440b003b343b300b00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444545444440000b33433b00000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444444444444000b333b333b0000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444444444444400b303b3b303b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440b000b323b000b00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440000b32223b00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044555222222224540000002220000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044445454545444440000002220000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444545454444440000004420000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444454444444440000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440000004440000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444444444440000044444000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000004e4f000000000000000000000000000000000000000000004e4f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e4f00000000000000000000000000000000004e4f0000
000000004e4f0000000000000000000000004e4f005e5f0000000000004e4f000000000000000000004e4f00005e5f004e4f00000000000000004e4f000000000000000000000000000000004e4f000000000000000000004e4f00000000000000000000004e4f00005e5f000000000000000000004e4f00000000005e5f0000
000000005e5f004e4f00004e4f00000000005e5f005e5f00004e4f00005e5f004e4f000000004e4f005e5f00005e5f005e5f00004e4f004e4f005e5f000000004e4f0000004e4f00000000005e5f00004e4f0000004e4f005e5f4e4f00004e4f0000004e4f5e5f00005e5f00004e4f00004e4f00005e5f00004e4f005e5f0000
000000005e5f005e5f00005e5f00000000005e5f005e5f00005e5f00005e5f005e5f000000005e5f005e5f00005e5f005e5f00005e5f005e5f005e5f000000005e5f0000005e5f00000000005e5f00005e5f0000005e5f005e5f5e5f00005e5f0000005e5f5e5f00005e5f00005e5f00005e5f00005e5f00005e5f005e5f0000
000000006e6f006e6f00006e6f00000000006e6f006e6f00006e6f00006e6f006e6f000000006e6f006e6f00006e6f006e6f00006e6f006e6f006e6f000000006e6f0000006e6f00000000006e6f00006e6f0000006e6f006e6f6e6f00006e6f0000006e6f6e6f00006e6f00006e6f00006e6f00006e6f00006e6f006e6f0000
004100007e7f007e7f00007e7f40000041007e7f007e7f00407e7f41007e7f007e7f400000007e7f007e7f00417e7f007e7f00407e7f007e7f007e7f004100007e7f0040007e7f00004100007e7f00407e7f0000007e7f417e7f7e7f00007e7f0000407e7f7e7f00417e7f40007e7f00007e7f41007e7f40007e7f417e7f4000
005150507c7d534c4d00007c7d52505051004c4d536c6d50515c5d52506c6d537c7d525000004c4d004c4d00525c5d504c4d00516c6d534c4d004c4d005100537c7d5052004c4d00505200004c4d00516c6d0053537c7d515c5d6c6d53004c4d5050527c7d4c4d00517c7d51506c6d50004c4d52505c5d52504c4d517c7d5200
0000000045000000000000000000004400004600000000450000000000000000460000004400000000000000000045000000000000000000000044000000000046000000000000000000000000450000000000000000000000000000000000004400004500000000000000004400000000004400000000004600004500000044
0000000000460000000042000000000000450000000000000000004500000000004500000000450000000045000000000000450000000000000000000046004500000000450000450000004400000000450000000000440000000043004500000000000000000045000000000046000000420000000045000000000000000000
0000004300000000440000000045000000000000460000000046000000440000000000460000000042000000000000000046000000004400000000004300000046000000000000000000430000460000000042000000004500000000000000000000000046004300000046000000000000000000000000000044000000430000
0046000000004400000000004600000000004400000045000000430000000000000044000045000000000046004400004300000045000000464400000000000000004400000044004600000000004400004600004400000000440000000046004200004400000000000000440000004300000045004400450000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000004b4b4b4b4b4b4b4b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000004b4b4b4b4b4b4b4b4b4b4b4b4b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b
4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b
