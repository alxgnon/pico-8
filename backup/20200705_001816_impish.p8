pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- impish
--
-->8
-- hero
--
hero_id=68

function hero(x,y)
	return{
		id=hero_id,
		alive=true,
		x=x,
		y=y,
		tick=0,
		reload={[4]=0,[5]=0},
		release={[4]=false,[5]=false},
		update=function(e)
			input(e)
			move_hero(e)
			shooting(e,4,-8)
			shooting(e,5,16)
			e.tick+=1
		end,
		draw=function(e)
			draw_helm(e)
			draw_arm(e,4,-8)
			draw_arm(e,5,16)
		end
	}
end

function input(e)
	e.dx,e.dy=0,0
	if(title>110)return
	if(btn"0")e.dx-=5
	if(btn"1")e.dx+=5
	if(btn"2")e.dy-=5
	if(btn"3")e.dy+=5
end

function move_hero(e)
	if e.dx*e.dy!=0 then
		e.dx*=0.707
		e.dy*=0.707
	end
	e.x=min(max(e.x+e.dx,-4),117)
	e.y=min(max(e.y+e.dy,-4),117)
end

function shooting(e,n,ox)
	if(e.reload[n]>0)e.reload[n]-=1
	if btn(n) then
		if e.reload[n]==0 and e.release[n] then
			add(buffer,shot(e.x+ox,e.y-4))
			e.reload[n]=88
		end
	end
	e.release[n]=not btn(n)
end

function draw_background(e)
	cls()
	map(0,0,-8,-(e.tick%32),6,20)
	map(6,0,40,-(flr(e.tick*0.25)%32),6,20)
	map(12,0,88,-(e.tick%32),6,20)
end

function draw_helm(e)
	local frame
	if e.reload[4]*e.reload[5]==0 then
		frame=e.id
	else
		frame=e.id+2
	end
	spr(frame,e.x,e.y,2,2)
end

function draw_arm(e,n,ox)
	local frame
	if e.reload[n]==0 then
		frame=e.id+4
	else
		frame=e.id+6
		ox+=sgn(ox)*16*e.reload[n]
	end
	spr(frame,e.x+ox,e.y-4,1,4)
end

shot_id=73

function shot(x,y)
	return{
		id=shot_id,
		x=x,
		y=y,
		dy=12,
		update=function(e)
			e.y+=e.dy
			if e.y>138 then
				add(trash,e)
			end
		end,
		draw=function(e)
			spr(e.id,e.x,e.y,1,4)
		end
	}
end
-->8
-- baddies
--
slime_id=168

function slime()
	local x=32+rnd(48)
	return{
		id=slime_id,
		x=x,
		y=128,
		tick=0,
		dx=(64-x)/128,
		dy=-0.25,
		update=function(e)
			e.tick+=1
			e.x+=e.dx
			e.y+=e.dy
			e.frame=e.id+(flr(e.tick*0.05)%2)*2
			if e.tick/20%2==0 then
				add(buffer,muck(e.x,e.y))
			elseif e.tick/20%2==1 then
				spray(e.x+5,e.y)
			end
		end,
		draw=function(e)
			spr(e.frame,e.x,e.y,2,2)
		end
	}
end

function spray(x,y)
	add(buffer,baby(x,y,-1.414,-1.414))
	add(buffer,baby(x,y,0,-2))
	add(buffer,baby(x,y,1.414,-1.414))		
end

muck_id=172

function muck(x,y)
	return{
		id=muck_id,
		x=x,
		y=y,
		tick=0,
		update=function(e)
			e.frame=e.id+(flr(e.tick*0.05)%2)*2
			if e.tick>160 then
				add(trash,e)
			end
			e.tick+=1
		end,
		draw=function(e)
			spr(e.frame,e.x,e.y,2,2)
		end
	}
end

baby_id=152

function baby(x,y,dx,dy)
	return{
		id=baby_id,
		x=x,
		y=y,
		dx=dx,
		dy=dy,
		tick=0,
		update=function(e)
			e.x+=e.dx
			e.y+=e.dy
			e.frame=e.id+(flr(e.tick*0.25)%4)
			if e.y<-20 then
				add(trash,e)
			end
			e.tick+=1
		end,
		draw=function(e)
			spr(e.frame,e.x,e.y)
		end
	}
end
-->8
-- main
--
function _init()
	palt(0,false)
	palt(1,true)
	entity={}
	buffer={}
	trash={}
	title=158
	reset()
end

function reset()
	grace=158
	empty(entity)
	empty(buffer)
	empty(trash)
	add(buffer,hero(56,24))
end

function empty(table)
	for e in all(table) do
		del(table,e)
	end
end

function _update()
	for e in all(trash) do
		del(entity,e)
	end
	empty(trash)
	for e in all(buffer) do
		add(entity,e)
	end
	empty(buffer)
	for e in all(entity) do
		e:update()
	end
	if #entity==1 and grace==0 then
		add(buffer,slime())
	elseif grace>0 then
		grace-=1
	end
	if title>0 then
		title-=1
	end
end

function _draw()
	local hero=entity[1]
	if hero and hero.alive then
		draw_background(hero)
	end
	for i=#entity,1,-1 do
		entity[i]:draw()
	end
	if title>0 then
		draw_title()
	end
end

function draw_title()
	if title>110 then
		ox=-410+title*4
	elseif title>40 then
		ox=34
	else
		ox=-126+title*4
	end
	if title>110 then
		oy=222-title*2
	elseif title>40 then
		oy=0
	else
		oy=80-title*2
	end
	rectfill(0,70+oy,127,128,0)
	rect(-1,70+oy,128,88+oy,8)
	spr(4,ox,72+oy,7,2)
end
__gfx__
00000000111111111111111111111111111888118888888888888118888888811888111188888811888118880000000000000000000000000000000000000000
00000000111222222222222222222111111888118881188811888118881188811888111881188811888118880000000000000000000000000000000000000000
00700700114020202020202020200411111888118881188811888118881188811888118881188811888118880000000000000000000000000000000000000000
00077000120020202020202020200021111888118881188811888118881188811888118881188111888118880000000000000000000000000000000000000000
00077000120000000000000000002221111888118881188811888118881188811888118881181111888118880000000000000000000000000000000000000000
00700700122200000000000000000021111888118881188811888118881188811888118881111111888118880000000000000000000000000000000000000000
00000000120000000000000000002221111888118881188811888118881188111888118881111111888118880000000000000000000000000000000000000000
00000000122200000000000000000021111888118881188811888118888881111888118888888811888888880000000000000000000000000000000000000000
00000000120000000000000000002221111888118881188811888118881111111888111111188811888118880000000000000000000000000000000000000000
00000000122200000000000000000021111888118881188811888118881111111888111111188811888118880000000000000000000000000000000000000000
00000000120000000000000000002221111888118881188811888118881111111888111181188811888118880000000000000000000000000000000000000000
00000000122200000000000000000021111888118881188811888118881111111888111881188811888118880000000000000000000000000000000000000000
00000000120002020202020202020021111888118881188811888118881111111888118881188811888118880000000000000000000000000000000000000000
00000000114002020202020202020411111881118811188111881118811111111881118881188111881118810000000000000000000000000000000000000000
00000000111222222222222222222111111811118111181111811118111111111811118888881111811118110000000000000000000000000000000000000000
00000000111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000
00000000222222221111111112000021777777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000
00000000200000021111111111200211111777111777111111111777177711111111177700000000000000000000000000000000000000000000000000000000
00000000222222221211111111122111111777111777711111117777117771111111777100000000000000000000000000000000000000000000000000000000
00000000120000211111111111200211111777111177711111117771111777111117771100000000000000000000000000000000000000000000000000000000
00000000112002111111111112000021111777111177771111177771111177711177711100000000000000000000000000000000000000000000000000000000
00000000111221111111111122222222111777111117771111177711111117771777111100000000000000000000000000000000000000000000000000000000
00000000112002111111141120000002111777111117777111777711111111777771111100000000000000000000000000000000000000000000000000000000
00000000120000211111111122222222111777111111777111777111111111177711111100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111777717777111111111777771111100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111177717771111111117771777111100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111177777771111111177711177711100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111117777711111111777111117771100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111117777711111117771111111777100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111777111111111777111111177711111111177700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000011111aaaaa11111111111aaaaa11111111aaa11111777111119991111188811100000000000000000000000000000000
00000000000000000000000000000000111aaa888aaa1111111aaaeeeaaa111111aaa11111777111119991111188811100000000000000000000000000000000
0000000000000000000000000000000011aaa87888aaa11111aaae7eeeaaa1111199911111ccc111114441111122211100000000000000000000000000000000
000000000000000000000000000000001aaaa88888aaaa111aaaaeeeeeaaaa111199911111ccc111114441111122211100000000000000000000000000000000
000000000000000000000000000000001aaaaa888aaaaa111aaaaaeeeaaaaa111199911111ccc111114441111122211100000000000000000000000000000000
00000000000000000000000000000000aa000aaaaa000aa1aa000aaaaa000aa11199911111ccc111114441111122211100000000000000000000000000000000
00000000000000000000000000000000aa0c00aaa00c0aa1aa0000aaa0000aa1aaaaaaa177777771999999918888888100000000000000000000000000000000
00000000000000000000000000000000aa0cc00000cc0aa1aa0d0000000d0aa1aaaaaaa177777771999999918888888100000000000000000000000000000000
00000000000000000000000000000000aa0ccc000ccc0aa1aa0dd00000dd0aa11766661117777711199999111888881100000000000000000000000000000000
00000000000000000000000000000000aa00cc000cc00aa1aa00dd000dd00aa11766661117777711199999111888881100000000000000000000000000000000
00000000000000000000000000000000aaa000000000aaa1aaa000000000aaa11766661117777711199999111888881100000000000000000000000000000000
000000000000000000000000000000001aaa0000000aaa111aaa0000000aaa111760761117707711199099111880881100000000000000000000000000000000
000000000000000000000000000000001aaaa00000aaaa111aaaa00000aaaa111760761117707711199099111880881100000000000000000000000000000000
0000000000000000000000000000000011aaaa000aaaa11111aaaa000aaaa1111760761117707711199099111880111100000000000000000000000000000000
00000000000000000000000000000000111aaa000aaa1111111aaa000aaa11111760761117707711199099111811111100000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111111760761117707711199099111111111100000000000000000000000000000000
11111666661111111111166666611111111666000666111111116666661111111760761117707711199099111111111100000000000000000000000000000000
11166655566611111116666666666111116666000666611111666666666611111760761117707711199099111111181100000000000000000000000000000000
11666575556661111166600000666611166660000066661116666000006661111760761117707711199099111180881100000000000000000000000000000000
16666555556666111666600000066661166600000006661166660000006666111760761117707711199099111880881100000000000000000000000000000000
16666655566666111666600000006661666000000000666166600000006666111760761117707711199099111880881100000000000000000000000000000000
66000666660006616655660000000661660000000000066166000000066556611760761117707711199099111880881100000000000000000000000000000000
66000066600006616555566000000001660000000000066100000000665575611760761117707711199099111880881100000000000000000000000000000000
66000000000006616555566000000001660000000000066100000000665555611760761117707711199099111880881100000000000000000000000000000000
66000000000006616575566000000001660000666000066100000000665555611760761117707711199099111880881100000000000000000000000000000000
66000000000006616655660000000661660006666600066166000000066556611760761117707711199099111880881100000000000000000000000000000000
66600000000066611666600000006661166666555666661166600000006666111760761117707711199099111880881100000000000000000000000000000000
16660000000666111666600000066661166665555566661166660000006666111760761117707711199099111880881100000000000000000000000000000000
16666000006666111166600000666611116665557566611116666000006661111766661117777711199999111888881100000000000000000000000000000000
11666600066661111116666666666111111666555666111111666666666611111766661117777711199999111888881100000000000000000000000000000000
11166600066611111111166666611111111116666611111111116666661111111176611111777111119991111188811100000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111117111111171111111911111118111100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000011bb1111111bb1111111bb111bb1111100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001bbbbb111bbbbb11bbbbbb111bbbbbb100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001b0b0bb1bb0b0b11bb0b0b111b0b0bb100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbbbbb1bbbbbbb11bbbbb111bbbbb1100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bb000b111b000bb11b000bb1bb000b1100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001bbbbb111bbbbb111bbbbbb1bbbbbb1100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000111bb11111bb11111bb111111111bb1100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111100000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000011111bbbbb11111111111bbbbb11111111111111111111111111111111111111
0000000000000000000000000000000000000000000000000000000000000000111bb00000bb1111111bb00000bb11111111111111111111111bbbbbbbbb1111
000000000000000000000000000000000000000000000000000000000000000011b000000000b11111b000000000b111111bbbbbbbbb111111bbbbbbbbbbb111
00000000000000000000000000000000000000000000000000000000000000001b00000000000b111b00000000000b1111bbbbbbbbbbb1111bbbbbbbbbbbbb11
00000000000000000000000000000000000000000000000000000000000000001b00000000000b111b08000000080b1111bbbbbbbbbbb1111bbbbbbbbbbbbb11
0000000000000000000000000000000000000000000000000000000000000000b0080000000800b1b0088000008800b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
0000000000000000000000000000000000000000000000000000000000000000b0088000008800b1b0080800080800b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
0000000000000000000000000000000000000000000000000000000000000000b0080800080800b1b0000000000000b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
0000000000000000000000000000000000000000000000000000000000000000b0000000000000b1b00bbbbbbbbb00b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
0000000000000000000000000000000000000000000000000000000000000000b0000000000000b1b000b0b0b0b000b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
0000000000000000000000000000000000000000000000000000000000000000b00bbbbbbbbb00b1b0000000000000b11bbbbbbbbbbbbb11bbbbbbbbbbbbbbb1
00000000000000000000000000000000000000000000000000000000000000001b00bb00bbb00b111b00000000000b1111bbbbbbbbbbb1111bbbbbbbbbbbbb11
00000000000000000000000000000000000000000000000000000000000000001b00b0000b000b111b000b0b0b000b1111bbbbbbbbbbb1111bbbbbbbbbbbbb11
000000000000000000000000000000000000000000000000000000000000000011b0b0000b00b11111b0bbbbbbb0b111111bbbbbbbbb111111bbbbbbbbbbb111
0000000000000000000000000000000000000000000000000000000000000000111000000b0011111110bb000b0011111111111111111111111bbbbbbbbb1111
00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111
__map__
0102020301212222222222222302020301020203010202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121311212222222222222312121311121213111212130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010202212222222222222303010202030102020301020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213111212212222222222222313111212131112121311121213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102020301212222222222222302020301020203010202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121311212222222222222312121311121213111212130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010202212222222222222303010202030102020301020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213111212212222222222222313111212131112121311121213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102020301212222222222222302020301020203010202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121311212222222222222312121311121213111212130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010202212222222222222303010202030102020301020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213111212212222222222222313111212131112121311121213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102020301212222222222222302020301020203010202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121311212222222222222312121311121213111212130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010202212222222222222303010202030102020301020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213111212212222222222222313111212131112121311121213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102020301212222222222222302020301020203010202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121311212222222222222312121311121213111212130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010202212222222222222303010202030102020301020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213111212212222222222222313111212131112121311121213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
