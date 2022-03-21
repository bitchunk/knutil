pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function vdmp(v,_x,_y)
local tstr={
number="#",string="$",boolean="%"
}
tstr["function"]="*"
tstr["nil"]="!"
tstr.table='{'
local p=0
if _x==nil then _x=0 _y=0 color(6) end
if _y==0 then cls() end
if type(v)~='table' then v={v} end
for i,str in pairs(v) do
	if type(str)=='table' then
	 if p>0 then _y+=1 end
 	print(i..tstr[type(str)],_x*4,_y*6)
		_y=vdmp(str,_x+1,_y+1)
  _y+=(#str==0 and -1 or 0)
  print('}',_x*4,_y*6)
  _y+=(#str==0 and 0 or 1)
  p=0
	else
 	str=tstr[type(str)]..':'..tostr(str)
 	print(str,(_x+p)*4,_y*6)
		p=p+#(str..'')+1
	end
end
cursor(0,(_y+1)*6)
if _x==0 then
 stop()
end
return _y+1
end

function _update()
end

function _draw()
vdmp({
 1
,str="string"
,obj={"o","b","j","c","t"}
,{{{}}}
,{nil,true,false,function()end}
})
end
