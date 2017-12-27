pico-8 cartridge // http://www.pico-8.com
version 14
__lua__
cards={
{017,"the fool"},
{160,"the sun"},
{162,"the moon"},
{004,"a disk of wealth"},
{006,"two disks of change"},
{008,"three disks of work"},
{010,"four disks of power"},
{012,"five disks of worry"},
{014,"six disks of success"},
--{068,"a sword"},
--{070,"two swords"},
--{072,"three swords"},
--{074,"four swords"},
--{076,"five swords"},
--{078,"six swords"},
{132,"a cup of love"},
{134,"two cups of union"},
{136,"three cups of sharing"},
{138,"four cups of choice"},
{140,"five cups of regret"},
{142,"six cups of pleasure"},
--{196,"a wand"},
--{198,"two wands"},
--{200,"three wands"},
--{202,"four wands"},
--{204,"five wands"},
--{206,"six wands"},
}
-->8
function new_card(sprite, name)
	local card = {
		sprite = sprite,
		name = name,
		x = 0, y = 0,
		faceup = false,
		inversed = false,
	}

	function card:flip()
		self.faceup = not self.faceup
	end

	function card:inverse()
		self.inversed = not self.inversed
	end

	function card:hover()
	 return
	 		hand.x > card.x and
 			hand.x < card.x + 26 and
 			hand.y > card.y and
 			hand.y < card.y + 28
	end

	function card:draw()
 	local x,y = self.x,self.y

 	if self.inversed and self.faceup then
 		spr(48,x,y+4,4,1,-1,-1)
  	spr(19,x,y+4,1,3,-1,-1)
  	spr(16,x+24,y+4,1,3,-1,-1)
  	spr(0,x,y+28,4,1,-1,-1)
 		spr(self.sprite,x+8,y+12,2,2,-1,-1)
 	elseif self.faceup then
 		spr(0,x,y,4,1)
  	spr(16,x,y+8,1,3)
  	spr(19,x+24,y+8,1,3)
  	spr(48,x,y+24,4,1)
 		spr(self.sprite,x+8,y+8,2,2)
 	elseif self.inversed then
 		spr(64,x,y+4,4,4,-1,-1)
 	else
 		spr(64,x,y,4,4)
 	end
	end

	return card
end
-->8
deck = {}

for c in all(cards) do
	local card = new_card(c[1], c[2])
	add(deck, card)
end

function deck:shuffle()
	local limbo = {}
	for card in all(self) do
		del(self, card)
		add(limbo, card)

		if rnd"666" > 633 then
			card:inverse()
		end
	end

	local offset = 1
	
	while #limbo > 0 do
		local i = rnd(#limbo)
 	local card = limbo[flr(i+1)]
 	del(limbo, card)
 	add(self, card)
 	
 	card.x = 96 + flr(offset)
 	card.y = 2 + flr(offset)
 	offset -= 0.2
	end
end

function deck:top()
	for i=#self,1,-1 do
		local card = self[i]

		if card:hover() then
			return card
		end
	end
end
-->8
hand = {
	x = 88, y = 12,
	card = nil,
	open = 128,
	closed = 129,
}

function hand:move()
	local dx,dy = 0,0
	if (btn"0") dx -= 2
	if (btn"1") dx += 2
	if (btn"2") dy -= 2
	if (btn"3") dy += 2

	self.x += dx
	self.y += dy

	if self.card then
		self.card.x += dx
		self.card.y += dy
	end
end

function hand:grab()
	if not btn"4" then
		self.hold4 = false
	elseif not self.hold4 then
		self.hold4 = true

		if self.card then
			card = self.card
			self.card = nil
			add(deck, card)
			card.x += 1
			card.y += 1
			sfx(2)
		else
			local top = deck:top()
			if top then
				del(deck, top)
				self.card = top
				top.x -= 1
				top.y -= 1
				sfx(1)
			end
		end
	end
end

function hand:flip()
	if not btn"5" then
		self.hold5 = false
	elseif not self.hold5 then
		self.hold5 = true

		if self.card then
			self.card:flip()
			sfx(3)
		else
			local top = deck:top()
			if top then
				top:flip()
				sfx(3)
			end
		end
	end
end

function hand:draw()
	if self.card then
		local cx,cy = self.card.x,self.card.y
		rect(cx+6,cy+6,cx+28,cy+31,1)
		rect(cx+6,cy+6,cx+27,cy+32,1)
			
		self.card:draw()
		spr(self.closed,self.x,self.y)
	else
		spr(self.open,self.x,self.y)
	end
end

-->8
function _init()
	deck:shuffle()
end

function _update()
	hand:move()
	hand:grab()
	hand:flip()
end

function get_tip()
	if hand.card and hand.card.faceup then
	 return hand.card.name
	end

	local top = deck:top()
	if top and top.faceup then
		return top.name
	end
end

function draw_tip(tip)
	rectfill(0,122,128,128,0)
	rect(0,121,128,121,2)
	print(tip,0,123,7)
end

function _draw()
	cls(0)
	map(0,0,0,0,16,16)

	for card in all(deck) do
		card:draw()
	end

	hand:draw()

	local tip = get_tip()
 if (tip) draw_tip(tip)
end
__gfx__
00000000000000000000000000000000111111111111111111111bbbbb1111111111111111111111616161111116161611111199991111111111111111111111
0000000000000000000000000000000011111111111171111111bb8b3333b1111111111111616111666661111116666611111977779111111111111111111111
00000000000000000000000000000000117114aaaaa77711111bbbbb33333b111111111116666611666665555556666611119777777911111111111111111111
0000000000000000000000000000000017774aaaaaaa711111b3bbbbbb1333b11111111111616111655666666666655611119777777911111111111111111111
000002222222222222222222222000001174aaa999aaa1111b333b77111133b11111111116666611655666666666655611119777777911111111111111111111
00002277777777777777777777220000114aaa9aaa9aaa11b33337777111333b1111111114646111655666666666655611119777777911111111111111111111
00002771111111111111111117720000114aa9aa9aa9aa11b33377177111333b1111111114441111155633333333655111111977779111111111111111111111
00002711111111111111111111720000114aa9aa9aa9aa11b33377777111333b111111144fff4411155333333333355111111199991111111111111111111111
0000271111111aa5b491111111720000114aa9aa9aa9aa11b33377711111333b161661664f1f4111155333333333355111111111111111111111111111111111
000027111113eedee2e8e11111720000114aaa9aaa9aaa11b33377711711333b166666644fff4411656363333336365611111111111111111111111111111111
0000271111e8aee666aaa411117200001114aaa999aaa111b33337711113333b1167776614441111666663333336666611111111111111111111111111111111
0000271119e756644b7e79911172000011114aaaaaaa11111b333377113333b11667176614141111661665555556616611111111111111111111111111111111
000027111ccca1111118993111720000111114aaaaa1171111b3333333333b111667776111111111661666666666616611111111111111111111111111111111
00002711ddbb11777711f963117200001111111111117771111b33333333b1111166666611111111666666644666666611111111111111111111111111111111
0000271199dd11111711bd8c1172000011111111111117111111b333333b11111661661611111111666666644666666611111111111111111111111111111111
0000271199a811177711284c11720000111111111111111111111bbbbbb111111111111111111111166611111111666111111111111111111111111111111111
000027119c8e1117111144c311720000333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
00002711ee7e1111111193c311720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711443411171111564411720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
000027111444c1111112664111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
000027111aad47688332fd9111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
000027111166a27a7ec37c1111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
0000271111192722244f711111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111117995241111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111111111111111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111111111111111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111111111111111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111111111111111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002711111111111111111111720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002771111111111111111117720000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00002277777777777777777777220000300000000000000330000000000000033000000000000003300000000000000330000000000000033000000000000003
00000222222222222222222222200000333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111177777771
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111711111711117111171111111111711
00000000000000000000000000000000111111111111111111111111111111111111111111111111111711171117111117771117771177711777777777111111
00000222222222222222222222200000111111111111111111111171111711111111711171117111111711171117111111711111711117111171111111111111
000022aaaaaaaaaaaaaaaaaaaa220000111111117111111111111171111711111111711171117111111711171117111111711111711117111111111111111111
00002aa222222222222222222aa20000111111117111111111111171111711111111711171117111111711171117111111711711717117111111111111117111
00002a22222222222222222222a20000111111117111111111111171111711111111711171117111111711171117111111711711717117111111111777777711
00002a22222222222222222222a20000111111117111111111111777117771111117771777177711117771777177711111711711717117111111111111117111
00002a22222222222222222222a20000111111177711111111111171111711111111711171117111111711171117111111711711717117111117111111111111
00002a22222282222228222222a20000111111117111111111111111111111111111111111111111111111111111111111111711717111111177777771111111
00002a2222297f2222f7922222a20000111111111111111111111111111111111111111111111111111111111111111111111711117111111117111111111111
00002a2222a777e22e777a2222a20000111111111111111111111111111111111111111111111111111117111111111111117771177711111111111111117111
00002a22222b7d2222d7b22222a20000111111111111111111111111111111111111111111111111111777777777771111111711117111111117111177777711
00002a222222c222222c222222a20000111111111111111111111111111111111111111111111111111117111111111111111111111111111177777711117111
00002a22222222222222222222a20000111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111
00002a22222222222222222222a20000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00002a222222c222222c222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222b7d2222d7b22222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a2222a777e22e777a2222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a2222297f2222f7922222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222282222228222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002a22222222222222222222a20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00002aa222222222222222222aa20000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
000022aaaaaaaaaaaaaaaaaaaa220000c00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000cc00000000000000c
00000222222222222222222222200000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
01111100000000001111ddd111ddd11111111dcba98111111111111111111111111111aaaa11111111111aaaaaa1111117ddd711117ddd719991118888111ccc
0171711100000000dd111d11d11d111d11111dcba981111111111111111111111111111aa1111111111aaaaaaaaaa11117d1d711117d1d7119111118811111c1
0171717101111111dddd111ddd111ddd11111dcba98111116111116116111116111111aaaa111111111a1aa28aa1a11117ddd711117ddd719991118888111ccc
0171717101717171ddddd11ddd11dddd11111dcba9811111611111611611111611111aaaaaa111111111aaa82aaa1111111c11111111c1119991188888811ccc
117777711177777111dddd11d11dddd111111dcba9811111622222611622222611111aaaaaa1111111111aaaaaa11111111c11111111c1111d11188888811191
7177777117777771d111ddd111ddd111111444444444411162222261162222261111118282111111111111aaaa111111161c161111d1c1d11d111dcbaaa11191
1777777117777771ddd11ddd1ddd11dd111ffffffffffff1162226111162226111111828282111111111111aa111111116ccc61111dcccd11d111dcba9999991
1117771111177711dddd11dd1dd11ddd111ffeefeefff1f111666111111666111111828282821111111111aaaa11111111666111111ddd111d111dcba9888881
000000000000000011ddd1111111ddd1111ffeeeeefff1f11116111111116111111828282828211111111aaaaaa11111111611111111d1111dddddcba9811181
0000000000000000d11d111ddd111d11111ffffefffffff111161111111161111182828282828211111111111111111111666111111ddd111ccccccba9811181
0000000000000000dd111ddddddd111d1111ffffffff111111161111111161111128282828282811144411111111444111ddd111111666111c111bbba9811181
0000000000000000dd11ddddddddd11d1144444444444411111611111111611111666666444444111444116666114441111d1111111161111c111dddddd11181
0000000000000000d11dddd111dddd1111ffffffffffff11116661111116661111666666444444111141111661111411111d111114416111aaa11dddddd11bbb
000000000000000011ddd111d111ddd1111ffffffffff11116666611116666611116666114444111144411666611444111ddd41144466611aaa111dddd111bbb
00000000000000001ddd11ddddd11ddd11111111111111111111111111111111111166111144111111111666666111111ddd1444444166611a11111dd11111b1
00000000000000001dd11ddddddd11dd11111111111111111111111111111111111666611444411111111666666111111dd1141144116661aaa111dddd111bbb
11111119911111111111111111111111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111111111111111111111111111
1111119aa91111111111119999911111e00000000000000ee00000000000000ee00000000000000ee00000000000000e11111222221111111111111111111111
1199911111199911111199aaaaa91111e00000000000000ee00000000000000ee00000000000000ee00000000000000e111122eee21111111112ee11112ee111
119a11999911a9111119aaaa9999d111e00000000000000ee00000000000000ee00000000000000ee00000000000000e11122ee2e2211111112eeee112eeee11
119119aaaa911911119aaa99dddddd11e00000000000000ee00000000000000ee00000000000000ee00000000000000e11122eeee221111112eeeeee2eeeeee1
11119a7777a9111119aaa9ddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e11222ee22221111112eeeeeeeeeeeee1
1919a777777a919119aa9dddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e11222ee2e221111112eeeeaaaaaeeee1
9a19a777777a91a919aa9dddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e112221e22211111112eeeeaaaaaeeee1
9a19a777777a91a919aa9dddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e112221eeeeeee11112eeeeaaaaaeeee1
1919a777777a919119aa9dddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e11222111eeeeee11112eeeeaaaeeee11
11119a7777a9111119aaa9ddddddddd1e00000000000000ee00000000000000ee00000000000000ee00000000000000e1a222a1111aeeea11112eeaaaaaee111
119119aaaa911911119aaa99dddddd11e00000000000000ee00000000000000ee00000000000000ee00000000000000e1aaaaa1111aaaaa111112eeeeeee1111
119a11999911a9111119aaaa9999d111e00000000000000ee00000000000000ee00000000000000ee00000000000000e1aaaaa1111aaaaa1111112eeeee11111
1199911111199911111199aaaaa91111e00000000000000ee00000000000000ee00000000000000ee00000000000000e11aaa111111aaa111111112eee111111
1111119aa91111111111119999911111e00000000000000ee00000000000000ee00000000000000ee00000000000000e1aaaaa1111aaaaa111111112e1111111
11111119911111111111111111111111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111111111111111111111111111
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111117771777177711
00000000000000000000000000000000111111111111111111111111111111111111111111111111177711111111777117771177711177711117171717171711
00000000000000000000000000000000111111111111111111111111111111111111111111111111171711111111717117171171711171711117771777177711
00000000000000000000000000000000111111111111111111111111111111111111111111111111177711111111777117771177711177711111711171117111
00000000000000000000000000000000111111177711111111177717771111111117771777177711117111111111171111711117111117111111711171117111
00000000000000000000000000000000111111171711111111171717171111111117171717171711117111111111171111711117111117111111711171117111
00000000000000000000000000000000111111177711111111177717771111111117771777177711117111111111171111711117111117111111111111111111
00000000000000000000000000000000111111117111111111117111711111111111711171117111111111111111111111111111111111111111111111111111
00000000000000000000000000000000111111117111111111117111711111111111711171117111111777117771111111177711777111111117771777177711
00000000000000000000000000000000111111117111111111117111711111111111711171117111111717117171111111171711717111111117171717171711
00000000000000000000000000000000111111111111111111111111111111111111111111111111111777117771111111177711777111111117771777177711
00000000000000000000000000000000111111111111111111111111111111111111111111111111111171111711111111117111171111111111711171117111
00000000000000000000000000000000111111111111111111111111111111111111111111111111111171111711111111117111171111111111711171117111
00000000000000000000000000000000111111111111111111111111111111111111111111111111111171111711111111117111171111111111711171117111
00000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000000000000000000000999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000900000000000000990000000000000099000000000000009900000000000000990000000000000099000000000000009
00000000000000000000000000000000999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8283828382838283828382838283828300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9293929392939293929392939293929300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900001d6152d615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900001d02303000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001d02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000

