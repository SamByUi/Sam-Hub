local b="bG9jYWwgYT1nYW1lLlBsYXllcnMuTG9jYWxQbGF5ZXIgDQpsb2NhbCBiPWEuQ2hhcmFjdGVyIG9yIGE..."
local function d(s)
    local t=s:gsub('[^%w+/=]','')
    return (t:gsub('.',function(x)
        local r,f='',x:byte()
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d%d%d%d%d%d',function(x)
        return string.char(tonumber(x,2))
    end))
end
local f=loadstring(d(b))
if f then f() end

local b="bG9jYWwgbz1mYWxzZQ0KbG9jYWwgcD0yDQpMb2NhbCBmdW5jdGlvbiBxKHIpIA0KcD1tYXRoLmNsYW..."
local function d(s)
    local t=s:gsub('[^%w+/=]','')
    return (t:gsub('.',function(x)
        local r,f='',x:byte()
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d%d%d%d%d%d',function(x)
        return string.char(tonumber(x,2))
    end))
end
local f=loadstring(d(b))
if f then f() end