pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- impish
--
input={}

function press_start()
	local bool=input.b4 or input.b5
	input.b4=false
	input.b5=false
	return bool
end

function input.update_button(n)
	local key="_released_"..n
	if btn(n) then
		input["b"..n]=input[key]
		input[key]=false
	else
		input[key]=true
	end
end

frame={
	priority=-1,
	draw=function()
		rect(-1,-1,128,128,0)
		camera()
		print(#update,3,2,7)
	end
}

function clear(table)
	for i,v in ipairs(table) do
		table[i]=nil
	end
end

function flush(table)
	for item in all(table) do
		del(update,item)
		del(draw,item)
	end
	clear(table)
end

function copy(table)
	for item in all(table) do
		insert(update,item,"update_p")
		insert(draw,item,"draw_p")
	end
	clear(table)
end

function insert(table,item,key)
	local curr,push
	for i=1,#table do
		curr=table[i]
		if push then
			table[i]=push
			push=curr
		elseif item[key]>curr[key] then
			push=curr
			table[i]=item
		end
	end
	add(table,push or item)
end

function id()
end

function make(table,opts)
	opts=opts or {}
	local entity={
		t=opts.t or 0,
		x=opts.x or 0,
		y=opts.y or 0,
		dx=opts.dx or 0,
		dy=opts.dy or 0,
		id=table.id or 0,
		size=table.size or 1,
		update_p=table.priority or 0,
		draw_p=table.priority or 0,
		init=table.init or id,
		update=table.update or id,
		draw=table.draw or id
	}
	entity:init()
	add(buffer,entity)
	return entity
end

function _init()
	update={}
	draw={}
	buffer={}
	trash={}
	make(stage)
	make(title,{t=128})
	--make(hero,{x=56,y=24})
	make(frame)
end

function _update()
	input.update_button(4)
	input.update_button(5)
	copy(buffer)
	for i=1,#update do
		update[i]:update()
	end
	flush(trash)
end

function _draw()
	for i=1,#draw do
		draw[i]:draw()
	end
end
-->8
-- definitions
--
stage={
	rumble=0,
	priority=102,
	init=function(e)
		palt(0,false)
		palt(1,true)
	end,
	update=function(e)
		if stage.rumble>0 then
			stage.rumble-=1
		end
		e.t+=1
	end,
	draw=function(e)
		cls()
		if stage.rumble>0 then
			camera(rnd(2),rnd(2))
		end
		local oy=flr(e.t/4)%32
		map(64,0,0,-oy,16,20)
		oy=e.t%32
		map(0,0,0,-oy,16,20)
	end
}

title={
	priority=101,
	update=function(e)
		if e.t==80 and press_start() then
			e.t-=1
		elseif e.t==81 then
			stage.rumble=11
			e.t-=1
		elseif e.t>0 and e.t!=80 then
			e.t-=1
		end
	end,
	draw=function(e)
		if(e.t==0)return
		local ox,oy
		if e.t>80 then
			ox=-614+e.t*8
			oy=324-e.t*4
		elseif e.t>78 then
			ox=34
			oy=0
		else
			ox=34
			oy=1248-e.t*16
		end
		rectfill(0,70+oy,127,128,0)
		rect(-1,70+oy,128,88+oy,8)
		if e.t==80 then
			pal(8,10)
			print("press 🅾️ or ❎",64,92,10)
		end
		spr(96,ox,72+oy,7,2)
		pal(8,8)
	end
}
__gfx__
0000000000000000000000000000000011111bbbbb11111111111aaaaa11111111111eeeee1111111111199999111111111116666611111111111fffff111111
00000000000000000000000000000000111bb00000bb1111111aa00000aa1111111eeeeeeeee111111199999999911111116666666661111111fffffffff1111
0070070000000000000000000000000011b000000000b11111a000000000a11111eeeeeeeeeee1111199998888899111116666666666611111fffffffffff111
000770000000000000000000000000001b00000000000b111a00000000000a111eeeeeeeeeeeee11199998888888991116666666666666111fffffffffffff11
000770000000000000000000000000001b00000000000b111a08000000080a111777ccc000ccc711199988800088891116600066600066111f000fffff000f11
00700700000000000000000000000000b0080000000800b1a0088000008800a17777cc00070cc77199998800090889916600006660000661ff0000fff0000ff1
00000000000000000000000000000000b0088000008800b1a0080800080800a17777cc00000cc77199998800000889916600006660000661ff0880fff0880ff1
00000000000000000000000000000000b0080800080800b1a0000000000000a17777cc00000cc77199998800000889916600006660000661ff0000f0f0000ff1
00000000000000000000000000000000b0000000000000b1a00aaaaaaaaa00a17777ccc000ccc77199998880008889916666666066666661fffffff0fffffff1
00000000000000000000000000000000b0000000000000b1a000a0a0a0a000a177777ccccccc7771999998888888999166666660666666611fffffffffffff11
00000000000000000000000000000000b00bbbbbbbbb00b1a0000000000000a1177777ccccc777111999998888899911166666666666661111ff0ff0ff0ff111
000000000000000000000000000000001b00bb00bbb00b111a00000000000a111eeeeeeeeeeeee1119999999999999111166066066066111110000000000f111
000000000000000000000000000000001b00b0000b000b111a000a0a0a000a1111eeeeeeeeeee11111999999999991111100000000006111110000000000f111
0000000000000000000000000000000011b0b0000b00b11111a0aaaaaaa0a111111eeeeeeeee111111199999999911111166066066066111110000000000f111
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
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
686869676a0000000000006a686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
787879776a0000000000006a787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879776b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
696768686a0000000000006a696768686967686869676868696768686967686869676868696768686967686869676868696768686967686869676868696768686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
797778786a0000000000006a797778787977787879777878797778787977787879777878797778787977787879777878797778787977787879777878797778786b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b
