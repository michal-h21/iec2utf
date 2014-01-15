kpse.set_program_name("luatex")

local cmd_arg = [[
iec2utf.lua - Script for converting LaTeX LICR codes to utf8 characters
Usage: cat filename | texlua iec2utf.lua > newfilename

Parameters:
  comma separated list of LaTeX font encodings used in the document
]]
local iec = require "ieclib"
local enc = {}
if arg[1] == nil then
  enc = {"T1"}
else
  for _,n in pairs(arg) do
    enc[#enc+1] = n
  end
end

iec.load_enc(enc)

local input = io.read("*all")
local output = iec.process(input)

io.write(output)
