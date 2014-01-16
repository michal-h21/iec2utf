kpse.set_program_name("luatex")

local cmd_arg = [[
utftexindy - wrapper for using texindy with utf8 encoded files

options are passed to texindy, required is only -L to select the language
]]
local arg = arg or {}
local iec = require "ieclib"
local lang = "english"
local input = nil
local outputfile = nil -- outputfile is specified as explicit option
local outputname = nil -- outputname is generated from input name
local lat_enc = {"T1","T2A","T2B","T2C","T3","T5", "LGR"}


local enc = lat_enc 
if #arg > 0 then

  for i = 1,#arg do
    -- enc[#enc+1] = n
		local n = arg[i]
		if n == "-L" then
			lang = arg[i+1]
                        arg[i] = "" 
                        arg[i + 1] ="" 
		elseif n == "-i" then
			print("Input")
			input = io.read("*all")
		elseif n == "-o" then
			outputfile = arg[i+1]
		end
  end
end

if not input and #arg > 0 then 
	local filename = arg[#arg]
	local f = io.open(filename,"r")
	if not f then 
		print("Cannot load file: "..filename)
		os.exit(-1)
	end
	input = f:read("*all")
	f:close()
	arg[#arg]=nil
	if not outputfile then
		outputname = filename:gsub("%.[^%.]-$",".ind")
	end
elseif #arg == 0 then
		print("Error: You must specify filename or use -i option for standard input")
		os.exit(1)
end

iec.load_enc(enc)

if not outputfile and not outputname then
	print("No output name")
	os.exit(-2)
end

-- local input = io.read("*all")
local output = iec.process(input)

local xindyopt = {"-i", "-M", "lang/"..lang.."/utf8-lang"}
for _, o in ipairs(arg) do
	table.insert(xindyopt,o)
end

if outputname then 
	table.insert(xindyopt,"-o")
	table.insert(xindyopt,outputname)
end

-- io.write(output)
local options = table.concat(xindyopt," ")
print(options)
local xindy = assert(io.popen("texindy "..options,"w"))
xindy:write(output)
xindy:close()
