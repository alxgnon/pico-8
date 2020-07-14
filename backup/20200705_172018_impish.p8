pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- impish
--
function _init()
	palt(0,false)
	palt(1,true)
	set:init()
end

function _update()
	set:clear(set.buffer)
	set:update()
	set:clear(set.trash)
end

function _draw()
	set:draw()
end
-->8
-- super entity tracker
set={keys={}}

function set:init()
	for key in all(self.keys) do
		self[key]={}
	end
	self.buffer={root()}
	self.trash={}
end

function set:update()
	for key in all(self.keys) do
		for entity in all(self[key]) do
			entity[key](entity)
		end
	end
end

function set:draw()
	for key in all(self.keys) do
		for entity in all(self[key]) do
			entity["draw_"..key](entity)
		end
	end
end

function set:clear(buffer)
	if buffer==self.buffer then
		self:clear_buffer()
	elseif buffer==self.trash then
		self:clear_trash()
	end
	for i,v in ipairs(buffer) do
		buffer[i]=nil
	end
end

function set:clear_buffer()
	local buffer=self.buffer
	for entity in all(buffer) do
		for key in all(self.keys) do
			if entity[key] then
				add(self[key],entity)
			end
		end
	end
end

function set:clear_trash()
	local buffer=self.trash
	for entity in all(buffer) do
		for key in all(self.keys) do
			del(self[key],entity)
		end
	end
end
-->8
-- component maker
--
add(set.keys,"root")
function root()
	return{
		t=0,
		root=function(e)
			e.t+=1
		end,
		draw_root=function(e)
			local oy
			cls()
			oy=flr(e.t/4)%32
			map(64,0,0,-oy,17,20)
			oy=e.t%32
			--map(0,0,-9,-oy,20,20)
		end
	}
end

-- 	add(buffer,hero(56,24))
-- 	main={
-- 		tick=0,
-- 		rumble=0,
-- 		grace=88,
-- 		title=128
-- 	}
-- end
-- 	palt(0,false)
-- 	palt(1,true)
-- function populate(e)
-- 	if e.grace<=0 then
-- 		if e.tick%100==50 then
-- 			add(buffer,slime())
-- 		end
-- 	elseif e.grace>0 then
-- 		e.grace-=1
-- 	end
-- end
-- function runtimers(e)
-- 	if(e.title<78)e.tick+=1
-- 	if(e.rumble>0)e.rumble-=1
-- 	if(e.title==81)e.rumble=11
-- 	if(e.title>0)e.title-=1
-- 	if	e.title==79 then
-- 		e.grace+=1
-- 		e.title=80
-- 	end
-- end
-- function drawrumble(e)
-- 	if e.rumble>0 then
-- 		camera(rnd(2),rnd(2))
-- 	else
-- 		camera()
-- 	end
-- end
-- function drawentity()
-- 	if entity[1] then
-- 		entity[1]:draw()
-- 	end
-- 	if #entity>1 then
-- 		for i=#entity,2,-1 do
-- 			if not entity[i].fore then
-- 				entity[i]:draw()
-- 			end
-- 		end
-- 		for i=#entity,2,-1 do
-- 			if entity[i].fore then
-- 				entity[i]:draw()
-- 			end
-- 		end
-- 	end
-- end
-- function drawtitle(e)
-- 	local ox,oy
-- 	if(e.title<=0)return
-- 	if e.title>80 then
-- 		ox=-614+e.title*8
-- 		oy=324-e.title*4
-- 	elseif e.title>78 then
-- 		ox=34
-- 		oy=0
-- 	else
-- 		ox=34
-- 		oy=1248-e.title*16
-- 	end
-- 	rectfill(0,70+oy,127,128,0)
-- 	rect(-1,70+oy,128,88+oy,8)
-- 	if e.title==80 then
-- 		pal(8,10)
-- 		print("press 🅾️ or ❎",64,92,10)
-- 	end
-- 	spr(5,ox,72+oy,7,2)
-- 	pal(8,8)
-- end
-- function _draw()
-- 	cls()
-- 	drawrumble(main)
-- 	drawbackground(entity[1])
-- 	drawtitle(main)
-- 	drawentity()
-- 	print(#entity,3,2,7)
-- 	rect(-1,-1,128,128,0)
-- end

add(set.keys,"hero")
function hero()
end
-- function shooting(e,n,ox)
-- 	if(e.reload[n]>0)e.reload[n]-=1
-- 	if btn(n) then
-- 		if e.reload[n]==0 and e.release[n] then
-- 			add(buffer,shot(e.x+ox,e.y-4))
-- 			e.reload[n]=35
-- 		end
-- 	end
-- 	e.release[n]=not btn(n)
-- end
-- function draw_helm(e)
-- 	local frame
-- 	if e.reload[4]*e.reload[5]==0 then
-- 		frame=e.id
-- 	else
-- 		frame=e.id+2
-- 	end
-- 	spr(frame,e.x,e.y,2,2)
-- end
-- function draw_arm(e,n,ox)
-- 	local frame
-- 	if e.reload[n]==0 then
-- 		frame=e.id+4
-- 	else
-- 		frame=e.id+6
-- 		ox+=sgn(ox)*16*e.reload[n]
-- 	end
-- 	spr(frame,e.x+ox,e.y-4,1,4,n==4)
-- end
-- function hero(x,y)
-- 	return{
-- 		id=hero_id,
-- 		x=x,
-- 		y=y,
-- 		tick=0,
-- 		alive=true,
-- 		reload={[4]=47,[5]=47},
-- 		release={[4]=false,[5]=false},
-- 		update=function(e)
-- 			input(e)
-- 			move_hero(e)
-- 			shooting(e,4,-8)
-- 			shooting(e,5,16)
-- 			e.tick+=1
-- 		end,
-- 		draw=function(e)
-- 			draw_helm(e)
-- 			draw_arm(e,4,-9)
-- 			draw_arm(e,5,16)
-- 		end
-- 	}
-- end
-- hero_id=68
-- function input(e)
-- 	e.dx,e.dy=0,0
-- 	if main.title==80 and (e.release[4] and btn"4" or e.release[5] and btn"5") then
-- 		main.title=79
-- 	elseif main.title<80 then
-- 		if(btn"0")e.dx-=5
-- 		if(btn"1")e.dx+=5
-- 		if(btn"2")e.dy-=5
-- 		if(btn"3")e.dy+=5
-- 	elseif btn"4" or btn"5" and main.title>80 then
-- 		main.title-=1
-- 	end
-- 	e.release[4]=not btn(4)
-- 	e.release[5]=not btn(5)
-- end
-- function move_hero(e)
-- 	if e.dx*e.dy!=0 then
-- 		e.dx*=0.707
-- 		e.dy*=0.707
-- 	end
-- 	e.x=min(max(e.x+e.dx,-4),117)
-- 	e.y=min(max(e.y+e.dy,-4),117)
-- end

add(set.keys,"hazard")
function hazard()
end
-- muck_id=172
-- function muck(x,y)
-- 	return{
-- 		id=muck_id,
-- 		x=x,
-- 		y=y,
-- 		tick=0,
-- 		update=function(e)
-- 			e.frame=e.id+(flr(e.tick*0.05)%2)*2
-- 			if e.tick>75 then
-- 				add(trash,e)
-- 			end
-- 			e.tick+=1
-- 		end,
-- 		draw=function(e)
-- 			spr(e.frame,e.x,e.y,2,2)
-- 		end
-- 	}
-- end

add(set.keys,"shot")
function shot()
end
-- shot_id=73
-- function shot(x,y)
-- 	return{
-- 		id=shot_id,
-- 		x=x,
-- 		y=y,
-- 		dy=12,
-- 		update=function(e)
-- 			e.y+=e.dy
-- 			if e.y>138 then
-- 				add(trash,e)
-- 			end
-- 		end,
-- 		draw=function(e)
-- 			spr(e.id,e.x,e.y,1,4)
-- 		end
-- 	}
-- end

add(set.keys,"eshot")
function eshot(x,y,dx,dy)
end
-- baby_id=152
-- function baby(x,y,dx,dy)
-- 	return{
-- 		id=baby_id,
-- 		fore=true,
-- 		x=x,
-- 		y=y,
-- 		dx=dx,
-- 		dy=dy,
-- 		tick=0,
-- 		update=function(e)
-- 			e.x+=e.dx
-- 			e.y+=e.dy
-- 			e.frame=e.id+(flr(e.tick*0.25)%4)
-- 			if e.y<=-2 or e.x<=-2 or e.x>124 then
-- 				add(trash,e)
-- 			end
-- 			e.tick+=1
-- 		end,
-- 		draw=function(e)
-- 			spr(e.frame,e.x,e.y)
-- 		end
-- 	}
-- end

add(set.keys,"baddie")
function baddie()
end
-- slime_id=168
-- function spray(x,y)
-- 	add(buffer,baby(x,y,-1.414,-1.414))
-- 	add(buffer,baby(x,y,0,-2))
-- 	add(buffer,baby(x,y,1.414,-1.414))
-- end
-- function takedamage(e)
-- 	for f in all(entity) do
-- 		if f.id==shot_id and
-- 				e.x>f.x-12 and
-- 				e.y>f.y and
-- 				e.x<f.x+4 and
-- 				e.y<f.y+32 then
-- 			add(trash,f)
-- 			e.stun=12
-- 			e.hp-=1
-- 			return
-- 		end
-- 	end
-- end
-- function slime()
-- 	local x=32+rnd(48)
-- 	return{
-- 		id=slime_id,
-- 		fore=true,
-- 		x=x,
-- 		y=128,
-- 		tick=0,
-- 		stun=0,
-- 		hp=2,
-- 		dx=(64-x)/128,
-- 		dy=-0.5,
-- 		update=function(e)
-- 			takedamage(e)
-- 			e.stun-=1
-- 			if e.stun>0 then
-- 				return
-- 			end
-- 			if e.hp<1 then
-- 				add(trash,e)
-- 				add(buffer,muck(e.x,e.y))
-- 				return
-- 			end
-- 			if -8>e.y then
-- 				add(trash,e)
-- 				return
-- 			end
-- 			e.tick+=1
-- 			e.x+=e.dx
-- 			e.y+=e.dy
-- 			e.frame=e.id+(flr(e.tick*0.05)%2)*2
-- 			local beat=e.tick/20%2
-- 			if beat==0 or beat==1 then
-- 				add(buffer,muck(e.x,e.y))
-- 			end
-- 			if beat==0 or beat==1 then
-- 				spray(e.x+5,e.y)
-- 			end
-- 		end,
-- 		draw=function(e)
-- 			local ox,oy=0,0
-- 			if e.stun>0 then
-- 				ox=rnd(2)
-- 				oy=rnd(2)
-- 				pal(10,8)
-- 				pal(11,8)
-- 				e.frame=e.id+2
-- 			end
-- 			spr(e.frame,e.x+ox,e.y+oy,2,2)
-- 			pal(10,10)
-- 			pal(11,11)
-- 		end
-- 	}
-- end
-- todo:
---- set
-- hurt effects:
---- broken sword effect
---- falling helmet effect
---- dead slime effect
-- enemies:
---- skull, paces with axe
---- eye, shoots insta-kill lazer
__gfx__
0000000000000000000000000000000011111bbbbb11111111111aaaaa11111111111eeeee1111111111199999111111111116666611111111111fffff111111
00000000000000000000000000000000111bb00000bb1111111aa00000aa1111111eeeeeeeee111111199999999911111116666666661111111fffffffff1111
0070070000000000000000000000000011b000000000b11111a000000000a11111eeeeeeeeeee1111199998888899111116666666666611111fffffffffff111
000770000000000000000000000000001b00000000000b111a00000000000a111eeeeeeeeeeeee11199998888888991116666666666666111fffffffffffff11
000770000000000000000000000000001b00000000000b111a08000000080a111777ccc000ccc711199988800088891116600066600066111f000fffff000f11
00700700000000000000000000000000b0080000000800b1a0088000008800a17777cc00070cc77199998800090889916600006660000661ff0000fff0000ff1
00000000000000000000000000000000b0088000008800b1a0080800080800a17777cc00000cc77199998800000889916600006660000661ff0000fff0000ff1
00000000000000000000000000000000b0080800080800b1a0000000000000a17777cc00000cc77199998800000889916600006660000661ff0000f0f0000ff1
00000000000000000000000000000000b0000000000000b1a00aaaaaaaaa00a17777ccc000ccc77199998880008889916666666066666661fffffff0fffffff1
00000000000000000000000000000000b0000000000000b1a000a0a0a0a000a177777ccccccc7771999998888888999166666660666666611fffffffffffff11
00000000000000000000000000000000b00bbbbbbbbb00b1a0000000000000a1177777ccccc777111999998888899911166666666666661111ff0ff0ff0ff111
000000000000000000000000000000001b00bb00bbb00b111a00000000000a111eeeeeeeeeeeee111999999999999911116606606606611111f0000000000111
000000000000000000000000000000001b00b0000b000b111a000a0a0a000a1111eeeeeeeeeee1111199999999999111116000000000011111f0000000000111
0000000000000000000000000000000011b0b0000b00b11111a0aaaaaaa0a111111eeeeeeeee11111119999999991111116606606606611111f0000000000111
00000000000000000000000000000000111000000b0011111110aa000a00111111111eeeee1111111111199999111111116666666666611111ff0ff0ff0ff111
000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111fffffffffff111
00000000000000000000000000000000111111111111111111111111111111111111117771111111111111aaa111111144111111111111111111111111111441
000000000000000000000000000000001111111111111111111aaaaaaaaa1111111111666711111111111aaaa111111144411111111111111111111111114441
00000000000000000000000000000000111bbbbbbbbb111111aaaaaaaaaaa11111441166667111111111aaaaa114411114441111111111111111111111144411
0000000000000000000000000000000011bbbbbbbbbbb1111aaaaaaaaaaaaa111144416666671111111aaaaaa14441111144411117771111111aaa1111444111
0000000000000000000000000000000011bbbbbbbbbbb1111aaaaaaaaaaaaa111114446666671111111aaaaaa4441111111444111666711111aaaa1114441111
000000000000000000000000000000001bbbbbbbbbbbbb11aaaaaaaaaaaaaaa11111444666671111111aaaaa4441111111114441166667111aaaaa1144411111
000000000000000000000000000000001bbbbbbbbbbbbb11aaaaaaaaaaaaaaa176666444111111111111111444aaaaa11111144416666671aaaaaa1444111111
000000000000000000000000000000001bbbbbbbbbbbbb11aaaaaaaaaaaaaaa17666664441111111111111444aaaaaa11111114446666671aaaaaa4441111111
11881111111991111111aa111bb111111bbbbbbbbbbbbb11aaaaaaaaaaaaaaa17666661444111111111114441aaaaaa11111111444666671aaaaa44411111111
1888881119999911aaaaaa111bbbbbb11bbbbbbbbbbbbb11aaaaaaaaaaaaaaa11766661144411111111144411aaaaa1111176666444111111111444aaaaa1111
1888888199999911aaaaaa111bbbbbb11bbbbbbbbbbbbb11aaaaaaaaaaaaaaa11176661114441111111444111aaaa1111117666664441111111444aaaaaa1111
88888881999999911aaaaa111bbbbb1111bbbbbbbbbbb1111aaaaaaaaaaaaa111117771111444111114441111aaa11111117666661444111114441aaaaaa1111
88888811199999911aaaaaa1bbbbbb1111bbbbbbbbbbb1111aaaaaaaaaaaaa11111111111114441114441111111111111111766661144111114411aaaaa11111
18888811199999111aaaaaa1bbbbbb11111bbbbbbbbb111111aaaaaaaaaaa111111111111111444144411111111111111111176661111111111111aaaa111111
11188111119911111aa111111111bb111111111111111111111aaaaaaaaa1111111111111111144144111111111111111111117771111111111111aaa1111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111aaaaa11111111111aaaaa111111111116666611111111111666666111111116660006661111111166666611111111aaa111117771111199911111888111
111aaa888aaa1111111aaaeeeaaa1111111666555666111111166666666661111166660006666111116666666666111111aaa111117771111199911111888111
11aaa87888aaa11111aaae7eeeaaa11111666575556661111166600000666611166660000066661116666000006661111199911111ccc1111144411111222111
1aaaa88888aaaa111aaaaeeeeeaaaa1116666555556666111666600000066661166600000006661166660000006666111199911111ccc1111144411111222111
1aaaaa888aaaaa111aaaaaeeeaaaaa1116666655566666111666600000006661666000000000666166600000006666111199911111ccc1111144411111222111
aa000aaaaa000aa1aa000aaaaa000aa166000666660006616655660000000661660000000000066166000000066556611199911111ccc1111144411111222111
aa0000aaa0000aa1aa0000aaa0000aa16600006660000661655556600000000166000000000006610000000066557561aaaaaaa1777777719999999188888881
aa0c0000000c0aa1aa00000000000aa16600000000000661655556600000000166000000000006610000000066555561aaaaaaa1777777719999999188888881
aa0cc00000cc0aa1aa0d0000000d0aa1660000000000066165755660000000016600006660000661000000006655556116666711177777111999991118888811
aa00cc000cc00aa1aa00dd000dd00aa1660000000000066166556600000006616600066666000661660000000665566116666711177777111999991118888811
aaa000000000aaa1aaa000000000aaa1666000000000666116666000000066611666665556666611666000000066661116666711177777111999991118888811
1aaa0000000aaa111aaa0000000aaa11166600000006661116666000000666611666655555666611666600000066661116706711177077111990991118808811
1aaaa00000aaaa111aaaa00000aaaa11166660000066661111666000006666111166655575666111166660000066611116706711177077111990991118808811
11aaaa000aaaa11111aaaa000aaaa111116666000666611111166666666661111116665556661111116666666666111116706711177077111990991118801111
111aaa000aaa1111111aaa000aaa1111111666000666111111111666666111111111166666111111111166666611111116706711177077111990991118111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111116706711177077111990991111111111
11188811888888888888811888888881188811118888881188811888000000000000000000000000422222240000000016706711177077111990991111111111
11188811888118881188811888118881188811188118881188811888000222222222222222222000400000040400000016706711177077111990991111111811
11188811888118881188811888118881188811888118881188811888004020202020202020200400422222240000000016706711177077111990991111808811
11188811888118881188811888118881188811888118811188811888020020202020202020200020040000400000000016706711177077111990991118808811
11188811888118881188811888118881188811888118111188811888020000000000000000002220004004000000000016706711177077111990991118808811
11188811888118881188811888118881188811888111111188811888022200040404040400000020000440000000020016706711177077111990991118808811
11188811888118881188811888118811188811888111111188811888020000000000000000002220004004000000000016706711177077111990991118808811
11188811888118881188811888888111188811888888881188888888022200004040404000000020040000400000000016706711177077111990991118808811
11188811888118881188811888111111188811111118881188811888020000000000000000002220655555560000000016706711177077111990991118808811
11188811888118881188811888111111188811111118881188811888022200040404040400000020600000060600000016706711177077111990991118808811
11188811888118881188811888111111188811118118881188811888020000000000000000002220655555560000000016706711177077111990991118808811
11188811888118881188811888111111188811188118881188811888022200000000000000000020060000600000000016706711177077111990991118808811
11188811888118881188811888111111188811888118881188811888020002020202020202020020006006000000000016666711177777111999991118888811
11188111881118811188111881111111188111888118811188111881004002020202020202020400000660000000050016666711177777111999991118888811
11181111811118111181111811111111181111888888111181111811000222222222222222222000006006000000000011667111117771111199911111888111
11111111111111111111111111111111111111111111111111111111000000000000000000000000060000600000000011171111111711111119111111181111
__map__
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b78
67686869676a0000000000006a6868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b69
77787879776a0000000000006a7878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878796b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b79
68696768686a0000000000006a6967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b68
78797778786a0000000000006a7977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b78
