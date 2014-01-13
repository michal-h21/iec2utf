kpse.set_program_name("luatex")

local cmd_arg = [[
iec2utf.lua - Script for converting LaTeX LICR codes to utf8 characters
Usage: cat filename | texlua iec2utf.lua > newfilename

Parameters:
  comma separated list of LaTeX font encodings used in the document
]]

local enc = {}

local licrs = {}
local codepoint2utf = unicode.utf8.char 
function load_encodings(f)
  local file= io.open(f,"r")
  local encodings = file:read("*all")
  file:close()
  for codepoint, licr in encodings:gmatch('DeclareUnicodeCharacter(%b{})(%b{})') do
    local codepoint = codepoint2utf(tonumber(codepoint:sub(2,-2),16))
    local licr= licr:sub(2,-2):gsub('@tabacckludge','')
    licrs[licr] = codepoint
  end
end

function sanitize_licr(l)
  return l:gsub(" (.)",function(s) if s:match("[%a]") then return " "..s else return s end end):sub(2,-2)
end
if arg[1] == nil then
  enc = {"T1"}
else
  for _,n in pairs(arg) do
    enc[#enc+1] = n
  end
end

for _,e in pairs(enc) do
  local filename = e:lower() .. "enc.dfu"
  local dfufile = kpse.find_file(filename)
  if dfufile then
    load_encodings(dfufile)
  end
end

local input = io.read("*all")

local cache = {}

local output = input:gsub('\\IeC[%s]*(%b{})',function(iec)
  local code = cache[iec] or licrs[sanitize_licr(iec)] or '\\IeC '..iec
  -- print(iec, code)
  cache[iec] = code
  return code
end)

io.write(output)
