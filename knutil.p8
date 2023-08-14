pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--knutil_0.14.0
--@shiftalow / bitchunk
version='v0.14.0'
--set1:basic
function amid(...)
	return mid(-...,...)
end

function bpack(w,s,b,...)
return b and flr(0x.ffff<<add(w,deli(w,1))&b)<<s|bpack(w,s-w[1],...) or 0
end

function bunpack(b,s,w,...)
if w then
return flr(0x.ffff<<w&b>>>s),bunpack(b,s-(... or 0),...)
end
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

function comb(k,v)
local a={}
for i=1,#k do
a[k[i]]=v[i]
end
return a
end

function ecpalt(p)
	palt()
	tmap(p,function(v,i)
		palt(i,v==0)
	end)
end

function htd(b,n)
	local a={}
	foreach(msplit(b,n or 2),function(v)
		add(a,tonum('0x'..v))
	end)
	return a
end

function htbl(ht,c)
local t,k,rt={}
ht,c=split(ht,'') or ht,c or 1
while 1 do
local p=ht[c]
c+=1
if p=='{' or p=='=' then
rt,c=htbl(ht,c)
if not k then
add(t,rt)
else
t[k],k=p=='{' and rt or rt[1]
end
elseif not p or p=='}' or p==';' or p==' ' then
if k=='false' then k=false
elseif k=='nil' then k=nil
else k=k=='true' or tonum(k) or k
end
add(t,k)
rt,k=p and c or nil
if p~=' ' then
break
end
elseif p~="\n" then
k=(k or '')..p
end
end
return t,rt
end

function inrng(...)
return mid(...)==...
end

function join(d,s,...)
return not s and '' or not ... and s or s..d..join(d,...)
end

function mkpal(p,s,...)
	if s then
		return comb(htd(p,1) or p,htd(s,1) or s),mkpal(p,...)
	end
end

function msplit(s,d,...)
	local t=split(s,d or ' ',false)
	if ... then
		for i,v in pairs(t) do
			t[i]=msplit(v,...)
		end
	end
	return t
end

function oprint(s,x,y,f,o,p)
 for v in all(split(p or '\+ff,\+gf,\+hf,\+fg,\+hg,\+fh,\+gh,\+hh,')) do
  ?v..s,x,y,v~='' and o or f
 end
end

function rceach(p,f)
p=_rfmt(p)
for y=p.y,p.ey do
for x=p.x,p.ex do
f(x,y,p)
end
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

function tbfill(v,s,e,...)
local t={}
for i=s,e do
t[i]=... and tbfill(v,...) or v
end
return t
end

function tmap(t,f)
for i,v in pairs(t) do
v=f(v,i)
if v~=nil then
t[i]=v
end
end
return t
end

function tohex(v,d)
v=sub(tostr(tonum(v),1),3,6)
while v[1]=='0' and #v>(d or 0) do
v=sub(v,2)
end
return v
end

function ttable(p)
return count(p) and p
end
-->8
--set2:objects
--exrect
_mkrs,_hovk,_mnb=htbl'x y w h ex ey r p'
,htbl'{x y}{x ey}{ex y}{ex ey}'
,htbl'con hov ud rs rf cs cf os of cam'
function _rfmt(p)
local x,y,w,h=unpack(ttable(p) or split(p,' ',true))
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

--scenes
_odkey=msplit'_rate _cnt _rm _fst _lst _nm _dur _prm'
function scorder(...)
local o={}
return cat(o,comb(_odkey,{
function(d,r,c)
local f,t=unpack(ttable(d) or msplit(d))
r=r or _dur
return min(c or _cnt,r)/max(r,1)*(t-f)+f
end
,0,false,true,false
,...
}))
end

_scal={}
function mkscenes(keys)
return tmap(ttable(keys) or {keys},function(v)
local o={}
_scal[v]=cat(o,comb(msplit'ps st rm cl fi cu us env tra ords nm',{
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
del(o.ords,s)._rm=true
end
return s
end
,function()
local s={}
while add(s,o.rm()) do
end
return s
end
,function(key)
for v in all(o.ords) do
if v._nm==key or _nm==key or key==v then
return v end
end
end
,function(n)
return o.ords[n or 1]
end
,function(...)
return add(o.ords,scorder(...),1)
end
,function(c)
foreach(_odkey,function(v)
_ENV[v],c[v]=c[v],_ENV[v]
end)
return c
end
,function(n)
local c=o.cu(n)
if c then
o.env(c)
_cnt+=1
_cnt,_fst,_lst=_cnt==0x7fff and 1 or _cnt,_cnt==1,inrng(_dur,1,_cnt)
if _rm or _nm and _ENV[_nm] and _ENV[_nm](c) or _lst then
o.rm(o.env(c))
else
o.env(c)
end
end
end
,{},v
}))
return o
end)
end

function scmd(b,p,...)
return tmap(msplit(replace(b,"\t",""),"\n",' '),function(v)
local s,m,f,d=unpack(v)
return _scal[s] and _scal[s][m](f,tonum(d),p or {}) or false
end)
,... and scmd(...)
end
cmdscenes=scmd

function transition(v)
 v.tra()
end
-->8
--set3:debugging
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
		 ,comb(msplit"number string boolean function nil"
		 ,msplit"\ff#\f6:\ff \fc$\f6:\fc \fe%\f6:\fe \fb*\f6:\fb \f2!\f6:\f2"
			)[t],tostr(str),"\f6 ")
			p=""
		end
	end)
	q..=t and "" or s.."\f2!\f6:\f2nil"
	::dmp::
	_update_buttons()
	if s=="\n" and not btnp'5' then
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
	local p,d={},{...}
	for i=1,#d do
		if add(p,tostr(d[i]))=='d?' then
			tmap(_dbgv,function(v,i)
				oprint(join(' ',unpack(v)),0,128-i*6,5,7)
			end)
			_dbgv,p={}
		end
	end
	add(_dbgv,p,1)
end
dbg'd?'
-->8
--init vars
function _init()
	order_cnt=0
	item_index=0
	isparallel=false
	library_cursor
	,document_x
	,document_y
	,isdocument=1,0,0,false
	items=msplit'push unshift parallel clear'
	scenes=mkscenes(msplit'library items push shift unshift stack transition remove')
	mkscenes('task')
	updates=mkscenes(msplit'keycheck')
	cls()
	scmd([[
		keycheck st key_order 0
		stack st stacked 0
		items st draw_items 0
	]],items)
end


function key_order(o)
	poke(0x5f5c,0,0)
	item_index=mid(item_index,1,#items)
--	dbg(cnt)
	if btnp(🅾️) then
		({
			function()
				scmd[[
					push ps push_order 40
				]]
				end,
			function()
				scmd[[
					unshift ps unshift_order 40
				]]
			end,
			function()
				isparallel=not isparallel
			end,
			function()
				scmd[[
					push cl
					unshift cl
					shift cl
					remove cl
					transition cl
					task cl
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
	oprint('knutil scene orders diagram',8,8,1,12)
	oprint([[/order\]],0,20,4,9)
	oprint([[\ cmd /]],0,26,4,9)
	tmap(items,function(v,i)
		if isparallel then
			?v,0,i*8+28,i==item_index and 12 or 1
		else
			?v,0,i*8+28,i==item_index and 11 or 3
		end
	end)
end

function push_order(o)
	if _fst then
		order_cnt+=1
		_prm.r=exrect'32 128 96 16'
		_prm.id=order_cnt
		_prm.cmd='ps'
		_prm.num=max(#_scal.task.ords-1,0)
		_prm.len=_prm.cmd=='ps' and #_scal.transition.ords or 1
	end
	local h=isparallel and 16 or 8
	local y=ceil(_rate('128 '..24+_prm.len*h+_prm.num*h))

	_prm.r.ud(nil,y
		,nil,_rate({16,8})
	).rf(9)
	?'<ps> push order',_prm.r.x+8,_prm.r.y+_rate'5 1',4

	if _lst then
		scmd('transition ps transition_order 200',_prm)
	end
end

function unshift_order(o)
	if _fst then
		order_cnt+=1
		_prm.r=exrect'32 -32 96 8'
		_prm.id=order_cnt
		_prm.cmd='us'
	end
	local y=ceil(_rate({-32,24}))
	_prm.r.ud(nil,y)
	.rf(1).rs(13)
	print("<us> unshift order ".._prm.id
		,_prm.r.x+8,_prm.r.y+2
	)
	if _lst then
		local s=scmd'transition fi transition_order'[1]
		if s then
			s._prm.res=s._cnt
		end
		scmd('transition us transition_order 200',_prm)
	end
end

function stacked(o)
	local os=_scal.transition.ords
	local len=#os

	fillp(0x6996)
	exrect'32 16 96 128'.rs(2)
	?'scene orders',76,120
	fillp()

--	dbg(os and unpack(os,2))
	if isparallel then
	else
		tmap({unpack(os,2)},function(v,i)
			local prm=v._prm or _prm
			local r,p,f,s=prm.r,prm.cmd=='ps'
			if p then
				f,s=4,9
			else
				f,s=5,13
			end
				r.rf(f).rs(s)
				print("     stack order "..prm.id,r.x+8,r.y+2,s)
		end)
	end
end

function transition_order(o)
	local cmd=_prm.cmd=='ps'
	local recnt=_cnt-(_prm.res or 0)

	if _dur-_cnt>8 then
		local os=_scal.transition.ords
	
		local h=isparallel and 16 or 8
		local os=_scal.transition.ords
		local ro=_scal.remove.ords
		
		tmap(os,function(v,i)
			local py=cmd and (i+#ro)*16 or (i)*16
			_prm.y=v==o and py or _prm.y
		end)

		tmap({unpack(os,2)},function(v,i)
			local r=v._prm and v._prm.r or _prm.r
			if r then
				local y=isparallel and i*h or i*h
				r.ud(nil,_rate(
	--				cmd and{y+32,y+24}
	--					or {y+16,y+24}
					cmd and{y+32,y+32-h}
						or {y+16,y+32-h}
					,8,recnt)
				,nil,h)
			end
		end)
	end

	local rc=_prm.r
	local y=_rate({rc.y,_prm.y or 16},32,recnt)
	local h=_rate({8,16},16,recnt)
	local f,s
	
	if cmd then
		f,s=9,10
	else
		f,s=13,12
	end
	
	rc.ud(nil,y,nil,h)
		.rf(f).rs(s)
	print("<tra> transition ".._prm.id.."\n       order ".._cnt..'/'.._dur
		,rc.x+8,rc.y+2
	,s)
	if _lst then
		scmd([[
			remove ps remove_order 120
		]],_prm)
	end
end

function remove_order(o)
	if _fst then
		if not isparallel then
			scmd[[
				transition us nil 120
				unshift us nil 120
			]]
		end
	end
	
	local rc=_prm.r
	rc.ud(_cnt+32).rs(8)
	print("<rm> remove order",rc.x+8,rc.y+5)
end

function _update60()
	poke(0x5f2d,1)
	if stat(31)=='る' then
		printh(replace(
			chr(peek(0x5600,0x800))
			,unpack(msplit'\\ \\\\ \0 \\0 \* \\* \# \\# \- \\- \| \\| \+ \\+ \^ \\^ \a \\a \b \\b \t \\t \n \\n \v \\v \f \\f \r \\r \14 \\14 \15 \\15')
		),'@clip')
	end
	foreach(updates,transition)	
end

function _draw()
	cls()
	if isparallel then
		foreach(scenes,function(s)
			tmap(s.ords,function(v,i)
				-- _scal.push,_scal.push,_scal.shift...
				s.tra(i)
			end)
		end)
	else
		foreach(scenes,transition)
	end
--tmap(_scal,function(v,i)
--local d=v.cu()
--if d then
----dbg(i,d._nm,#v.ords)
--end
--end)
	dbg(version)
	dbg'd?'
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
  token=676;
 }
 exrect{
  extended-rect
  token=306;
 }
 scenes{
  scene-manager
  token=371;
 }
 dmp{
  dump-table-values
  token=150;
 }
 dbg{
  value-instant-print
  token=63;
 }
}
]])
--total cost 1566 tokens

--library
function key_document(o)
poke(0x5f5c,5,1)
	isdocument=true
	local q=tonum(btn(❎))*7+1
	document_x+=q*(tonum(btnp(➡️))-tonum(btnp(⬅️)))
	document_y+=q*(tonum(btnp(⬇️))-tonum(btnp(⬆️)))
	document_x=max(0,document_x)
	document_y=max(0,document_y)
	if btnp(🅾️) then
		scmd[[
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
	if btnp(🅾️) then
		document_x=0
		document_y=0
		scmd[[
			keycheck st key_document 0
		]]
	end
	library_cursor=(library_cursor-1)%#libman+ 1
end

function draw_library(o)
	local comment,doc,slicem,ln
							='','',16,_prm.ln
	local fw,fh
						=ln=='en' and 4 or fwidth
						,ln=='en' and 6 or lheight
	cls(3)
	oprint('knutil library help',8,8,4,10)
	fillp(0x33cc)
	local top,left,right
							=unpack(isdocument
								 and {
								  exrect'4 16 120 80'
										,exrect'4 96 48 20'
										,exrect'52 96 72 20'
								 } or {
								  exrect'4 16 120 44'
										,exrect'4 60 48 56'
										,exrect'52 60 72 56'
									}
								)

	-- title
	local lm=peek(0x5f58)
	poke(0x5f58,0)
	clip(unpack(msplit(left.p)))
	tmap({
		unpack(libman,library_cursor,library_cursor+7)}
			,function(v,i)
		local h,c,j,d=unpack(v)
		if i==1 then
			oprint(unpack(isdocument and {h,8,left.y+5,6,5} or {h,8,left.y+5,5,7}))
			comment=
			 ln=='en'
			  and (c or 'no comment...')
			 or j or 'なし'
			doc=replace(d or 'no document...'
									,[[\n]],"\n")
			slice=ln=='en' and 17 or 11
		else
			?h,12,left.y+5+(i-1)*6,11
--			?h,12,65+(i-1)*6,11
		end
	end)
	clip()
	left.rs(isdocument and 0x31 or 0x39)

	-- doc
	clip(unpack(msplit(top.p)))
	oprint(doc
		,top.x+3-document_x*fw/1,top.y+5-document_y*fh/1,7,13
	,'\+gh,')

	clip()
	top.rs(isdocument and 0x39 or 0x31)
	poke(0x5f58,lm)

	clip(right.x+3,right.y+2,right.w-(fw==fwidth and 6 or 5),right.h-7)

	comment=replace(comment,'゛','\+dd゛\+dj','゜','\+dd゜\+dj')
	for i=0,7 do
		oprint(comment
			,right.x+3-i*fw*slice
			,right.y+5+i*fh
			,7,13
			,'\+gh,'
		)
	end
	clip()
	right.rs(0x31)
	poke(0x5f58,0)
	if _cnt%60>8 then
		if isdocument then
		 oprint('🅾️',left.ex-5,left.y,10,9)
	 else
		 oprint('🅾️',top.ex-5,top.y,10,9)
		end
	end
	poke(0x5f58,lm)
end

menuitem(5,'scene order dg',function()
scmd([[
	keycheck rm key_library
	library cl
	stack st stacked 0
	items st draw_items 0
]], items)
--scmd([[
--	keycheck st key_order 0
--	stack st stacked 0
--	items st draw_items 0
--	library cl
--]], items)
poke(0x5f58,0)
end)

menuitem(3,'library info',function()
dmp(tokencost)
end)

menuitem(2,'ライフ゛ラリ(jp)',function()
library_init([[ln=jp;]])
poke(0x5f58,0x81)
end)
menuitem(1,'library help',function()
library_init([[ln=en;]])
poke(0x5f58,0)
end)

-- init custom font
fwidth=6
fheight=8
lheight=8
lheight=12
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
poke(0x5600,fwidth,fwidth,lheight,0,0,0x3)
	
function library_init(p)
libman=msplit([[
amid	mid with positive and negative of the specified number.	していした すうちの「せい」と「ふ」て゛midを おこないます。	amid(...)\n- @param  number ... -- absolute upper and lower limits, which are treated as positive and negative numbers.\n- @param  number ... -- value to be tested as median.\n- @return number  -- value within the range specified by the first argument.\n\n- @description\n - it is used in controlling the camera and parameters that can swing either + or -.
bpack	pack the value of the bit specification with bit width.	ふくすうの「bitち」をしていして ひとつの すうちに つめます。	bpack(w,s,b,...)\n- @param  table  w  -- bit width table for packing.\n- @param  number s  -- bit value to be shifted to the right before the first pack.\n- @param  number b  -- the value to pack.\n- @param  number ... -- bit width to the next pack.\n- @return number  -- packed value.\n\n- @description\n - by packs in the direction of low bits when multiple bit values are specified.\n - by setting [number s] to a negative value, bit pack can be started from the decimal point.\n - if there are fewer bit-width elements relative to the value to be packed, the bit-width elements are rotated.
bunpack	slice the value with bit width.	「bitはは゛」を していして ひとつのすうちを ふ゛んかつして かえします。	bunpack(b,s,w,...) \n- @param  number b  -- the value to slice.\n- @param  number s  -- bit value to right-shift before the first slice.\n- @param  number w  -- bit width to the first slice.\n- @param  number ... -- bit width to the next slices.\n- @return ...  -- sliced value as a tuple.\n\n- @description\n - by specifying the argument after [number w], a value of up to 32 bits can be sliced.\n - by setting [number s] to a negative value, bit slice can be started from the decimal point.
cat	concatenate tables. indexes are added last and identical keys are overwritten.	テ-フ゛ルの れんけつを します。	cat(f,...)\n- @param  table f  -- add destination table.\n- @param  table ... -- next table to add.\n- @return table  -- concatenated table.
comb	combines two tables to create a hash table.	キ-のテ-フ゛ルと あたいのテ-フ゛ルから れんそうはいれつテ-フ゛ルを さくせいします。	comb(k,v)\n- @param  table k  -- key string table.\n- @param  table b  -- value tables.\n- @return table  -- table of associative arrays.
ecpalt	transparency setting from the color table.	カラ-テ-フ゛ルから とうめいせっていを します。	ecpalt(p)\n- @param  table p  -- table of colors to be transparent.\n\n- @description\n - transparency is reset at each function execution.\n - if the value of the "color id key" in the palette table is 0, the palette becomes transparent.\n - the palette that was made black by mkpal() can be used as transparent as it is.\n - the format is redundant due to the specification to match mkpalt().
htd	convert a contiguous hexadecimal string into a table.	れんそ゛くした 16しんすうもし゛れつを テ-フ゛ルに へんかんします。	htd(b,n)\n- @param  string b  -- consecutive hexadecimal strings (not including 0x).\n- @param  number n  -- number of digits to be split.\n- @return table  -- segmented table.\n\n- @description\n - the number of supported delimited bits is 4,8,12,16 bits (1~4 nibbles).\n - characters that cannot be converted to numbers are ignored.\n - the result of the api's "tonum('0x'. .v)" of the api.\n - depending on the delimiter, a missing last character will result in a lower digit by the number of missing characters.
htbl	converting a string to a table(multidimensional array / hash table / jagged arrays)	もし゛れつから テ-フ゛ルを さくせいします。(たし゛ゅうはいれつ たいおう)	htbl(ht)\n- @param  string ht  -- formatted string.\n- @return table  -- generated table.\n\n- @description\n - a single string can initialize many values.\n - returns at least an empty table.\n - elements can be added space-separated. (the space character cannot be used as a value.)\n - {} specifies a table.\n - key=val; key{val} specifies the key and value of the table.\n - newline codes are ignored.\n - bool values, nil, and hexadecimal strings are automatically normalized.\n - the first level can be initialized with global values by using cat() in _env.
inrng	tests that the specified value is within a range.	すうちか゛ はんいないて゛あることを はんていします。	inrng(...)\n- @param  number ...  -- test value\n- @param  number ...  -- lowest value\n- @param  number ...  -- highest value\n- @return boolean  -- if it's within the range\n\n- @description\n - the number of supported delimited bits is 4,8,12,16 bits (1~4 nibbles).\n - characters that cannot be converted to numbers are ignored.\n - the result of the api's "tonum('0x'. .v)" of the api.\n - depending on the delimiter, a missing last character will result in a lower digit by the number of missing characters.
join	joins strings with a delimiter.	もし゛れつを れんけつします。	join(d,s,...)\n- @param  string d  -- delimiter\n- @param  string s,... -- string to be joined\n- @return string  -- joined string value
mkpal	create a palette table with consecutive hexadecimal strings.	れんそ゛くした 16しんすうもし゛れつて゛ ハ゜レットテ-フ゛ルを さくせいします。	mkpal(p,s)\n- @param  any p  -- a "table, or hexadecimal string" containing the color id to be swapped.\n- @param  any s  -- a "table, or hexadecimal string" containing the color id to be displayed after swapping.\n- @return table,... -- returns the palette swap table possible with pal(). returns a tuple if there are multiple arguments.
msplit	converts a string into a table by splitting it with multiple delimiters.	もし゛れつを ふくすうの くき゛りもし゛て゛ ふ゛んかつして テ-フ゛ルに へんかんします。	msplit(s,d,...)\n- @param  string s  -- string to be split.\n- @param  any  d  -- delimiter of division.\n- @param  any  ... -- next delimiter after splitting.\n- @return table  -- table partitioned from string.
oprint	adds outlines to text and prints them.	もし゛を アウトラインつきて゛ ひ゛ょうか゛ します。	oprint(t,x,y,f,o)\n- @param  string s  -- text to display.\n- @param  number x  -- x coordinates.\n- @param  number y  -- y coordinates.\n- @param  number f  -- foreground color.\n- @param  number o  -- outline color.\n- @param  string p  -- p8scii code for decoration (default is outline decoration)\n\n- @description\n - enclosure is not possible if tabs or newlines are included. (in pico8_v0.2.5.g)\n - operation is not guaranteed if "param s" contains decorative p8scii.\n - decorative parameters are "," separated, with the last character ending in a ",".
rceach	iterate from rectangle values.	くけいテ゛-タて゛ ル-フ゜をします。	rceach(r,f)\n- @param  string|table r  -- rectangle initialization format.\n- @param  function f  -- function(x, y, r) to execute.\n\n  * in a function\n - @param x  number  -- x-coordinate\n - @param y  number  -- y-coordinate\n - @param r  string|table -- argument rectangle format
replace	perform string substitutions.	もし゛れつを ちかんします。	replace(s,f,r,...)\n- @param  string s  -- target string\n- @param  string f  -- matching string\n- @param  string r  -- string to replace from the matched string\n- @param  string ...  -- next match & replace string\n- @return string  -- replaced string
tbfill	creates a table filled with the specified values.	していした すうちて゛ うめたテ-フ゛ルを つくります。	tbfill(v,s,e,...)\n- @param  any  v  -- values that satisfy the table.\n- @param  number s  -- index to start.\n- @param  number e  -- index value to end.\n- @param  number ...  -- indexes to start and end the next level of hierarchy.\n- @return table  -- table filled with values. \n\n- @description\n - by specifying additional start and end elements for the tuple, it becomes a multidimensional table.
tmap	more compact operable foreach iterator.	foreachの ついかきのうは゛ん。	tmap(t,f)\n- @param  table t  -- table to scan\n- @param  function f  -- function(v, i) to execute.\n- @return table  -- table of arguments updated in the function.\n\n- @description\n - execute as many functions as there are elements in the table.\n  the arguments of the function to be executed are the element value, index and key value.\n  passing a return value in the function will update the table elements.\n\n - the basic function to be specified.\n  function(v,i)\n  return r\n  end\n  @param  any v - current table element.\n  @param  any i - index or key of the current table element.\n  @return any r - value to update the current element.
tohex	converts an integer 10 number to the specified number of hexadecimal digits.	せいすうの10しんすうちを していした けたすうの 16しんすうに へんかんします。	tohex(v,d)\n - tohex  -- converts to a hexadecimal string filled with zeros.\n- @param  number v  -- number to be displayed in hexadecimal.\n- @return number d  -- number of digit justification by zero-filling.\n\n- @description\n - if the number of digits is not specified, specify 0.\n - the maximum number of digits specified is 4.
ttable	if the argument is a table, the table is returned.	テ-フ゛ルて゛あれは゛テ-フ゛ルを かえし、そうて゛なけれは゛falseを かえします。	ttable(p)\n- @param  any p -- check if it is a table.\n- @return any  -- if it is a table, return the argument, otherwise return false.\n\n- @description\n - determines the type of a variable or argument of indeterminate type.\n - for example, when switching the processing method between string and table.
dbg	outputs values to the screen regardless of output timing.	しゅつりょくタイミンク゛かんけいなして゛ あたいを か゛めんしゅつりょく します。	dbg(...)\n- @param  any ... -- specify the value you want to display as debugging.\n\n- @description\n - executed with arguments, it stacks values for display.\n - you need to specify 'd?' at the timing you want to display.\n - when the stacked value display is complete, it is reset.
dmp	dumps information about a variable.	テ-フ゛ルの ないようを ひょうし゛します。	dmp(v)\n- @param  any v  -- value to be displayed, table.
exrect	generate rect object with extended functionality.	きのうかくちょうしたRECTオフ゛シ゛▤クトを せいせいします。	exrect(p)\n- @param  string|table p -- 'x y w h' {x,y,w,h} rectangle data. this argument is retained.\n- @return rect-object - rectangular objects that can be drawn and judged.\n\n- @description\n - drawing the rectangle that the object has.\n - determining the inner bounding box of a rectangle.\n - holding and referencing rectangle data.\n  \n - @function con - determines the inclusions of rectangular objects or coordinates.\n  - @param  rect-object|number p -- if the argument is not only an object, it is determined by x-coordinates.\n  - @param  number y -- y-coordinate\n  - @return bool\n\n - @function hov - determines that the rectangle overlaps.\n  - @param  rect-object r\n  - @param  inversion i -- for recurrence check(the target rectangle is being replaced).\n  - @return bool\n\n - @function ud - rectangle update\n  - @param rect-object|number p -- if it is a number, it is assumed to be an x coordinate. for strings and tables, it is treated in the same way as initialization "exrect".\n  - @param number y -- y-coordinate\n  - @param number w -- width\n  - @param number h -- height\n  - @return rect-object -- own-object\n\n - @function rs - draw rect\n  - @param number col -- drawing color\n  - @return rect-object -- own-object\n\n - @function rf - draw rectfill\n  - @param number col -- drawing color\n  - @return rect-object -- own-object\n\n - @function cs - draw circ\n  - @param number col -- drawing color\n  - @return rect-object -- own-object\n\n - @function cf - draw circfill\n  - @param number col -- drawing color\n  - @return rect-object -- own-object\n\n - @function os - draw oval\n  - @param number col -- drawing color\n  - @return rect-object -- own-object\n\n - @function of - draw ovalfill\n  - @param number col -- drawing color\n  - @return rect-object -- own-object
mkscenes	create a multitasking scene object.	マルチタスクの シ-ンオフ゛シ゛▤クトを さくせいします。	mkscenes( keys )\n- @param  table keys  -- scene name table.\n- @return table  -- scene object table for scanning.\n\n- @description\n - look for knutil on lexalofflebbs.
]],"\n","\t")
scmd([[
	library st draw_library 0
	keycheck rm key_library
	keycheck us key_library 0
	items cl
	stack cl
	transition cl
	push cl
	shift cl
	unshift cl
	remove cl
	task cl
]],htbl(p))

--scmd([[
--	library st draw_library 0
--	keycheck st key_library 0
--	items cl
--	stack cl
--	transition cl
--	push cl
--	shift cl
--	unshift cl
--	remove cl
--]],htbl(p))

end

-->8
--[[
update history
**v0.14.0**
- amid:change the order of arguments.
- ecpalt:be sure to perform initialization of the transparency settings.
- htbl:token cost cut, note second return value.
- htd:change from tmap to foreach.
- dbg:support for nil
- dmp:added _update_buttons().
- mkpal:arguments before and after the change. support for multiple palette sets.
- msplit:wrapper for split() is eliminated and renamed.
- oprint:inherit outline() and rename function.
- replace:support for multiple replacements.
- tmap:support for false replacements.
- ttable:use count() to determine.
- scene:
 - cmdscenes:changed to scmd. for a while cmdscenes will remain for compatibility.
 - sh:delete order shift as it is not used.
 - order:
  - swap ENV[] and order parameters to support references from global variables
  - change parameter name(_rate _cnt _rm _fst _lst _nm _dur _prm)
- changed diagram staging; no intervening shift processing.
- parallel added to diagram production.
- correction of library documentation.

- [deleted]:
 - toc
 - tonorm
 - ecmkpal

**v0.13.1**
- corrected commented out vdmp to dmp.

**v0.13**
- scene:
 - cmdscenes:supports indentation description by tabs.
- dmp:token cost cutting.

**v0.12**
- library help added to pause menu
- bmch: unlisted
- exrect: fix variable and function names
- scene:
 - rate: adjustment of decimal point overflow countermeasures
 - cmdscenes: continuous call handling
 - added functions for iterators
- dbg: simplification by join


**v0.11**
- htd: fixed table values to local variables
- bpack: specification change from ttoh()
- bunpack: specification change from htot()
- slice: the function was removed because there is a {unpack()} with a similar function.

**v0.10**
- split: supports multi-dimensional arrays
- cmdscenes: fixed for split update
- sceneorder: update for use of tuples
- dmp: apply p8scii font color

**v0.9**
- tbfill: changed to specify indexes at the beginning and end of tables, support for variable length arguments.
- tohex: fixed for update of tbfill()
 
**v0.8**
- join: use of tuples
- tbfill: defaults to 1 or specifies the start of the table
- tohex: fixed for update of join()

**v0.7**
- sceneorder:"rate" func countermeasures against overflow of digits
- code update saved token: 
 - htbl: 7 tokens
 - tonorm: 9 tokens

**v0.6**
- simplified handling of scene orders
- rceach: name change from ecxy()
- inrng: using tupple twice
- exrect.con: name change from exrect.cont()
- exrect.hov: name change from exrect.hover()
- scenes: order.rate is calculated enough value in the last count
 - cmdscenes change name from scenesbat

**v0.5**
- mainly due to sub()'s cpu cost countermeasure.
- replace: fix usage of sub()
- htd: convert from split()
- htbl: run newlines without replace()
- scene: save cost with split()&comb() at initialization
- dbg: change to display values without dbg() argument
- example: add htbl() example use

]]--
    
-->8
-- other functions
--[[


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

function tonorm(v)
	if v=='false' then return false
	elseif v=='nil' then return nil
	end
	return v=='true' or tonum(v) or v
end

--**join for long data**
function join(d,s,...)
	local a={...}
	while a[1] do
	s..=d..deli(a,1)
	end
	return s or ''
end

function ttoh(h,l,b)
	return bor(shl(tonum(h),b),tonum(l))
end

function htot(v)
	return {lshr(band(v,0xff00),8),band(v,0xff)}
end

function slice(r,f,t)
	local v={}
	for i=f,t or #r do
	add(v,r[i])
	end
	return v
end


--*v0.13.0 tokencost
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
--total 1615
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
00000000000000000000000000000000000000000000000000777000000070007000000000000000000070700007000000000000000000000000000000000000
07770000000000000000000000000000000000070007000000700000000070007000000000000000000070700070700000000000000000000000000000000000
07770007770007770007070007070000000000770007700000700000000007070000000000000000000000000007000000000000000000000000000000000000
07770007770007070000700000000070707007770007770000000000000077777007700000000000000000000000000000000000000000000000000000000000
07770007770007770007070007070000000000770007700000000000700000700007700000000007000000000000000000000000000000000000000000000000
07770000000000000000000000000000000000070007000000000000700077777000000070000070700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000077700000700000000007000007000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700007070000070000700000070007000000700000007070000000000000000000000000000000000000070000000000000000000000000000000000
00000000700007070007070007777070070070700000700000070007000007070000000000000000000000000000070000000000000000000000000000000000
00000000700000000077777070700070700070700000000000070007000000700000700000000000000000000000700000000000000000000000000000000000
00000000700000000007070007770000700007007000000000070007000007770007770000000007770000000000700000000000000000000000000000000000
00000000700000000077777000707000707070707000000000070007000000700000700000000000000000000000700000000000000000000000000000000000
00000000000000000007070077770007007070070000000000070007000007070000000007000000000000000007000000000000000000000000000000000000
00000000700000000007000000700007000007707000000000007070000000000000000070000000000007000007000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770000770007770007770070077077777007770077777007770007770000000000000000000000000000000007770000770000000000000000000000000000
70077007770070077070077070077070000070000070077070077070077000700000700000070000000007000000070000770000000000000000000000000000
70077000770000077000077070077070000070000070077070077070077000000000000000700077770000700000070000000000000000000000000000000000
70077000770007770007770007777077770077770000077007770007777000000000000007000000000000070000770000000000000000000000000000000000
70077000770070000000077000077000077070077000077070077000077000000000700000700077770000700000700000000000000000000000000000000000
70077000770070000070077000077000077070077000077070077000077000700000700000070000000007000000000000000000000000000000000000000000
07770007777077777007770000077077770007770000077007770007770000000007000000000000000000000000700000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770007770007770007777077770007777007777007777070007007770007777070007070000077077077007007770000000700000000000000000000000000
70077070007070007070000070007070000070000070000070007000700000070070070070000070707070707070007000007000000000000000000000000000
70707070007070007070000070007070000070000070000070007000700000070070700070000070707070707070007000007000000000000000000000000000
70707070007077770070000070007077770077770070077077777000700000070077000070000070707070707070007000007000000000000000000000000000
70077077777070007070000070007070000070000070007070007000700070070070700070000070007070707070007000070000000000000000000000000000
70000070007070007070000070007070000070000070007070007000700070070070070070000070007070707070007000000000000000000000000000000000
07770070007077777007777077770077777070000007770070007007770007700070007077777070007070077007770000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770007770007770007777077777070007070007070007070007070007077777000077000000077000000700000000000077700000000000000000000000000
70007070007070007070000000700070007070007070007070007070007000007000070007000007000007070000000000000700000000000000000000000000
70007070007070007070000000700070007070007070007007070070007000070000070000700007000000000000000000007700000000000000000000000000
70007070007070007007770000700070007070007070707000700070007000700000070000700007000000000000000000000000000000000000000000000000
77770070707077770000007000700070007007070070707007070007770007000000070000700007000000000000000000007000000000000000000000000000
70000070070070070000007000700070007007070070707070007000700070000000070000070007000000000007770000000000000000000000000000000000
70000007707070007077770000700007770000700077077070007000700077777000077000000077000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000000070000000000000007000000000777000000070000000700000007070000007700000000000000000000000000000000000000000000000000000
00070077700070000000000000007000000007000000777070000000000000000070007000700000000000000000000000077700000000000000000000000000
00000007770077770007777007777007777077777007007077770007700000007070070000700077077007770007770070770070000000000000000000000000
00000070070070007070000070007070077007000007007070007000700070007077700000700070707070007070007070770070000000000000000000000000
00000070077070007070000070007077700007000000777070007000700070007070700000700070707070007070007070077700000000000000000000000000
00000077707077777007777077777007777007000070007070007000770007770070077000770070707070007007770000000000000000000000000000000000
00000000000000000000000000000000000000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000077000700077000000000000000000000000000000000000000000000000
00000000000000000000000007000000000000000000000000000000000000000000070000700007000000000000700000000000000000000000000000000000
07777077770070777007777077777070007070007070707070007070007077777000070000700007000007000070007000000000000000000000000000000000
70007070007077000077700007000070007070007070707007007070007000770000770000700007700070707000700000000000000000000000000000000000
70007070007070000000077007000070007070070077077000770007777007000000070000700007000000070007770000077700000000000000000000000000
77770007777070000077770000777007770007700007070077007000007077777000070000700007000000000007770000000000000000000000000000000000
70000000007000000000000000000000000000000000000000000077770000000000077000700077000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070077700000000000000000000000000
77777070707070007007770070007007000007770077077007770007770000700007770077777000777007770000700070770070000000000000000000000000
77777007070077077077777000700007777077707077777077077007770007770077077070707000700077077007770070770070000000000000000000000000
77777070707077777070707070007007770077777077777077077077777077777070777077777000700070707077777070770070000000000000000000000000
77777007070070707077077000700077770077777007770077077007770007070077077070007077700077077007770070077700000000000000000000000000
77777070707007770007770070007000070007770000700007770007070007770007770077777077700007770000700000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007700000070007700007000007007007007000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077070070007000770007770007707007707000007000000000000000000000000000
07700000000007000007000007070000000000000007000000000000700007770070007077007077070077007077007000070700000000000000000000000000
77070070070007700077700077070077770000070077770007770077770007077070007000007000700007770007000000007000000000000000000000000000
07700070070070070000700007000000070000070070070000700000700070707070007000007007700070707007007000000000000000000000000000000000
70770070070000070007000077770000770077700000070000700007700070707070707000070070070070707007007000000000000000000000000000000000
77070007000007700070770077070007000000700000700077770070700077007007000000700070077077070070077000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000070070070007770000777070000000070000070077770007770007000000000000077070000007007070000000007000000000000000000000000000
77770000700070777000007077700070000077777007077000700077000007777007770077707070007077707070777070077700000000000000000000000000
00070007000070070000000000700070000000770077770007077007077077000070007000070007070070007070000070777770000000000000000000000000
07777070000070070000000000070070000007070007070077700007000007770000007000700007700000770070000070077700000000000000000000000000
00070070000070070000000070000070007007070007000007000070000070007000007000700070000007700070000000007000000000000000000000000000
70000007700070070070000070000070007000770007000007000070700000007000007000700070000070070070700000000000000000000000000000000000
07770000077070700007777007770007770007700000777000770070077000770000770000077007777007707070077000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70070070077007770070070077000007770007700070777077700077007007007070070007000070070070770000700070070770000000000000000000000000
70770070707070007077777007077000070070070070070000777000707077707070770077770070770007707000777070077000000000000000000000000000
77077077707070707070070070000000700070070070777077700000707007007077707007000007007070707000700000770700000000000000000000000000
70707007007070707070070070007000700070007070070000777007777007700070707077700077007070707000700070070700000000000000000000000000
70707007077070707070770070007070070000007070770007700070707070707070707007007007007070707007770070070000000000000000000000000000
77077070707070707077007070007070077000007077007070070070707070707077007007007000700000770070077000000000000000000000000000000000
00077070777077007070770007770070707000007070770077707077007007770000070000770000700007000077707000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770070007007770007007007770070000007770000700000000000000000000000000077770000007000700000007070000700000000000000000000000000
70007070007000070077077000070070770077000007000000000000000000000000000000007000007077777077770000707000000000000000000000000000
70000070707000770077707000700077007007077007000000000070700070770007000000007000007070007000700000700000000000000000000000000000
07770077007077007007007007770070007007700007700007700077770007707007770000707000070070007000700070700770000000000000000000000000
00007007007000777077070070007007007070070070070070070070070070707007000000770077770000007000700000070000000000000000000000000000
00007000007007007007070000007077007070000070070000070007000070770070700000700000070000007000700000000000000000000000000000000000
00770000070007770007077000770007070007777070077000700007000000700077070007000000070007770077777000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070007000000700007770070000077770007007077700077770007000070007007770000077070700007777070000070707000000000000000000000000000
77777077770077777007007077777000007077777000007000007007777070007070007007770070707000000070000070770070000000000000000000000000
00070007007000700070007070070000007007007077707000007077007007007070007000070070707077777070000070077700000000000000000000000000
00770007007000700000007070070000007007007000007000070007000007007077777077777000007000070077770000707000000000000000000000000000
00770007007077777000007000070000007000007000007000770007000000007070007000070000007000070070007000770000000000000000000000000000
07070007007000070000007000070000007000007000007007007007000000007000007000070000007000070070000000000000000000000000000000000000
70070070077000070007770007700077777000770077770070007000777007770000070007700007770007700070000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070007777077770000700000007000070070000077770007700000700077770007000000700000007077770070777000000070000000000000000000000000
77777000000000007077770000007007007070007000007070070077777000007000777007000007007007000077007000777700000000000000000000000000
00070000000000007000007000007007007077770000007000070000700000007007000007000007007007000070007070007000000000000000000000000000
00070000000077070000007000007007007070000000007000070070770000007000777070007000707077770070070070007000000000000000000000000000
00070000000000770007770000007070007070000000007000007070707070070070000070007000707007000007000000777770000000000000000000000000
00070000000007007070707000070070007070000000070000007070707007700007000070077000070007000007000000000000000000000000000000000000
07700077777070000000700077700070007007777000700000007070707000077000777077707077707000777007000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700077770077777070007000700070000077770077770077770000000000000000000000000000000000077077000070070000000000000000000000000000
00070000007000000070007070700070000070007070007000007077707000000000000000000000000000700000700000070000000000000000000000000000
00070000007077770070007070700070000070007070007077777000007070700070770077000077000077000000077070077700000000000000000000000000
00070007777000007070007070700070000070007070007000007000007070707077070000700000700000000000000000070070000000000000000000000000
00070000007000007000007070700070007070007000007000007000007000007070000000700007700000077077000000070000000000000000000000000000
00070000007000070000007070700070070070007000007000007000007000007007000000700000700000700000700000000000000000000000000000000000
77777077777000700000770070077007700007770000070000070077770007770007000077770077700077000000077000000000000000000000000000000000
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
00000000000000000000000000000000cdddddddddcdcccdcccdcccdcdddddddcccdcccdcccdccdddccdcccdcccdcccddccdccddddddcdcddddddddddddddddc
09999999999999999999999999000000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdcddddcdddcdddcddcdcdcdcdddddcdcddddddddddddddddc
99499449444944994449444949900000cdddddddcddddcddccddcccdddcddddddcddccddcccdcdcdcccddcdddcdddcddcdcdcdcdddddcccddddddddddddddddc
94994949494949494999494994900000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdddcddcdddcdddcddcdcdcdcdddddddcddddddddddddddddc
94994949449949494499449994900000cdddddddddcddcddcdcdcdcdcddddddddcddcdcdcdcdcdcdccddcccddcddcccdccddcdcdddddddcddddddddddddddddc
94994949494949494999494994990000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
49994499494944494449494999490000cddddddddddddddddddddddddddddddddddddccdcccdccddcccdcccdddddccddcdddcdddddcdcccdcccdcccddddddddc
99099999999999999999999909990000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcddddddcddcdddcddddcddddcdcdcdcdcddddddddc
49900009944944494499000099490000cdddddddddddddddddddddddddddddddddddcdcdccddcdcdccddccdddddddcddcccdcccddcddcccdcdcdcdcddddddddc
94900009499944494949000094990000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcddddddcddcdcdcdcddcddcdddcdcdcdcddddddddc
94900009490949494949000094900000cdddddddddddddddddddddddddddddddddddccddcdcdcccdcccdcdcdddddcccdcccdcccdcdddcccdcccdcccddddddddc
94990009499949494949000994900000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
99490009944949494449000949900000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
09990000999999999999000999000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
00000000000000000000000000000000cdddddddddcdcccdcccdcccdcdddddddcccdcccdcccdccdddccdcccdcccdcccddccdccddddddcccddddddddddddddddc
00000000000000000000000000000000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdcddddcdddcdddcddcdcdcdcdddddddcddddddddddddddddc
11101010011010100000000000000000cdddddddcddddcddccddcccdddcddddddcddccddcccdcdcdcccddcdddcdddcddcdcdcdcddddddccddddddddddddddddc
10101010100010100000000000000000cddddddddcdddcddcdcdcdcddcdddddddcddcdcdcdcdcdcdddcddcdddcdddcddcdcdcdcdddddddcddddddddddddddddc
11101010111011100000000000000000cdddddddddcddcddcdcdcdcdcddddddddcddcdcdcdcdcdcdccddcccddcddcccdccddcdcdddddcccddddddddddddddddc
10001010001010100000000000000000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
10000110110010100000000000000000cddddddddddddddddddddddddddddddddddddccdcccdccddcccdcccdddddcccdcccdddcdcccdcccdcccddddddddddddc
00000000000000000000000000000000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcdddddcdcdddcddcddddcdcdcdcdcddddddddddddc
00000000000000000000000000000000cdddddddddddddddddddddddddddddddddddcdcdccddcdcdccddccddddddcccddccddcddcccdcdcdcdcddddddddddddc
00000000000000000000000000000000cdddddddddddddddddddddddddddddddddddcdcdcdcdcdcdcdddcdcdddddddcdddcddcddcdddcdcdcdcddddddddddddc
10101100011010101110111011100000cdddddddddddddddddddddddddddddddddddccddcdcdcccdcccdcdcdddddddcdcccdcdddcccdcccdcccddddddddddddc
10101010100010100100100001000000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
10101010111011100100110001000000cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc
10101010001010100100100001000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
01101010110010101110100001000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
00000000000000000000000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
00000000000000000000000000000000a999999999a9aaa9aaa9aaa9a9999999aaa9aaa9aaa9aa999aa9aaa9aaa9aaa99aa9aa999999aa99999999999999999a
00000000000000000000000000000000a99999999a999a99a9a9a9a99a9999999a99a9a9a9a9a9a9a9999a999a999a99a9a9a9a999999a99999999999999999a
ccc0ccc0ccc0ccc0c000c000ccc0c000a9999999a9999a99aa99aaa999a999999a99aa99aaa9a9a9aaa99a999a999a99a9a9a9a999999a99999999999999999a
c0c0c0c0c0c0c0c0c000c000c000c000a99999999a999a99a9a9a9a99a9999999a99a9a9a9a9a9a999a99a999a999a99a9a9a9a999999a99999999999999999a
ccc0ccc0cc00ccc0c000c000cc00c000a999999999a99a99a9a9a9a9a99999999a99a9a9a9a9a9a9aa99aaa99a99aaa9aa99a9a99999aaa9999999999999999a
c000c0c0c0c0c0c0c000c000c000c000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
c000c0c0c0c0c0c0ccc0ccc0ccc0ccc0a999999999999999999999999999999999999aa9aaa9aa99aaa9aaa99999aa99aaa9a9a999a9aaa9aaa9aaa99999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9a9a9a9a9a999a9a999999a9999a9a9a99a9999a9a9a9a9a99999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9aa99a9a9aa99aa9999999a999aa9aaa99a99aaa9a9a9a9a99999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9a9a9a9a9a999a9a999999a9999a999a99a99a999a9a9a9a99999999a
01101000111011101110000000000000a99999999999999999999999999999999999aa99a9a9aaa9aaa9a9a99999aaa9aaa999a9a999aaa9aaa9aaa99999999a
10001000100010101010000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
10001000110011101100000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
10001000100010101010000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
01101110111010101010000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
00000000000000000000000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
00000000000000000000000000000000a999999999a9aaa9aaa9aaa9a9999999aaa9aaa9aaa9aa999aa9aaa9aaa9aaa99aa9aa999999aaa9999999999999999a
00000000000000000000000000000000a99999999a999a99a9a9a9a99a9999999a99a9a9a9a9a9a9a9999a999a999a99a9a9a9a9999999a9999999999999999a
00000000000000000000000000000000a9999999a9999a99aa99aaa999a999999a99aa99aaa9a9a9aaa99a999a999a99a9a9a9a99999aaa9999999999999999a
00000000000000000000000000000000a99999999a999a99a9a9a9a99a9999999a99a9a9a9a9a9a999a99a999a999a99a9a9a9a99999a999999999999999999a
00000000000000000000000000000000a999999999a99a99a9a9a9a9a99999999a99a9a9a9a9a9a9aa99aaa99a99aaa9aa99a9a99999aaa9999999999999999a
00000000000000000000000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
00000000000000000000000000000000a999999999999999999999999999999999999aa9aaa9aa99aaa9aaa99999aaa9aaa999a9aaa9aaa9aaa999999999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9a9a9a9a9a999a9a99999a99999a99a9999a9a9a9a9a999999999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9aa99a9a9aa99aa999999aaa99aa99a99aaa9a9a9a9a999999999999a
00000000000000000000000000000000a99999999999999999999999999999999999a9a9a9a9a9a9a999a9a9999999a999a99a99a999a9a9a9a999999999999a
00000000000000000000000000000000a99999999999999999999999999999999999aa99a9a9aaa9aaa9a9a99999aaa9aaa9a999aaa9aaa9aaa999999999999a
00000000000000000000000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
00000000000000000000000000000000a9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a
00000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
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
77777777000777777777000777770000000000000000000000000000000000000000000000002000200020002020200000002020202020202000202020000000
57575557000755775757000755570000000000000000000000000000000000000000000000002220200022002020220000002020220020202200220022200000
57575757000775775757000757570000200000000000000000000000000000000000000000000020200020002020200000002020202020202000202000200002
57575757000075775557000757570000200000000000000000000000000000000000000000002200022022202020222000002200202022202220202022000002
55575757777775777757777757570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
75775557757755570757757755570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777770777777777770000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002

