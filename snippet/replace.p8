pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--replace [perform string substitutions]
--v0.1
--@shiftalow / bitchunk

function replace(s,f,r)
local a,i='',1
while i<=#s do
if sub(s,i,i+#f-1)~=f then
a..=sub(s,i,i)
i+=1
else
a..=r or ''
i+=#f
end
end
return a
end

----
cls()
local str="i love [name]♥\n"

str=replace(str,"[name]","sushi")
?str

local str="you move forward."
						.."there is a bridge."
						.."you cross the bridge."
						.."you find a curry shop."

str=replace(str,".","! \\(^O^)/\n")
?str

local str="you got a banana."
						.."you found an apple."
						.."you ate an orange."

str
=replace(
		replace(
			replace(
				replace(str
					,"banana","\fa[bananaノ\vtノ]\f6"
				)
				,"apple","\f8[apple●\vvイ]\f6"
			)
			,"orange","\f9[orangeう\vzL]\f6"
		)
		,".",".\n"
	)
?str

-->8
--[[
update history
v0.1
	*first release
]]--
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
66600000600006606060666000000660606006606060666006606600000000000000000000000000000000000000000000000000000000000000000000000000
06000000600060606060600000006000606060006060060006666600000000000000000000000000000000000000000000000000000000000000000000000000
06000000600060606060660000006660606066606660060006666600000000000000000000000000000000000000000000000000000000000000000000000000
06000000600060606660600000000060606000606060060000666000000000000000000000000000000000000000000000000000000000000000000000000000
66600000666066000600666000006600066066006060666000060000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600660606000006660066060606660000066600660666060606660666066000600000060000600060000000600060000600000000000000000000000000000
60606060606000006660606060606000000060006060606060606060606060600600000006006000606006606060006006000000000000000000000000000000
66606060606000006060606060606600000066006060660060606660660060600600000006006000000060600000006006000000000000000000000000000000
00606060606000006060606066606000000060006060606066606060606060600000000006006000000060600000006006000000000000000000000000000000
66606600066000006060660006006660000060006600606066606060606066600600000000600600000066000000060060000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606060666066606660000066600660000066600000666066606660660006606660060000006000060006000000060006000060000000000000000000000000
06006060600060606000000006006000000060600000606060600600606060006000060000000600600060600660606000600600000000000000000000000000
06006660660066006600000006006660000066600000660066000600606060006600060000000600600000006060000000600600000000000000000000000000
06006060600060606000000006000060000060600000606060600600606060606000000000000600600000006060000000600600000000000000000000000000
06006060666060606660000066606600000060600000666060606660666066606660060000000060060000006600000006006000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600660606000000660666006600660066000006660606066600000666066606660660006606660060000006000060006000000060006000060000000000000
60606060606000006000606060606000600000000600606060000000606060600600606060006000060000000600600060600660606000600600000000000000
66606060606000006000660060606660666000000600666066000000660066000600606060006600060000000600600000006060000000600600000000000000
00606060606000006000606060600060006000000600606060000000606060600600606060606000000000000600600000006060000000600600000000000000
66606600066000000660606066006600660000000600606066600000666060606660666066606660060000000060060000006600000006006000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600660606000006660666066006600000066600000066060606660666060600000066060600660666006000000600006000600000006000600006000000000
60606060606000006000060060606060000060600000600060606060606060600000600060606060606006000000060060006060066060600060060000000000
66606060606000006600060060606060000066600000600060606600660066600000666066606060666006000000060060000000606000000060060000000000
00606060606000006000060060606060000060600000600060606060606000600000006060606060600000000000060060000000606000000060060000000000
66606600066000006000666060606660000060600000066006606060606066600000660060606600600006000000006006000000660000000600600000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000
6060066060600000066006606660000066600000aa00aaa0aaa0aa00aaa0aa00aaa00000aa000aa0000000000000000000000000000000000000000000000000
6060606060600000600060600600000060600000a000a0a0a0a0a0a0a0a0a0a0a0a00000aa0000a0000000000000000000000000000000000000000000000000
6660606060600000600060600600000066600000a000aa00aaa0a0a0aaa0a0a0aaa0000a0a0000a0000000000000000000000000000000000000000000000000
0060606060600000606060600600000060600000a000a0a0a0a0a0a0a0a0a0a0a0a0aaa0a00000a0000000000000000000000000000000000000000000000000
6660660006600000666066000600000060600000aa00aaa0a0a0a0a0a0a0a0a0a0a00aaa00000aa0060000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000
60600660606000006660066060606600660000006660660000008800888088808880800088800088800008800000000000000000000000000000000000000000
60606060606000006000606060606060606000006060606000008000808080808080800080000888880000800000000000000000000000000000000000000000
66606060606000006600606060606060606000006660606000008000888088808880800088000888880000800000000000000000000000000000000000000000
00606060606000006000606060606060606000006060606000008000808080008000800080000888880000800000000000000000000000000000000000000000
66606600066000006000660006606060666000006060606000008800808080008000888088800088800008800600000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600660606000006660666066600000666066000000990009909990999099000990999000990000099000000000000000000000000000000000000000000000
60606060606000006060060060000000606060600000900090909090909090909000900009999000009000000000000000000000000000000000000000000000
66606060606000006660060066000000666060600000900090909900999090909000990009000900009000000000000000000000000000000000000000000000
00606060606000006060060060000000606060600000900090909090909090909090900009000900009000000000000000000000000000000000000000000000
66606600066000006060060066600000606060600000990099009090909090909990999000999000099006000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

