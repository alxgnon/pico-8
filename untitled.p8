pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- untitled
-- stuff
-------------------------------

hero={}

function hero:init(x,y)
	self.e=000
	self.x=x
	self.y=y
	self.dx=0
	self.dy=0
end

function collide(a)
	local i,j=a.x/8,a.y/8
	if fget(mget(i,j),0) then
	end
	a.x+=a.dx
	a.y+=a.dy
end

function hero:move()
	self.dx=0
	self.dy=0
	if(btn"0")self.dx-=3
	if(btn"1")self.dx+=3
	if(btn"2")self.dy-=3
	if(btn"3")self.dy+=3
	if(btn"4")self.f=true
	if(btn"5")self.f=false
	collide(self)
end

function sprite(a)
	spr(a.e,a.x-4,a.y-4,1,1,a.f)
end

function hero:draw()
	sprite(hero)
end

-------------------------------

room={}

function flr128(a,b)
	a.x=flr(b.x/128)*128
	a.y=flr(b.y/128)*128
end

function room:init(hero)
	flr128(room,hero)
end

function room:move(hero)
	flr128(room,hero)
end

function map128(x,y)
	map(x/8,y/8,x,y,16,16)
end

function room:draw()
	camera(self.x,self.y)
	map128(self.x,self.y)
end

-------------------------------

function setup()
	palt(0,false)
	palt(1,true)
end

function _init()
	setup()
	hero:init(32,32)
	room:init(hero)
end

function _update()
	hero:move()
	room:move(hero)
end

function _draw()
	cls()
	room:draw()
	hero:draw()
end
__gfx__
11177111666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11170711666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11777711666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771111666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777771666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11771111666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11171711666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
10101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111611161616661111161611111611161616661111161617771c1c11111c1c1111111111111111111111111111111111111111111111111111111111111111
11111611166616161111116111111611166616161111166611111c1c11111c1c1111111111111111111111111111111111111111111111111111111111111111
11111611161616161111161611711611161616161111111617771c1c11711c1c1111111111111111111111111111111111111111111111111111111111111111
11111166161616161666161617111166161616161666166611111ccc17111ccc1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111116616661666111116661661166616661166161611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116161666111116111616161116161611161617771c1c1111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116661616111116611616166116611611166611111c1c1111111111111111111111111111111111111111111111111111111111111111111111111111
1111161116161616111116111616161116161616111617771c1c1111111111111111111111111111111111111111111111111111111111111111111111111111
1111116616161616166616661616166616161666166611111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161616661666116611111616111116161666166611661111161611111ccc1ccc11111ccc1ccc111111111111111111111111111111111111111111111111
111116161611161616161111161611111616161116161616111116161777111c111c1111111c111c111111111111111111111111111111111111111111111111
11111666166116611616111111611111166616611661161611111666111111cc1ccc111111cc1ccc111111111111111111111111111111111111111111111111
111116161611161616161111161611711616161116161616111111161777111c1c111171111c1c11111111111111111111111111111111111111111111111111
1111161616661616166116661616171116161666161616611666166611111ccc1ccc17111ccc1ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111616166616611666166616661171117111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161616116116111711111711111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111616166616161666116116611711111711111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161116161616116116111711111711111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661166161116661616116116661171117111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee11711bbb1bbb1bb11c1c1ccc1c1c1171161616661666116611111616111111111ccc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b1c1c1c1c1c1c111716161611161616161111161611111777111c111111111111111111111111111111111111111111111111
111111e11ee117111bb111b11b1b11111c1c111111171666166116611616111111611777111111cc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b11111c1c1111111716161611161616161111161611111777111c111111111111111111111111111111111111111111111111
11111eee1e1111711bbb11b11b1b11111ccc11111171161616661616166116661616111111111ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee11711bbb1bbb1bb11c1c1cc11c1c1171161616661666116611111616111111111ccc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b1c1c11c11c1c111716161611161616161111161611711777111c111111111111111111111111111111111111111111111111
111111e11ee117111bb111b11b1b111111c1111111171666166116611616111111611777111111cc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b111111c11111111716161611161616161111161611711777111c111111111111111111111111111111111111111111111111
11111eee1e1111711bbb11b11b1b11111ccc11111171161616661616166116661616111111111ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee11711bbb1bbb1bb11c1c1ccc1c1c1171161616661666116611111616111111111ccc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b1c1c111c1c1c111716161611161616161111161611111777111c111111111111111111111111111111111111111111111111
111111e11ee117111bb111b11b1b11111ccc111111171666166116611616111116661777111111cc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b11111c111111111716161611161616161111111611111777111c111111111111111111111111111111111111111111111111
11111eee1e1111711bbb11b11b1b11111ccc11111171161616661616166116661666111111111ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee11711bbb1bbb1bb11c1c1ccc1c1c1171161616661666116611111616111111111ccc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b1c1c111c1c1c111716161611161616161111161611711777111c111111111111111111111111111111111111111111111111
111111e11ee117111bb111b11b1b111111cc111111171666166116611616111116661777111111cc111111111111111111111111111111111111111111111111
111111e11e1117111b1b11b11b1b1111111c1111111716161611161616161111111611711777111c111111111111111111111111111111111111111111111111
11111eee1e1111711bbb11b11b1b11111ccc11111171161616661616166116661666111111111ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee111116161666166611661111161611111ccc1ccc11171166166616661111161611111eee1e1e1eee1ee111111111111111111111111111111111
111111e11e1111111616161116161616111116161111111c111c117116111616166611111616111111e11e1e1e111e1e11111111111111111111111111111111
111111e11ee11111166616611661161611111161177711cc1ccc171116111666161611111161111111e11eee1ee11e1e11111111111111111111111111111111
111111e11e1111111616161116161616111116161111111c1c11117116111616161611111616111111e11e1e1e111e1e11111111111111111111111111111111
11111eee1e11111116161666161616611666161611111ccc1ccc111711661616161616661616111111e11e1e1eee1e1e11111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661666166611111616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611161616661111161611111777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116111666161611111161177711111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116111616161611111616111117771c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661616161616661616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111ee1eee1eee1eee111116161666166611661111161617111166166616661111161611111cc11cc11ccc11111eee1e1e1eee1ee1111111111111
11111e111e111e111e1111e11e111111161616111616161611111616117116111616166611111616117111c111c1111c111111e11e1e1e111e1e111111111111
11111ee11e111eee1ee111e11ee11111166616611661161611111161111716111666161611111161177711c111c11ccc111111e11eee1ee11e1e111111111111
11111e111e11111e1e1111e11e111111161616111616161611111616117116111616161611111616117111c111c11c11111111e11e1e1e111e1e111111111111
11111eee1eee1ee11eee1eee1e11111116161666161616611666161617111166161616161666161611111ccc1ccc1ccc111111e11e1e1eee1e1e111111111111
11111111111111111111111111111111111188888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111116616661666111116161111111188888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161116161666111116161171177788888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161116661616111111611777111188888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161116161616111116161171177788888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111116616161616166616161111111188888111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee111116161666166611661111161611111ccc1ccc11171166166616661111161611111eee1e1e1eee1ee111111111111111111111111111111111
111111e11e1111111616161116161616111116161111111c111c117116111616166611111616111111e11e1e1e111e1e11111111111111111111111111111111
111111e11ee11111166616611661161611111666177711cc1ccc171116111666161611111666111111e11eee1ee11e1e11111111111111111111111111111111
111111e11e1111111616161116161616111111161111111c1c11117116111616161611111116111111e11e1e1e111e1e11111111111111111111111111111111
11111eee1e11111116161666161616611666166611111ccc1ccc111711661616161616661666111111e11e1e1eee1e1e11111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661666166611111616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611161616661111161611111777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161116661616111116661777111111cc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611161616161111111611111777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661616161616661666111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111ee1eee1eee1eee111116161666166611661111161617111166166616661111161611111cc11cc11ccc11111eee1e1e1eee1ee1111111111111
11111e111e111e111e1111e11e111111161616111616161611111616117116111616166611111616117111c111c1111c111111e11e1e1e111e1e111111111111
11111ee11e111eee1ee111e11ee11111166616611661161611111666111716111666161611111666177711c111c11ccc111111e11eee1ee11e1e111111111111
11111e111e11111e1e1111e11e111111161616111616161611111116117116111616161611111116117111c111c11c11111111e11e1e1e111e1e111111111111
11111eee1eee1ee11eee1eee1e11111116161666161616611666166617111166161616161666166611111ccc1ccc1ccc111111e11e1e1eee1e1e111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661666166611111616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611161616661111161611711777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161116661616111116661777111111cc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611161616161111111611711777111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111661616161616661666111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822882888882828282288888888888888888888888888888888888888888888888888228822282828882822282288222822288866688
82888828828282888888882882888828828288288888888888888888888888888888888888888888888888888828888282828828828288288282888288888888
82888828828282288888882882228828822288288888888888888888888888888888888888888888888888888828888282228828822288288222822288822288
82888828828282888888882882828828888288288888888888888888888888888888888888888888888888888828888288828828828288288882828888888888
82228222828282228888822282228288888282228888888888888888888888888888888888888888888888888222888288828288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000001000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010100000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010100000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
