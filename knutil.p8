pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--knutil_0.13.1
--@shiftalow / bitchunk
version='v0.13.1'
function tonorm(s)
if s=='true' then return true
elseif s=='false' then return false
elseif s=='nil' then return nil
end
return tonum(s) or s
end

function tohex(p,n)
p=sub(tostr(tonum(p),1),3,6)
while sub(p,1,1)=='0' do
p=sub(p,2)
end
p=join('',unpack(tbfill(0,1,(n or 0)-#p)))..p
return p
end

function bpack(w,s,b,...)
return b and flr(0x.ffff<<add(w,deli(w,1))&b)<<s|bpack(w,s-w[1],...) or 0
end

function bunpack(b,s,w,...)
if w then
return flr(0x.ffff<<w&b>>>s),bunpack(b,s-(... or 0),...)
end
end

function replace(s,f,r,...)
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
return ... and replace(a,...) or a
end

function toc(v,p)
return flr(v/(p or 8))
end

function join(d,s,...)
return not s and '' or not ... and s or s..d..join(d,...)
end

_split,split=split,function(str,d,...)
local t=_split(str,d or ' ',false)
for i,v in pairs(t) do
if ... then
t[i]=split(v,...)
end
end
return t
end

function htd(b,n)
local a={}
tmap(split(b,n or 2),function(v)
add(a,tonum('0x'..v))
end)
return a
end

function cat(f,...)
foreach({...},function(s)
for k,v in pairs(s) do
if tonum(k) then
add(f,v)
else
f[k]=v
end
end
end)
return f
end

function comb(k,p)
local a={}
for i=1,#k do
a[k[i]]=p[i]
end
return a
end

function tbfill(v,s,e,...)
local t={}
for i=s,e do
t[i]=... and tbfill(v,...) or v
end
return t
end

function rceach(p,f)
p=_rfmt(p)
for y=p.y,p.ey do
for x=p.x,p.ex do
f(x,y,p)
end
end
end

function outline(t,a)
local i,j,k,l=unpack(split(a))
rceach('-1 -1 3 3',function(x,y)
?t,x+i,y+j,l
end)
?t,i,j,k
end

function tmap(t,f)
for i,v in pairs(t) do
v=f(v,i)
if v~=nil then
t[i]=v
end
--t[i]=f(v,i) or v
end
return t
end

function mkpal(f,t)
return comb(htd(f,1),htd(t,1))
end
function ecmkpal(v)
return tmap(v,function(v,i)
i,v=unpack(v)
return tmap(v,function(v)
return mkpal(_ENV[i],v)
end)
end)
end
function ecpalt(p)
for i,v in pairs(p) do
if v==0 then
palt(i,true)
end
end
end

function ttable(p)
return type(p)=='table' and p
end

function inrng(...)
return mid(...)==...
end

function amid(c,a)
return mid(c,a,-a)
end

function htbl(ht,c)
local t,k,rt={}
ht,c=split(ht,'') or ht,c or 1
while ht[c] do
local p=ht[c]
c+=1
if p=='{' or p=='=' then
rt,c=htbl(ht,c)
if p=='=' then
t[k],k=rt[1]
elseif k then
t[k],k=rt
else
add(t,rt)
end
elseif p=='}' or p==';' then
add(t,tonorm(k))
return t,c
elseif p==' ' then
add(t,tonorm(k))
k=nil
elseif p~="\n" then
k=(k or '')..p
end
end
add(t,tonorm(k))
return t
end

_mkrs,_hovk,_mnb=htbl'x y w h ex ey r p'
,htbl'{x y}{x ey}{ex y}{ex ey}'
,htbl'con hov ud rs rf cs cf os of cam'
function _rfmt(p)
local x,y,w,h=unpack(ttable(p) or _split(p,' ',true))
return comb(_mkrs,{x,y,w,h,x+w-1,y+h-1,w/2,p})
end

function exrect(p)
local o=_rfmt(p)
return cat(o,comb(_mnb,{
function(p,y)
if y then
return inrng(p,o.x,o.ex) and inrng(y,o.y,o.ey)
else
return o.con(p.x,p.y) and o.con(p.ex,p.ey)
end
end
,function(r,i)
local h
for i,v in pairs(_hovk) do
h=h or o.con(r[v[1]],r[v[2]])
end
return h or i==nil and r.hov(o,true)
end
,function(p,y,w,h)
return cat(
o,_rfmt((tonum(p) or not p) and {p or o.x,y or o.y,w or o.w,h or o.h} or p
))
end
,function(col,f)
local c=o.cam
f=(f or rect)(o.x-c.x,o.y-c.y,o.ex-c.x,o.ey-c.y,col)
return o
end
,function(col)
return o.rs(col,rectfill)
end
,function(col,f)
(f or circ)(o.x+o.r-o.cam.x,o.y+o.r-o.cam.y,o.w/2,col)
return o
end
,function(col)
return o.cs(col,circfill)
end
,function(col)
return o.rs(col,oval)
end
,function(col)
return o.rs(col,ovalfill)
end
,{x=0,y=0}
}))
end

-->8
--scenes
function scorder(...)
local o={}
return cat(o,comb(split'rate cnt rm nm dur prm',{
function(d,r,c)
local f,t=unpack(ttable(d) or split(d))
r=r or o.dur
return min(c or o.cnt,r)/max(r,1)*(t-f)+f
end
,0,false
,...
}))
end

_scal={}
function mkscenes(keys)
return tmap(ttable(keys) or {keys},function(v)
local o={}
_scal[v]=cat(o,comb(split'ps st rm cl fi cu sh us tra ords nm',{
function(...)
return add(o.ords,scorder(...))
end
,function(...)
o.cl()
return o.ps(...)
end
,function(s)
s=s and o.fi(s) or not s and o.cu()
if s then
del(o.ords,s).rm=true
end
return s
end
,function()
local s={}
while o.ords[1] do
add(s,o.rm())
end
return s
end
,function(key)
for v in all(o.ords) do
if v.nm==key or key==v then 
return v end
end
end
,function(n)
return o.ords[n or 1]
end
,function()
local v=o.cu()
return del(o.ords,v)
end
,function(...)
local p=scorder(...)
o.ords=cat({p},o.ords)
return p
end
,function(n)
local c=o.cu(n)
if c then
local n=c.cnt+1
c.cnt,c.fst,c.lst=n==0x7fff and 1 or n,n==1,inrng(c.dur,1,n)
if c.rm or c.nm and _ENV[c.nm] and _ENV[c.nm](c) or c.lst then
o.rm(c)
end
end
end
,{},v
}))
return o
end)
end

function cmdscenes(b,p,...)
return tmap(split(replace(b,"\t",""),"\n",' '),function(v)
local s,m,f,d=unpack(v)
return _scal[s] and _scal[s][m](f,tonum(d),p or {}) or false
end)
,... and cmdscenes(...)
end

function transition(v)
 v.tra()
end
-->8
--dmp
function dmp(v,q,s)
	if not s then
	 q,s,_dmpx,_dmpy="\f6","\n",0,-1
	end
	local p,t=s
	tmap(ttable(v) or {v},function(str,i)
		t=type(str)
		if ttable(str) then
			q,p=dmp(str,q..s..i.."{",s.." ")..s.."\f6}",s
		else
		 q..=join('',p,i
		 ,comb(split"number string boolean function nil"
		 ,split"\ff#\f6:\ff \fc$\f6:\fc \fe%\f6:\fe \fb*\f6:\fb \f2!\f6:\f2"
			)[t],tostr(str),"\f6 ")
			p=""
		end
	end)
	q..=t and "" or s.."\f2!\f6:\f2nil"
	::dmp::
	if s=="\n" and not btn'5' then
		flip()
		cls()
		?q,_dmpx*4,_dmpy*6
		_dmpx+=_kd'0'-_kd'1'
		_dmpy+=_kd'2'-_kd'3'
		goto dmp
	end
	return q
end

function _kd(d)
return tonum(btn(d))
end

--dbg
function dbg(...)
if ... then
add(_dbgv,{...})
else
tmap(_dbgv,function(t,y)
?join(' ',unpack(ttable(t) or {t})),0,122+(y-#_dbgv)*6,7
end)
_dbgv={}
end
end
dbg()
-->8
--init vars
order_cnt=0
item_index=0
library_cursor
,document_x
,document_y
,isdocument=1,0,0,false
items=split'push unshift clear'
scenes=mkscenes(split'library items stack transition push shift unshift remove')
keycheck=mkscenes{'keycheck'}
local fwidth=6
local fheight=8
rceach('0 0 16 16',function(cx,cy)
	local b=0
	rceach({0,0,fwidth,fheight},function(x,y)
		b|=sget(cx*fwidth+x
							,cy*fheight+y)
							>0 and 1<<x or 0
		if x==fwidth-1 then
			poke(0x5600+cx*8+cy*128+y,b)
			b=0
		end
	end)
end)
poke(0x5600,fwidth,fwidth,fheight,0,0,0x3)
cls()
cmdscenes([[
	keycheck st key_order 0
	stack st stacked 0
	items st draw_items 0
]],items)
function _update60()
	foreach(keycheck,transition)	
end

function key_document(o)
poke(0x5f5c,5,1)
	isdocument=true
	document_x+=tonum(btnp(➡️))-tonum(btnp(⬅️))
	document_y+=tonum(btnp(⬇️))-tonum(btnp(⬆️))
	if btnp(🅾️) or btnp(❎) then
		cmdscenes[[
			keycheck st key_library 0
		]]
	end
end

function key_library(o)
poke(0x5f5c,10,2)
 isdocument=false
	if btnp(⬇️) then
		library_cursor+=1
		document_x,document_y=0,0
	end
	if btnp(⬆️) then
		library_cursor-=1
		document_x,document_y=0,0
	end
	if btnp(🅾️) or btnp(❎) then
		cmdscenes[[
			keycheck st key_document 0
		]]
	end
	library_cursor=(library_cursor-1)%#libman+ 1
end

function draw_library(o)
	local comment,doc,slicem,ln
							='','',16,o.prm.ln
	local fw,fh
						=ln=='en' and 4 or fwidth
						,ln=='en' and 6 or fheight
	cls(3)
	outline('knutil library help','8 8 4 10')
	fillp(0x33cc)
	local top,left,right
							=exrect'4 16 120 44'
								,exrect'4 60 48 56'
								,exrect'52 60 72 56'

	-- title
	clip(unpack(split(left.p)))
	tmap({
		unpack(libman,library_cursor,library_cursor+7)}
			,function(v,i)
		local h,c,j,d=unpack(v)
		if i==1 then
			outline(h,isdocument and '8 65 6 5' or '8 65 5 7')
			comment=
			 ln=='en'
			  and (c or 'no comment...')
			 or j or 'なし'
			doc=replace(d or 'no document...'
									,[[\n]],"\n")
			slice=ln=='en' and 17 or 11
		else
			?h,12,65+(i-1)*fh,11
		end
	end)
	clip()
	left.rs(isdocument and 0x31 or 0x39)

	-- doc
	clip(unpack(split(top.p)))
	print(doc
		,top.x+3-document_x*fw/1,top.y+5-document_y*fh/1,5
	)
	print(doc
		,top.x+3-document_x*fw/1,top.y+4-document_y*fh/1,6
	)
	clip()
	top.rs(isdocument and 0x39 or 0x31)

	-- comment
--	local comment=replace(comment,'゛','\+de゛\+di','゜','\|d゜\|h')
--	local dc={}
--	local ccomment=join('',unpack(tmap(split(comment,'゛'),function(v,i)
--		add(dc,v)
--	end)))
--	local hd={}
--	ccomment=join('',unpack(tmap(split(ccomment,'゜'),function(v,i)
--		add(hd,v)
--	end)))
--	local i,li,ccomment,a=1,'','',0
--	while comment[i] do
--		local c=comment[i]
--		if c=='゛' or c=='゜' then
--			a+=1
--		end
--		li..=c
--		i+=1
--		if #li==slice+a or not comment[i] then
--			local c=comment[i]
--			if c=='゛' or c=='゜' then
--				i+=1
--				li..=c
--			end
--			li=replace(li,'゛','\+de゛\+di','゜','\+de゜\+di')
--			ccomment..=li.."\n"
--			li=""
--			a=0
--		end
--	end
--	dbg(#ccomment)

--	clip(unpack(split(right.p)))
	clip(right.x+3,right.y+2,right.w-(fw==fwidth and 6 or 5),right.h-7)
--	?ccomment,right.x+4,right.y+5,5
--	?ccomment,right.x+4,right.y+4,6

	comment=replace(comment,'゛','\+de゛\+di','゜','\+de゜\+di')
	for i=0,7 do
			print(comment
			,right.x+3-i*fw*slice
			,right.y+5+i*fh
			,5)
			print(comment
			,right.x+3-i*fw*slice
			,right.y+4+i*fh
			,6)
	end
	clip()
	right.rs(0x31)
end

function key_order(o)
	poke(0x5f5c,0,0)
	item_index=mid(item_index,1,#items)
	if btnp(🅾️) then
		({
			function()
				cmdscenes[[
					push ps push_order 60
				]]
				end,
			function()
				cmdscenes[[
					unshift ps unshift_order 60
				]]
			end,
			function()
				cmdscenes[[
					push cl
					unshift cl
					shift cl
					remove cl
					transition cl
				]]
			end,
		})[item_index]()
		
 end
 if btnp(⬆️) then
 	item_index-=1
 end
 if btnp(⬇️) then
 	item_index+=1
 end
end

function draw_items( o )
	outline('knutil scene orders diagram','8 8 1 12')
	outline([[/order\
\ cmd /
]],'0 20 4 9')
	tmap(items,function(v,i)
		?v,4,i*8+28,i==item_index and 11 or 2
	end)

end

function push_order(o)
	if o.fst then
		order_cnt+=1
		o.rect=exrect'-96 96 96 16'
		o.id=order_cnt
		o.cmd='ps'
	end
	
	local x=ceil(o.rate'-96 32')
	o.rect.ud(x).rf(9)
	?'<ps> push order',x+8,o.rect.y+5,4
	
	if o.lst then
		cmdscenes('shift ps shift_order 30',o)
	end
end

function unshift_order(o)
	if o.fst then
		order_cnt+=1
		o.rect=exrect'32 -32 96 8'
		o.id=order_cnt
		o.cmd='us'
	end
	local y=ceil(o.rate({-32,24}))
	o.rect.ud(nil,y)
	.rf(1).rs(13)
	print("<us> unshift order "..o.id
		,o.rect.x+8,o.rect.y+2
	)
	
	if o.lst then
		local s=cmdscenes'transition fi transition_order'[1]
		if s then
			s.prm.res=s.cnt
		end
		cmdscenes('transition us transition_order 200',o)
	end
end

function shift_order(o)
	local len=o.prm.cmd=='ps' and #_scal.transition.ords or 1
	local rc=o.prm.rect

	rc.ud(nil,o.rate('96 '..24+len*8),nil,o.rate'16 8').rf(9).rs(4)
	print("<sh> shift order "..o.prm.id,rc.x+8,rc.y+o.rate'5 2',4)
	
	if o.lst then
		cmdscenes('transition ps transition_order 200',o.prm)
	end
end

function stacked(o)
	local os=_scal.transition.ords
	local len=#os

	fillp(0x6996)
	exrect'32 16 96 128'.rs(2)
	?'scene orders',76,120
	fillp()

--	tmap( slice( os, 2 ),function(v,i)
	tmap({unpack(os,2)},function(v,i)

		local r,p,f,s=v.prm.rect,v.prm.cmd=='ps'
		if p then
			f,s=4,9
		else
			f,s=5,13
		end
			r.rf(f).rs(s)
			print("     stack order "..v.prm.id,r.x+8,r.y+2,s)
	end)
end


function transition_order(o)
	local rc=o.prm.rect
	local recnt=o.cnt-(o.prm.res or 0)
	local y=o.rate({rc.y,16},32,recnt)
	local cmd=o.prm.cmd=='ps' or o.cnt>8
	local f,s
	
	if o.prm.cmd=='ps' then
		f,s=9,10
	else
		f,s=13,12
	end

	rc.ud(nil,y,nil,o.rate({8,16},16,recnt))
		.rf(f).rs(s)
	print("<tra> transition "..o.prm.id.."\n       order "..o.cnt..'/'..o.dur
		,rc.x+8,rc.y+2
	,s)
	
	local os=_scal.transition.ords
	
--	tmap( slice( os, 2 ),function( v, i )
	tmap({unpack(os,2)},function(v,i)
		local r=v.prm.rect
		if r then
			local y=i*8
			r.ud(nil,o.rate(
				cmd and{y+32,y+24}
					or {y+16,y+24}
				,8,recnt))
		end
	end)
	
	if o.lst then
		cmdscenes([[
			remove ps remove_order 120
		]],o.prm)
	end
end

function remove_order(o)
	if o.fst then
		cmdscenes[[
			transition us nil 120
			unshift us nil 120
		]]
	end
	
	local rc=o.prm.rect
	rc.ud(o.cnt+32).rs(8)
	print("<rm> remove order",rc.x+8,rc.y+5)
end


function _draw()
	cls()
	foreach(scenes,transition)
	dbg(version)
	dbg()
end
-->8
--htbl examples
--indexed
local _itbl=htbl[[50 val test]]

--keybalues
local _ktbl=htbl[[count=30;a=b;]]

--multidimensional table
local _mtbl=htbl[[
player{
 name=fighter;level=15;
 inventory{
  sword shild makibishi
 }
 skill{
  {name=parry;class=beginner;}
  {name=parry;class=beginner;}
 }
 lean_magic=false;
 own_home=true;
}
]]
--dmp(_mtbl)

--initialize global variables
cat(_ENV,htbl[[
tokencost{
--tokencost-- [❎-to-exit]
 knutil{
  essential-library
  token=1050;
 }
 scenes{
  scene-manager
  token=365;
 }
 dmp{
  dump-table-values
  token=152;
 }
 dbg{
  value-instant-print
  token=48;
 }
}
]])

menuitem(5,'scene order dg',function()
cmdscenes([[
	keycheck st key_order 0
	stack st stacked 0
	items st draw_items 0
	library cl
]], items)
poke(0x5f58,0)
end)

menuitem(3,'library info',function()
dmp(tokencost)
end)

menuitem(2,'ライフ゛ラリ(jp)',function()
library_init([[ln=jp]])
poke(0x5f58,0x81)
end)
menuitem(1,'library help',function()
library_init([[ln=en]])
poke(0x5f58,0)
end)

function library_init(p)
libman=split([[
bpack	pack the value of the bit specification with bit width.	ふくすうのbitちをしていして ひとつのすうちに つめます。	bpack(w,s,b,...)\n- @param  table  w   -- bit width table for packing.\n- @param  number s   -- bit value to be shifted to the right before the first pack.\n- @param  number b   -- the value to pack.\n- @param  number ... -- bit width to the next pack.\n- @return number     -- packed value.
bunpack	slice the value with bit width.	bitはは゛をしていして ひとつのすうちを ふ゛んかつしてかえします。	bunpack(b,s,w,...) \n- @param  number b   -- the value to slice.\n- @param  number s   -- bit value to right-shift before the first slice.\n- @param  number w   -- bit width to the first slice.\n- @param  number ... -- bit width to the next slices.\n- @return ...        -- sliced value as a tuple.
cat	concatenate tables. indexes are added last and identical keys are overwritten.	テ-フ゛ルのれんけつをします。	cat(f,...)\n- @param  table f   -- add destination table.\n- @param  table ...  -- next table to add.\n- @return table        -- concatenated table.
comb	combines two tables to create a hash table.	キ-のテ-フ゛ルと あたいのテ-フ゛ルから れんそうはいれつテ-フ゛ルを さくせいします。	comb(k,v)\n- @param  table k   -- key string table.\n- @param  table b   -- value tables.\n- @return table     -- table of associative arrays.
dmp	dumps information about a variable.	テ-フ゛ルのないようを ひょうし゛します。	dmp(v)\n- @param  any v   -- value to be displayed, table.
htbl	converting a string to a table(multidimensional array / hash table / jagged arrays)	もし゛れつから テ-フ゛ルを さくせいします。(たし゛ゅうはいれつ たいおう)	htbl(ht)\n- @param  string ht  -- formatted string.\n- @return table      -- generated table.
inrng	tests that the specified value is within a range.	すうちか゛はんい ないて゛あることを はんていします。	inrng(...)\n- @param  number ...  -- test value\n- @param  number ...  -- lowest value\n- @param  number ...  -- highest value\n- @return boolean     -- if it's within the range
join	joins strings with a delimiter.	もし゛れつを れんけつします。	join(d,s,...)\n- @param  string d     -- delimiter\n- @param  string s,... -- string to be joined\n- @return string       -- joined string value
rceach	iterate from rectangle values.	くけいテ゛-タて゛ ル-フ゜をします。	rceach(r,f)\n- @param  string|table r  -- rectangle initialization format.\n- @param  function f      -- function(x, y, r) to execute.\n* in a function\n-- @param x  number       -- x-coordinate\n-- @param y  number       -- y-coordinate\n-- @param r  string|table -- argument rectangle format
replace	perform string substitutions.	もし゛れつを ちかんします。	replace(s,f,r,...)\n- @param  string s    -- target string\n- @param  string f    -- matching string\n- @param  string r    -- string to replace from the matched string\n- @param  string ...  -- next match & replace string\n- @return string      -- replaced string
tmap	more compact operable foreach iterator.	foreachの ついかきのうは゛ん。	tmap(t,f)\n- @param  table t     -- table to scan\n- @param  function f  -- function(v, i) to execute.\n- @return table       -- table of arguments updated in the function.\n* in a function\n-- @param v  any      -- table elements.\n-- @param i  number   -- indexes associated with table elements.\n-- @return   any      -- table element to update the current index.
tbfill	creates a table filled with the specified values.	していした すうちて゛うめたテ-フ゛ルを つくります。	tbfill(v,s,e,...)\n- @param  any    v    -- values that satisfy the table.\n- @param  number s    -- index to start.\n- @param  number e    -- index value to end.\n- @param  number ...  -- indexes to start and end the next level of hierarchy.\n- @return table       -- table filled with values. 
ttable	if the argument is a table, the table is returned.	テ-フ゛ルて゛あれは゛テ-フ゛ルをかえし、そうて゛なけれは゛false をかえします。	ttable(p)\n- @param  any p  -- result of the survey.\n- @return any    -- returns the table, if it is a table, or false otherwise.
tonorm	converts from a string to a type-specific value.	もし゛れつから かたにあわせた あたいにへんかんします。	tonorm(s)\n- @param  string s  -- string to be converted.\n- @return any       -- value converted to the appropriate type.
tohex	converts an integer 10 number to the specified number of hexadecimal digits.	せいすうの10しんすうちを していしたけたすうの 16しんすうに へんかんします。	tohex(p,n)\n- @param  string p  -- decimal integer value to be hexadecimal.\n- @param  number n  -- number of digits to output.\n- @return string    -- converted hexadecimal string (without 0x)
toc	divides by the specified number and outputs an integer value.	していしたすうちて゛わり、せいすうちをかえします。	toc(v,p)\n- @param  number v  -- value.\n- @param  number p  -- divisor.\n- @return number    -- integer value with division and no remainder.
split	wrapper function for split, generating a multilevel hierarchical table by specifying multiple delimiters.	splitのラッハ゜-かんすう、ふくすうのくき゛りもし゛をしていして たし゛ゅうかいそうテ-フ゛ルを せいせいします。	split(str,d,...)\n- @param  string str  -- value.\n- @param  number d    -- delimiter.\n- @param  number ...  -- separator to create further hierarchy.\n- @return table       -- segmented table.
htd	convert a contiguous hexadecimal string into a table.	れんそ゛くした16しんすうもし゛れつを テ-フ゛ルにへんかんします。	htd(b,n)\n- @param  string b  -- consecutive hexadecimal strings (not including 0x).\n- @param  number n  -- number of digits to be split.\n- @return table     -- segmented table.
outline	drawing text, including outlines.	もし゛をアウトラインふくめて ひ゛ょうか゛します。	outline(t,a)\n- @param  string t  -- text to display.\n- @param  string b  -- text display coordinates, color, border color string.
mkpal	create a palette table with consecutive hexadecimal strings.	れんそ゛くした16しんすうもし゛れつて゛ ハ゜レットテ-フ゛ルをさくせいする。	mkpal(f,t)\n- @param  string f  -- color before change, consecutive hexadecimal string.\n- @param  string t  -- changed color, contiguous hexadecimal string.\n- @return table     -- palette table that can be specified directly to pal().
ecmkpal	create a palette from a table. (tied to the theme name)	テ-フ゛ルからハ゜レットを さくせいします。	ecmkpal(v)\n- @param  table v  -- color conversion format table.\n- @return table    -- color palette table tagged with.
ecpalt	transparency setting from the color table.	カラ-テ-フ゛ルから とうめいせっていをします。	ecpalt(p)\n- @param  table p  -- table of colors to be transparent.
amid	mid with positive and negative of the specified number.	していしたすうちの「せい」と「ふ」て゛midを おこないます。	amid(c,a)\n- @param  number c  -- number to be tested.\n- @param  number a  -- upper and lower limit values.\n- @return number    -- result of mid().
exrect	generate rect object with extended functionality.	きのうかくちょうしたrectオフ゛シ゛▤クトを せいせいします。	exrect(p)\n- @param  string|table p -- 'x y w h' {x,y,w,h} rectangle data. this argument is retained.\n- @return rect-object    -- rectangular objects that can be drawn and judged.
mkscenes	create a multitasking scene object.	マルチタスクの シ-ンオフ゛シ゛▤クトを さくせいします。	mkscenes( keys )\n- @param  table keys  -- scene name table.\n- @return table       -- scene object table for scanning.
dbg	outputs values to the screen regardless of output timing.	しゅつりょくタイミンク゛かんけいなして゛ あたいを か゛めんしゅつりょくします。	dbg(...)\n- @param  any ...  -- value to be examined (other than table)
]],"\n","\t")
--dmp(v)
cmdscenes([[
	library st draw_library 0
	keycheck st key_library 0
	items cl
	stack cl
	transition cl
	push cl
	shift cl
	unshift cl
	remove cl
]],htbl(p))

end

-->8
--[[
update history
**v0.13.1**
-corrected commented out vdmp to dmp.

**v0.13**
-scene:
--cmdscenes:supports indentation description by tabs.

**v0.12**
-library help added to pause menu
-bmch: unlisted
-exrect: fix variable and function names
-scene:
--rate: adjustment of decimal point overflow countermeasures
--cmdscenes: continuous call handling
--added functions for iterators
-dbg: simplification by join
-*join for long data*-
--function join(d,s,...)
--local a={...}
--while a[1] do
--s..=d..deli(a,1)
--end
--return s or ''
--end


**v0.11**
-htd: fixed table values to local variables
-bpack: specification change from ttoh()
-bunpack: specification change from htot()
-slice: the function was removed because there is a {unpack()} with a similar function.
-old code
--function ttoh(h,l,b)
--return bor(shl(tonum(h),b),tonum(l))
--end
--function htot(v)
--return {lshr(band(v,0xff00),8),band(v,0xff)}
--end
--function slice(r,f,t)
--local v={}
--for i=f,t or #r do
--add(v,r[i])
--end
--return v
--end

**v0.10**
-split: supports multi-dimensional arrays
-cmdscenes: fixed for split update
-sceneorder: update for use of tuples
-dmp: apply p8scii font color

**v0.9**
-tbfill: changed to specify indexes at the beginning and end of tables, support for variable length arguments.
-tohex: fixed for update of tbfill()
 
**v0.8**
-join: use of tuples
-tbfill: defaults to 1 or specifies the start of the table
-tohex: fixed for update of join()

**v0.7**
-sceneorder:"rate" func countermeasures against overflow of digits
-code update saved token: 
 -htbl: 7 tokens
 -tonorm: 9 tokens

**v0.6**
-simplified handling of scene orders
-rceach: name change from ecxy()
-inrng: using tupple twice
-exrect.con: name change from exrect.cont()
-exrect.hov: name change from exrect.hover()
-scenes: order.rate is calculated enough value in the last count
 -cmdscenes change name from scenesbat

**v0.5**
-mainly due to sub()'s cpu cost countermeasure.
-replace: fix usage of sub()
-htd: convert from split()
-htbl: run newlines without replace()
-scene: save cost with split()&comb() at initialization
-dbg: change to display values without dbg() argument
-example: add htbl() example use

]]--
    
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770000000000000000000000000007070000070007000007770000000007070000000000000000000070700077000000000000000000000000000000000000
07770007770007770007070007070007070000770007700007000000000007770000000000000000000070700077000000000000000000000000000000000000
07770007770007070000700000000007070007770007770007000000070000700007700000000000000000000000000000000000000000000000000000000000
07770007770007770007070007070007070000770007700000000000070007770007700077000077000000000000000000000000000000000000000000000000
07770000000000000000000000000007070000070007000000000007770000700000000000700077000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700007070007070007770007070077000000700000700007000007070000000000000000000000000000070000000000000000000000000000000000
00000000700007070077770007700000070070700000700007000000700000700000700000000000000000000000700000000000000000000000000000000000
00000000700000000007070000770000700007770000000007000000700007770007770000000007770000000000700000000000000000000000000000000000
00000000000000000077770007770007000070700000000007000000700000700000700000700000000000000000700000000000000000000000000000000000
00000000700000000007070000700007070077770000000000700007000007070000000007000000000000700007000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77770007700077770077770070700077770077770077770077770077770000000000000000070000000007000007770000770000000000000000000000000000
70070000700000070000070070700070000070000070070070070070070000700000700000700077770000700000070000770000000000000000000000000000
70070000700077770077770070700077770077770000070077770077770000000000000007000000000000070000770000000000000000000000000000000000
70070000700070000000070077770000070070070000070070070000070000700000700000700077770000700000000000000000000000000000000000000000
77770007770077770077770000700077770077770000070077770077770000000007700000070000000007000000700000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770000000077000000000000007000000007777000000077000007700000770077000007700000000000000000000000000700000000000000000000000000
70707077770077000007777000007007777007700077770077000000000000000077000007700077077007770007770000007000000000000000000000000000
70707000777077770077000007777070077077777077007077770007700000770077777007700077777077007077007000007000000000000000000000000000
70070077007077007077000077007077700007700000777077007007700000770077700007700070707077007077007000007000000000000000000000000000
07777077777077777007777077777077777007700077777077007007700077770077077007770070007077007007770000070000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000007700000000000000000000000000000000000000007700007000007700000700000000000077700000000000000000000000000
07777077770077077007777077777077007077007070007077007077007077777007000000700000700007070000000000000700000000000000000000000000
77007077007077700077700007700077007077007070707077007077777000077007000000700000700000000000000000007700000000000000000000000000
77777077777077000000077007700077007077070077777007770000007077700007000000700000700000000000000000000000000000000000000000000000
77000000007077000077777007777077777007700077077077007077770077777007700000070007700000000007770000007000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700007770007770007777077770007777007777007777077007077770007777077077077000070007077007007770000000000000000000000000000000000
00070077007077007077000077007077000077000077000077007007700000770077070077000077077077707077007000077700000000000000000000000000
00000077007077770077000077007077770077770077077077777007700000770077700077000077707077777077007070770070000000000000000000000000
00000077777077007077000077007077000077000077007077007007700070770077070077000077007077077077007070770070000000000000000000000000
00000077007077777007777077770077777077000077777077007077770007700077077077777077007077007007770070077700000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770007770007770007777077777077007077007070007077007077007077777000770000700007700000000000000000000000000000000000000000000000
77007077007077007077000000770077007077007070007077007077007000007000700000700000700000070000700000000000000000000000000000000000
77007077007077007077777000770077007077007070707000770007770007770007700000700000770007770007070000000000000000000000000000000000
77770077070077770000007000770077007077070077777077007000700077000000700000700000700007000000700000000000000000000000000000000000
77000007707077007077770000770077770007700077077077007000700077777000770000700007700000000000000000077700000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77770070707070007007770070007007000007770077077007770007770000700007770077777000777007770000700070077700000000000000000000000000
77777007070077077077777000700007777077707077777077077007770007770077077070707000700077077007770070770070000000000000000000000000
77777070707077777070707070007007770077777077777077077077777077777070777077777000700070707077777070770070000000000000000000000000
77777007070070707077077000700077770077777007770077077007770007070077077070007077700077077007770070770070000000000000000000000000
77777070707007770007770070007000070007770000700007770007070007770007770077777077700007770000700070077700000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007070000070007700007700007707007077000000000000000000000000000000000
77700000000007000007000077070000000000000007000000000000700077700000007000777000770077007007700000007000000000000000000000000000
07070070070077700077700007000077770000770077770007770077770007070070007007007077070007770077070000070700000000000000000000000000
77700070070000070007000070770000770077700070070000700007700070777070000000007000770070707007070000007000000000000000000000000000
77070007000007700070770077070007000000700000700077770070700077707007000000070007077077007007000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707000700000070000770007070070000007707007077070700007700007077000770000077070070077077000070000007000000000000000000000000000
00077007000070077007000007700007000000770007770007770077007007700007007000770070700070700070700070077700000000000000000000000000
07770007000070707000000070070007007077707077070077700007070070777070007077070007000070770070000070777770000000000000000000000000
00000000700070007000007000000007007000777007000000700007000000007000007000070007007007077070077070077700000000000000000000000000
00777000070007007007770007770000770000007000777000077007077000770000070000007007770007700007000000007000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70770070077007770000777000077077000000000000770077070000070007070000700007700070070070777070700070070770000000000000000000000000
70707070707077007070070000070000077007770070077007707077077077007070777077000007777007707077007070077000000000000000000000000000
07077007077070707070707077007000700070007070770070770007707007007077707007707007007070707007770000770700000000000000000000000000
77077077077070700070770007007070070070000070077007077070707077770070707077007070700070770070700070070700000000000000000000000000
77000007000007700007000000770070770070000007077007770077000077000077000000770000070000700077000070070000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770000070000770007070000770070770007770070000000000000000000000000000077770000007000700000007070000700000000000000000000000000
70000070007077077077770077077077007077707070770000000070700070770070700000007000007077770077770000707000000000000000000000000000
70777077007000777007070000777007007000770077070007770007770007707007000000707077770070007000700000700000000000000000000000000000
07007000007007707077077000007077007007070070077070070077070070770070770000770000070000007000700070700770000000000000000000000000
00070000070000770007000000770007000007777070000000700007000070700077000007700000070007770077777000070000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070007000000700000770007007077770007007077000077770007077070007007770007777070707007777007000070707000000000000000000000000000
77777077770077777007007007777000007077777000007000007007707007007070007000070070707000000007000070770070000000000000000000000000
00070007007000070070007070070000007007007077007000070077000007007077777077777070707077777007770070077700000000000000000000000000
00770007007007777000070000070000007000007000007000770007000000070070007000070000007000070007007000707000000000000000000000000000
77070070077000070007700007700077777000770077770077007000777007700000070007700007770007700007000000770000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000077770000700000007000070070007077770007700000707077770007777007000000007007770007000000000070000000000000000000000000
77777007777000007077770000007007007077770000007070070077770000007000000007000007007077000077770000777700000000000000000000000000
00070000000007007000007000007070007070000000007070070000700000077007777070007000707007770007007070007000000000000000000000000000
00070000000000770007770000070070007070000000070000007070707007700000000070077000070077000007077070007000000000000000000000000000
07700077777077007070707077700070007007777000700000007070707000770077770077707077707000777007000000777770000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700077770077770070007000700070000077770077770077770077000000000000000000000000000007700000770070070000000000000000000000000000
00070000007000000070007070700070000070007070007000007000007000000000000000000000000070000000007000070000000000000000000000000000
00070007777077777070007070700070007070007000007007777000007070707070770077700077700070000000007070077700000000000000000000000000
00070000007000007000007070700070070070007000007000007000007000007077070000700007770000000000000000070070000000000000000000000000
77777077770000770000770070077007700007770000770000770077770007770007000077770077700000000000000000070000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000ccccccccccccccccccccccc000000cccccccccccccccccccc0000cccccccccccccccccccccccc000ccccccccccccccccccccccccccccc000000000000
0000000c1c1c11cc1c1c111c111c1c00000cc11cc11c111c11cc111c000cc11c111c11cc111c111cc11c000c11cc111c111cc11c111c111c111c000000000000
0000000c1c1c1c1c1c1cc1ccc1cc1c00000c1ccc1ccc1ccc1c1c1ccc000c1c1c1c1c1c1c1ccc1c1c1ccc000c1c1cc1cc1c1c1ccc1c1c1c1c111c000000000000
0000000c11cc1c1c1c1cc1c0c1cc1c00000c111c1c0c11cc1c1c11c0000c1c1c11cc1c1c11cc11cc111c000c1c1cc1cc111c1ccc11cc111c1c1c000000000000
0000000c1c1c1c1c1c1cc1ccc1cc1ccc000ccc1c1ccc1ccc1c1c1ccc000c1c1c1c1c1c1c1ccc1c1ccc1c000c1c1cc1cc1c1c1c1c1c1c1c1c1c1c000000000000
0000000c1c1c1c1cc11cc1cc111c111c000c11ccc11c111c1c1c111c000c11cc1c1c111c111c1c1c11cc000c111c111c1c1c111c1c1c1c1c1c1c000000000000
0000000ccccccccccccccccccccccccc000cccc0cccccccccccccccc000cccccccccccccccccccccccc0000ccccccccccccccccccccccccccccc000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
00000000000000000000000000000000cdddddddddcdcccdcccdcccdcdddddddcccdcccdcccdccdddccdcccdcccdcccddccdccddddddcccddddddddddddddddc
09999999999999999999999999000000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdcddddcdddcdddcddcdcdcdcdddddddcddddddddddddddddc
99499449444944994449444949900000cdddddddcddddcddccddcccdddcddddddcddccddcccdcdcdcccddcdddcdddcddcdcdcdcddddddccddddddddddddddddc
94994949494949494999494994900000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdddcddcdddcdddcddcdcdcdcdddddddcddddddddddddddddc
94994949449949494499449994900000cdddddddddcddcddcdcdcdcdcddddddddcddcdcdcdcdcdcdccddcccddcddcccdccddcdcdddddcccddddddddddddddddc
94994949494949494999494994990000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
49994499494944494449494999490000cddddddddddddddddddddddddddddddddddddccdcccdccddcccdcccdddddcdddcdcdddcdcccdcccdcccddddddddddddc
99099999999999999999999909990000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcdddddcdddcdcddcddddcdcdcdcdcddddddddddddc
49900009944944494499000099490000cdddddddddddddddddddddddddddddddddddcdcdccddcdcdccddccddddddcccdcccddcddcccdcdcdcdcddddddddddddc
94900009499944494949000094990000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcdddddcdcdddcddcddcdddcdcdcdcddddddddddddc
94900009490949494949000094900000cdddddddddddddddddddddddddddddddddddccddcdcdcccdcccdcdcdddddcccdddcdcdddcccdcccdcccddddddddddddc
94990009499949494949000994900000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
99490009944949494449000949900000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
09990000999999999999000999000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
00000000000000000000000000000000944444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444449
00000000000000000000000000000000944444444444444444444444444449949994999449949494444449949994994499949994444499444444444444444449
00000000000000000000000000000000944444444444444444444444444494444944949494449494444494949494949494449494444449444444444444444449
00002220202002202020000000000000944444444444444444444444444499944944999494449944444494949944949499449944444449444444444444444449
00002020202020002020000000000000944444444444444444444444444444944944949494449494444494949494949494449494444449444444444444444449
00002220202022202220000000000000944444444444444444444444444499444944949449949494444499449494999499949494444499944444444444444449
00002000202000202020000000000000944444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444449
00002000022022002020000000000000999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
00000000000000000000000000000000944444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444449
00000000000000000000000000000000944444444444444444444444444449949994999449949494444449949994994499949994444499944444444444444449
00000000000000000000000000000000944444444444444444444444444494444944949494449494444494949494949494449494444444944444444444444449
0000b0b0bb000bb0b0b0bbb0bbb0bbb0944444444444444444444444444499944944999494449944444494949944949499449944444499944444444444444449
0000b0b0b0b0b000b0b00b00b0000b00944444444444444444444444444444944944949494449494444494949494949494449494444494444444444444444449
0000b0b0b0b0bbb0bbb00b00bb000b00944444444444444444444444444499444944949449949494444499449494999499949494444499944444444444444449
0000b0b0b0b000b0b0b00b00b0000b00999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
00000bb0b0b0bb00b0b0bbb0b0000b00200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000220200022202220222000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00002000200020002020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002000200022002220220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002000200020002020202000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000220222022202020202000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
00000000000000000000000000000000499999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994
00000000000000000000000000000000499999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994
00000000000000000000000000000000499999999949944949494999999994494949444944494449999994494449449944494449999949499999999999999994
00000000000000000000000000000000499999999499499949499499999949994949949949999499999949494949494949994949999949499999999999999994
00000000000000000000000000000000499999994999444944499949999944494449949944999499999949494499494944994499999944499999999999999994
00000000000000000000000000000000499999999499994949499499999999494949949949999499999949494949494949994949999999499999999999999994
00000000000000000000000000000000499999999949449949494999999944994949444949999499999944994949444944494949999999499999999999999994
00000000000000000000000000000000499999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994
00000000000000000000000000000000444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
00000000000000000000000000000000200000000000000000000000000000000000000000000220022022202200222000000220222022002220222002200002
00000000000000000000000000000000000000000000000000000000000000000000000000002000200020002020200000002020202020202000202020000000
70707770000077007770000000000000000000000000000000000000000000000000000000002220200022002020220000002020220020202200220022200000
70707070000007000070000000000000200000000000000000000000000000000000000000000020200020002020200000002020202020202000202000200002
70707070000007000770000000000000200000000000000000000000000000000000000000002200022022202020222000002200202022202220202022000002
77707070000007000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007770070077707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002

