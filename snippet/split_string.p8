pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- split string
function split(str,d,dd)
local a={}
local c=0
local s=''
local tk=''

if dd~=nil then str=split(str,dd) end
while #str>0 do
 if type(str)=='table' then
  s=str[1]
  add(a,split(s,d))
  del(str,s)
 else
  s=sub(str,1,1)
  str=sub(str,2)
  if s==d then 
   add(a,tk)
   tk=''
  else
   tk=tk..s
  end
 end
end
add(a,tk)
return a
end


a=split('1 a 20 split_test --------',' ')

for v in all(a) do
print(v)
end

a=split('1 2 3;a b c;this is split',' ',';')
for b in all(a) do
	for v in all(b) do
	 print(v)
	end
end
