pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--tmap [tmap() concatenates two or more tables]
--v0.1
--@shiftalow / bitchunk
function tmap(t,f)
for i,v in pairs(t) do
t[i]=f(v,i) or t[i]
end
return t
end

--------------------------------
-- execute the function of
-- the second argument
-- for each element of 
-- the table, as in foreach().
--------------------------------

cls()
?'-------------'
?'--your food--'
?'-------------'
local t={
	'toast'
	,'letus'
	,'bacon'
	,'cheese'
}
t=tmap(t, function(v,i)
 ?i..'..'..v
end)
-- the first argument is
--  the table,
--
-- the second argument specifies
--  the function to be
--  applied to each 
--  table element.
--
-- the return value is
--  the table of arguments.

?'----------------'
?'--enhance food--'
?'----------------'
t=tmap(t, function(v,i)
 v='super★'..v
 ?i..'..'..v
 return v
end)
-- array elements can be
--  updated by specifying
--  the return value
--  in the function.

?'------------------'
?'--change weapons--'
?'------------------'
t=tmap({
	'shield'
	,'armor'
	,'sword'
	,'ring'
}, function(v,i)
 v=t[i]..'•'..v
 ?i..'..'..v
 return v
end)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000606006606060666000006660066006606600000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000606060606060606000006000606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666060606060660000006600606060606060666066600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006060606060606000006000606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666066000660606000006000660066006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666066606660666066606660666066606660666066600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000066600660666006606660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000000000006006060606060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000000000006006060666066600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000000000006006060606000600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600600060006006600606066000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000060006660666060600660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000060006000060060606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000060006600060060606660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000000000060006000060060600060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600600060066606660060006606600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000066606660066006606600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000060606060600060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06600000000066006660600060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000060606060600060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600600060066606060066066006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000000006606060666066600660666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000000060006060600060006000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000060006660660066006660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000060006060600060000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600060006606060666066606600666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666066606660666066606660666066606660666066606660666066600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666066006060666066000660666000006660066006606600000000000000000000000000000000000000000000000000000000000000000000000000
00000000600060606060606060606000600000006000606060606060000000000000000000000000000000000000000000000000000000000000000000000000
66606660660060606660666060606000660000006600606060606060666066600000000000000000000000000000000000000000000000000000000000000000
00000000600060606060606060606000600000006000606060606060000000000000000000000000000000000000000000000000000000000000000000000000
00000000666060606060606060600660666000006000660066006660000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666066606660666066606660666066606660666066606660666066600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000006606060666066606660000600006660066066600660666000000000000000000000000000000000000000000000000000000000000000000000
06000000000060006060606060006060006660000600606060606000060000000000000000000000000000000000000000000000000000000000000000000000
06000000000066606060666066006600666666600600606066606660060000000000000000000000000000000000000000000000000000000000000000000000
06000000000000606060600060006060066666000600606060600060060000000000000000000000000000000000000000000000000000000000000000000000
66600600060066000660600066606060060006000600660060606600060000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000006606060666066606660000600006000666066606060066000000000000000000000000000000000000000000000000000000000000000000000
00600000000060006060606060006060006660006000600006006060600000000000000000000000000000000000000000000000000000000000000000000000
66600000000066606060666066006600666666606000660006006060666000000000000000000000000000000000000000000000000000000000000000000000
60000000000000606060600060006060066666006000600006006060006000000000000000000000000000000000000000000000000000000000000000000000
66600600060066000660600066606060060006006660666006000660660000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000006606060666066606660000600006660666006600660660000000000000000000000000000000000000000000000000000000000000000000000
00600000000060006060606060006060006660006060606060006060606000000000000000000000000000000000000000000000000000000000000000000000
06600000000066606060666066006600666666606600666060006060606000000000000000000000000000000000000000000000000000000000000000000000
00600000000000606060600060006060066666006060606060006060606000000000000000000000000000000000000000000000000000000000000000000000
66600600060066000660600066606060060006006660606006606600606000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000000006606060666066606660000600000660606066606660066066600000000000000000000000000000000000000000000000000000000000000000
60600000000060006060606060006060006660006000606060006000600060000000000000000000000000000000000000000000000000000000000000000000
66600000000066606060666066006600666666606000666066006600666066000000000000000000000000000000000000000000000000000000000000000000
00600000000000606060600060006060066666006000606060006000006060000000000000000000000000000000000000000000000000000000000000000000
00600600060066000660600066606060060006000660606066606660660066600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666066606660666066606660666066606660666066606660666066606660666000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066060606660660006606660000060606660666066600660660006600000000000000000000000000000000000000000000000000000000000000000
00000000600060606060606060006000000060606000606060606060606060000000000000000000000000000000000000000000000000000000000000000000
66606660600066606660606060006600000060606600666066606060606066606660666000000000000000000000000000000000000000000000000000000000
00000000600060606060606060606000000066606000606060006060606000600000000000000000000000000000000000000000000000000000000000000000
00000000066060606060606066606660000066606660606060006600606066000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660666066606660666066606660666066606660666066606660666066606660666000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000006606060666066606660000600006660066066600660666000000660606066606660600066000000000000000000000000000000000000000000
06000000000060006060606060006060006660000600606060606000060000006000606006006000600060600000000000000000000000000000000000000000
06000000000066606060666066006600666666600600606066606660060006006660666006006600600060600000000000000000000000000000000000000000
06000000000000606060600060006060066666000600606060600060060000000060606006006000600060600000000000000000000000000000000000000000
66600600060066000660600066606060060006000600660060606600060000006600606066606660666066600000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000006606060666066606660000600006000666066606060066000006660666066600660666000000000000000000000000000000000000000000000
00600000000060006060606060006060006660006000600006006060600000006060606066606060606000000000000000000000000000000000000000000000
66600000000066606060666066006600666666606000660006006060666006006660660060606060660000000000000000000000000000000000000000000000
60000000000000606060600060006060066666006000600006006060006000006060606060606060606000000000000000000000000000000000000000000000
66600600060066000660600066606060060006006660666006000660660000006060606060606600606000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000000006606060666066606660000600006660666006600660660000000660606006606660660000000000000000000000000000000000000000000000
00600000000060006060606060006060006660006060606060006060606000006000606060606060606000000000000000000000000000000000000000000000
06600000000066606060666066006600666666606600666060006060606006006660606060606600606000000000000000000000000000000000000000000000
00600000000000606060600060006060066666006060606060006060606000000060666060606060606000000000000000000000000000000000000000000000
66600600060066000660600066606060060006006660606006606600606000006600666066006060666000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000000006606060666066606660000600000660606066606660066066600000666066606600066000000000000000000000000000000000000000000000
60600000000060006060606060006060006660006000606060006000600060000000606006006060600000000000000000000000000000000000000000000000
66600000000066606060666066006600666666606000666066006600666066000600660006006060600000000000000000000000000000000000000000000000
00600000000000606060600060006060066666006000606060006000006060000000606006006060606000000000000000000000000000000000000000000000
00600600060066000660600066606060060006000660606066606660660066600000606066606060666000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
