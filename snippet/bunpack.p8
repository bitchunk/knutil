pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--bunpack
--v0.1
--@shiftalow / bitchunk

--[[
	- bunpack            -- slice the value with bit width.
	- @param  number b   -- the value to slice.
	- @param  number s   -- bit value to right-shift before the first slice.
	- @param  number w   -- bit width to the first slice.
	- @param  number ... -- bit width to the next slices.
	- @return ...        -- returns the sliced value as a tuple.
	- @description
    -- by specifying the argument after [number w], a value of up to 32 bits can be sliced.
    -- by setting [number s] to a negative value, bit slice can be started from the decimal point.
]]--

---- big-endian
--function bunpack(b,s,w,...)
--if w then
--return flr(0x.ffff<<w&b>>>s),bunpack(b,s-(... or 0),...)
--end
--end

-- little-endian
function bunpack(b,s,w,...)
if w then
return flr(0x.ffff<<w&b<<s),bunpack(b,s-(w or 0),...)
end
end
----
cls()

?'\n\f9★\fb[0xf4]\f6 slice to'
?'               "0xf" and "0x4"\n'
local a,b=bunpack(0xf4,4,4,4)
?a..' '..b,7

?'\n\n\f9★\fb[0xfe83.ffff]\f6 slice with'
?'     bit-widths of "8" and "4"\n'
local v={bunpack(0xfe83.ffff,8,8,8,4,4,8,4)}
local s=''
for i,v in pairs(v) do
s..=v..' '
end
?s,7
?'     \f6(0 if it overflows.)'

?'\n\n\f9★\fb[0xf7f7.fff7]\f6 slice with 1'
?'             bit-widths of "1"\n'
local v={
	bunpack(
		0xf7f7.fff7
		,15
		,unpack(split(
			'11111111'   -- from:32 to:25
			..'11111111' -- from:24 to:17
			..'11111111' -- from:16 to: 9
			..'11111111' -- from:8  to: 1
	,''
	)))}
local s=''
for i,v in pairs(v) do
?'。\+ci。\+ci。',i*3,100,(v==1 and (i%4==1 and 7 or 6) or 0)
end
--?' (0 if it overflows.) \n'

-->8
--[[
update history
**v0.1**
	- first release
]]--

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000bb00bbb0b0b0bbb0b0b00bb0000006606000666006606660000066600660000000000000000000000000000000000000000000000000000000000000
00999000b000b0b0b0b0b000b0b000b0000060006000060060006000000006006060000000000000000000000000000000000000000000000000000000000000
99999990b000b0b00b00bb00bbb000b0000066606000060060006600000006006060000000000000000000000000000000000000000000000000000000000000
09999900b000b0b0b0b0b00000b000b0000000606000060060006000000006006060000000000000000000000000000000000000000000000000000000000000
09000900bb00bbb0b0b0b00000b00bb0000066006660666006606660000006006600000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000060606660606066606060000066606600660000006060666060606060606000000000
00000000000000000000000000000000000000000000000000000000000060606060606060006060000060606060606000006060606060606060606000000000
00000000000000000000000000000000000000000000000000000000000000006060060066000000000066606060606000000000606006006660000000000000
00000000000000000000000000000000000000000000000000000000000000006060606060000000000060606060606000000000606060600060000000000000
00000000000000000000000000000000000000000000000000000000000000006660606060000000000060606060666000000000666060600060000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77007770000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007770000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000070000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707770000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00090000bb00bbb0b0b0bbb0bbb0bbb0bbb00000bbb0bbb0bbb0bbb00bb000000660600066600660666000006060666066606060000000000000000000000000
00999000b000b0b0b0b0b000b000b0b000b00000b000b000b000b00000b000006000600006006000600000006060060006006060000000000000000000000000
99999990b000b0b00b00bb00bb00bbb00bb00000bb00bb00bb00bb0000b000006660600006006000660000006060060006006660000000000000000000000000
09999900b000b0b0b0b0b000b000b0b000b00000b000b000b000b00000b000000060600006006000600000006660060006006060000000000000000000000000
09000900bb00bbb0b0b0b000bbb0bbb0bbb00b00b000b000b000b0000bb000006600666066600660666000006660666006006060000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000666066606660000060606660660066606060066000000660666000006060666060600000666066006600000060606060606000000000
00000000000000000000606006000600000060600600606006006060600000006060600000006060606060600000606060606060000060606060606000000000
00000000000000000000660006000600666060600600606006006660666000006060660000000000666000000000666060606060000000006660000000000000
00000000000000000000606006000600000066600600606006006060006000006060600000000000606000000000606060606060000000000060000000000000
00000000000000000000666066600600000066606660666006006060660000006600600000000000666000000000606060606660000000000060000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707770707000007700777077000000770077700000770077700000777077707770000077700000000000000000000000000000000000000000000000000000
00707000707000000700007007000000070070000000070070000000007070007000000070700000000000000000000000000000000000000000000000000000
77707770777000000700077007000000070077700000070077700000777077707770000070700000000000000000000000000000000000000000000000000000
70000070007000000700007007000000070000700000070000700000700000700070000070700000000000000000000000000000000000000000000000000000
77707770007000007770777077700000777077700000777077700000777077707770000077700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000060066600000666066600000666066600000066060606660666066606000066060600660000006000000000000000000000000000000
00000000000000000000600060600000060060000000060006000000606060606000606060006000606060606000000000600000000000000000000000000000
00000000000000000000600060600000060066000000060006000000606060606600660066006000606060606660000000600000000000000000000000000000
00000000000000000000600060600000060060000000060006000000606066606000606060006000606066600060000000600000000000000000000000000000
00000000000000000000060066600000666060000000666006000000660006006660606060006660660066606600060006000000000000000000000000000000
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
00090000bb00bbb0b0b0bbb0bbb0bbb0bbb00000bbb0bbb0bbb0bbb00bb000000660600066600660666000006060666066606060000066000000000000000000
00999000b000b0b0b0b0b00000b0b00000b00000b000b000b00000b000b000006000600006006000600000006060060006006060000006000000000000000000
99999990b000b0b00b00bb0000b0bb0000b00000bb00bb00bb0000b000b000006660600006006000660000006060060006006660000006000000000000000000
09999900b000b0b0b0b0b00000b0b00000b00000b000b000b00000b000b000000060600006006000600000006660060006006060000006000000000000000000
09000900bb00bbb0b0b0b00000b0b00000b00b00b000b000b00000b00bb000006600666066600660666000006660666006006060000066600000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000006660666066600000606066606600666060600660000006606660000060606600606000000000
00000000000000000000000000000000000000000000000000006060060006000000606006006060060060606000000060606000000060600600606000000000
00000000000000000000000000000000000000000000000000006600060006006660606006006060060066606660000060606600000000000600000000000000
00000000000000000000000000000000000000000000000000006060060006000000666006006060060060600060000060606000000000000600000000000000
00000000000000000000000000000000000000000000000000006660666006000000666066606660060060606600000066006000000000006660000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00077066066066000066066066077066066066000066066066077066066066077066066066077066066066000066066066000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

