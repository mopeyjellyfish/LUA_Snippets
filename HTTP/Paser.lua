---Parse HTTP Named pair buffers into a table. call http_parse with raw http body. returns table
--[[
Example usage:
  
local Params = http_parse(HTTP_BUFFER)
        if Params.ErrorCode == '0' then
          --successful
           g_PRINTLOG("SUCCESSFUL REQUEST");
        elseif Params.responseCode == '5' then
          --do something with error
           g_PRINTLOG("PRINT ERROR");
        else
]]--
function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str  
end

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end

function string:split( inSplitPattern, outResults )
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

function http_parse(HttpData)
local Parsed = {}
local Params = {}
for w in (HttpData .. "&"):gmatch("([^&]*)&") do 
    table.insert(Params, w) 
end

local HTTPParams = {}

for n, w in ipairs(Params) do
  --g_PRINTLOG(n .. " = " .. w)
  Parsed = w:split("=")
  ---g_PRINTLOG(Parsed[1] .. " " .. Parsed[2])
  HTTPParams[Parsed[1]] = url_decode(Parsed[2])
end
return HTTPParams;
end


