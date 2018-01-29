pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- providence
-- work in progress

pink = 14

function wav(val,amp,len)
	return amp*sin(val/len)
end


function new_backdrop()
	local backdrop = {v=0}

	function backdrop:update()
		local speed = wav(gt,0.7,98)
		self.v += speed
	end

	function backdrop:draw()
		cls()
		map(16,0,0,0,16,16)
		map(32,0,0,-64+self.v,16,32)
		map(0,16,64+self.v,64,16,2)
		map(0,16,-64-self.v,64,16,2)
		map(0,0,0,0,16,16)
	end

 return backdrop
end


function new_eye()
	local eye =
	{ x = 48, y = 0, by = 0
	, px = 0, py = 0
	}

	function eye:update()
		self.y = 1+wav(gt,1.98,98)
		self.by = -2+wav(gt+40,2.98,98)

		local d = atan2(cross.x-64,cross.y-20)
		self.px = flr(2*cos(d)+0.5)
		self.py = flr(2*sin(d)+0.5)
	end

	function eye:draw()
		spr(010,self.x-8,self.by,6,4)
		spr(078,
				self.x+self.px+8,
				self.y+self.py+16,2,2)
		spr(006,self.x,self.y,4,4)
	end

	return eye
end


function new_cross()
	local cross =
	{ x = 64, y = 112
	, speed = 2
	}

	function cross:joydelta()
		local dx,dy = 0,0
		if (btn"0") dx -= self.speed
		if (btn"1") dx += self.speed
		if (btn"2") dy -= self.speed
		if (btn"3") dy += self.speed
		return dx,dy
	end

	function cross:update()
		local dx,dy = self:joydelta()
		self.x += dx
		self.y += dy
		self.x = min(max(self.x,0),127)
		self.y = min(max(self.y,0),127)
	end

	function cross:draw()
		spr(072,self.x-3,self.y-3)
	end

	return cross
end


function transparent(col)
	palt(0,false)
	palt(col,true)
end

function _init()
	gt = 0
	transparent(pink)

	backdrop = new_backdrop()
	eye = new_eye()
	cross = new_cross()
end

function _update()
	gt += 1
	backdrop:update()
	eye:update()
	cross:update()
end

function _draw()
	backdrop:draw()
	eye:draw()
	cross:draw()
end
__gfx__
000000001111111111111111eeeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11dddddddddd116666666666666666666666661111dd11e
000000001444444444444444eeeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeee00eeeeeeeeeeeeeeeee111ddddddddd116666666666666666666661111ddddd11
007007001444444444444444eeeeeee040eeeeeeeeeeeeeeeeeeeeeeeeeeee0990eeeeeeeeeeeeeeeee1111dddddddd116666666666666666611111dddddddd1
000770001444444444444444eeeeeee040eeeeeeeeeeeeeeeeeeeeeeeeeee09aa90eeeeeeeeeeeeeeeee11111ddddddd116666666666666661111dddddddd111
000770001444444444444444eeeeee04440eeeeeeeeeeeeeeeeeeeeeeeeee09aa90eeeeeeeeeeeee11e11661111dddddd111666666666661111dddddddd1111e
007007001444444444444444eeeeee04440eeeeeeeeeeeeeeeeeeeeeeeee09aaaa90eeeeeeeeeeee1d116666611111ddddd11666666661111dddddddd1111eee
000000001444444444444444eeeee0444440eeeeeeeeeeeeeeeeeeeeeeee09aaaa90eeeeeeeeeeee1d1166666661111ddddd11166611111dddddddd1116111ee
000000001222222222222222eeeee0222220eeeeeeeeeeeeeeeeeeeeeee09aaaaaa90eeeeeeeeeee1dd11666666611111dddd1111111ddddddddd11166661d1e
eeeeeeeeeeeeeeeeeeeeeeeeeeee011111110eee24242424eeeeeeeeeee09aaaaaa90eeeeeeeeeee1dd1111666666661111dddd111ddddddddd1111666661dd1
eeeeeeeeeeeeeeeeeeeeeeeeeeee044444440eee42424242eeeeeeeeee09aaaaaaaa90eeeeeeeeee11ddd111166666666111ddddddddddddd1111166666611d1
eeeeeeeeeeeeeeeeeeeeeeeeeee04444444440ee24242424eeeeeeeeee09aaaaaaaa90eeeeeeeeeee1ddddd11116666666611dddddddddd11116666666611dd1
eeeeeeeeeeeeeeeeeeeeeeeeeee04444444440ee42424242eeeeeeeee09aaaaaaaaaa90eeeeeeeeee11dddddd1111666666611dddddd1111166666666111ddd1
eeeeeeeeeeeeeeeeeeeeeeeeee0444444444440e24242424eeeeeeeee09aaaaaaaaaa90eeeeeeeeeee1dddddddd1111666666111ddd1111666666661111dddd1
eeeeeeeeeeeeeeeeeeeeeeeeee0444444444440e42424242eeeeeeee09aaaaaaaaaaaa90eeeeeeeeee111dddddddd1111666661111111666666661111ddddd11
eeeeeeeeeeeeeeeeeeeeeeeee04444444444444024242424eeeeeeee09aaaaaaaaaaaa90eeeeeeeeeee1111ddddddd1111166661111666666661111ddddddd11
eeeeeeeeeeeeeeeeeeeeeeeee02222222222222042424242eeeeeee09aaaaaaaaaaaaaa90eeeeeeeeeee11111ddddddd1111166116666666611111ddddddd111
eeeeeeeeeeeeeeeeeeeeeeee011111110111111100000000eeeeeee09aaaaaaaaaaaaaa90eeeeeeee11e1161111dddddddd1111116666661111dddddddd1111e
eeeeeeeeeeeeeeeeeeeeeeee044444440444444400000000eeeeee09aaaaa111111aaaaa90eeeeee1d111666611111ddddddd111166661111dddddddd111eeee
eeeeeeeeeeeeeeeeeeeeeee0444444444444444410001000eeeeee0aaaa1111111111aaaa0eeeeee1d1166666661111dddddddd11661111dddddddd1111eeeee
eeeeeeeeeeeeeeeeeeeeeee0444444444444444401010101eeeee09aa1111eeeeee1111aa90eeeee1dd11666666661111dddddd111111ddddddd1111111eeeee
eeeeeeeeeeeeeeeeeeeeee04444444444444444410101010eeeee09a111eeeeeeeeee111a90eeeee1dd1111666666611111dddd1111dddddddd111166611eeee
e000000000000000eeeeee044444444444444444d101d101eeee09a1177eeeeeeeeee7711a90eeee11ddd11116666666611111d11dddddddd11116666661eeee
e6d6d6d6d6d6d6d6eeeeee0444444444444444441d1d1d1deeee09a1777eeeeeeeeee7771a90eeeee1ddddd111116666661111111dddddd11116666666611111
e000000000000000eeeeee44222222224444444401d101d1eee09aaa177eeeeeeeeee771aaa90eeee11dddddd1111666666661111dd111111666666666666661
161116111eeeeeee0eeeeeee11111111111111111d1d1d1deee09aaaa11eeeeeeeeee11aaaa90eeeee1dddddddd1111666661111111111166666666166666661
111d111d1eeeeeee0eeeeeee1444444444444444d101d101ee09aaaaaaa11eeeeee11aaaaaaa90eeee111dddddddd11111611eeeeee11666666661111666611e
1d111d111eeeeeee40eeeeee14444444444444441d1d1d1dee09aaaaaaaaa111111aaaaaaaaa90eeeee1111dddddddd11111eeeeeeee1166666111eee1111eee
111611161eeeeeee40eeeeee1444444444444444d1d1d1d1e09aaaaaaaaaaaaaaaaaaaaaaaaaa90eeeeee1111dddddddd1eeeeeeeeeeee11611eeeeeeeeeeeee
161116111eeeeeee440eeeee14444444444444441d1d1d1de09aaaaaaaaaaaaaaaaaaaaaaaaaa90eeeeeeeee111ddddd1eeeeeeeeeeeeee1111eeeeeeeeeeeee
111d111d1eeeeeee440eeeee14444444444444440000000009aaaaaaaaaaaaaaaaaaaaaaaaaaaa90eeeeeeeeee111111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
1d111d111eeeeeee440eeeee14444444444444444444444409999999999999999999999999999990eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
111611161eeeeeee444eeeee44444444444444440000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000777770000000000000000000000000000000000000000000000000000007777777e0000000000000000000000000000000000000000eee7777777777eee
00077777777700000000000000000070000000000000000000000000000000007333337e0000000000000000000000000000000000000000e77777777777777e
007777777777700000000005000000000000500000000000000000000000500073bbb37e0000000000000000000000000000000000000000e77777777777777e
077777777777770000500000000000000000000000000000000700000000000073bbb37e0000000000000000000000000000000000000000777777cccc777777
077777777777770000000000000000000000000000000000000000000000000073bbb37e000000000000000000000000000000000000000077777cc00cc77777
77777777777777700000000000050000006000050000000000000000060000007333337e000000000000000000000000000000000000000077777c0700c77777
77777777777777700000000000000000000000000000050000000000000000007777777e000000000000000000000000000000000000000077777c0000c77777
7777777777777770050000000000000000000000000000000000000000000000eeeeeeee000000000000000000000000000000000000000077777cc00cc77777
7777777777777770000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000777777cccc777777
7777777777777770000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e77777777777777e
0777777777777700000000000000000000000000050000000000000000050000000000000000000000000000000000000000000000000000e77777777777777e
0777777777777700000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000eee7777777777eee
0077777777777000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee
0007777777770000006000000000000000700000000060000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee
0000077777000000000000000050000000000000000000000000005000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee
__map__
0000000000000000000000000000000000004600000000000000000053000045000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000043004343000000000000004500404100000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000055465253000000000000000000505100000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000043440000540000000000000053450057000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000465355000000000000004544574344000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000202121212121000000000042000044000000000000004600465354000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003230102010201040000000052544557000000000000000043000045000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013010201020102140000000057000000000000000000000000570000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000323020102010201020400000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001302010201020102011400000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000032301020102010201020104000015151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000130102010201020102010214000015151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003230201020102010201020102040015151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013020102010201020102010201140015151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2224333433343334333433343334333215151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151515151515151515151515151515151515000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2525252525252525252525252525252525252525250000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3535353535353535353535353535353535353535350000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000030303030303031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
