-- Love Graphical User Interface
jit.off()
love.graphics.setDefaultFilter("nearest", "nearest")
require("Modules/image")
require("Modules/Fonts")
require("Modules/file")
require("Modules/window")
require("Modules/ticker")
require("ldb")

VERSION = ldb.version
PATH = "./Records.ldb"
NODES = 0
focus = nil
instring = ""

BR = 0
BG = 0x80/0xFF
BB = 0x7F/0xFF
TS = 15
POF = 5

WinX = 15
WinY = 15
WinW = 800 - 30
WinH = 600 - 30
WinR = 0xD2/0xFF
WinG = 0xD2/0xFF
WinB = 0xD2/0xFF

TabX = WinX + POF
TabY = WinY + POF
TabW = WinW - (2*POF)
TabH = (4*POF)
TabR = 0x2A/0xFF
TabG = 0x2A/0xFF
TabB = 0x80/0xFF

Bt1X = (TabX + TabW) - 3*(TS + POF)
Bt1Y = TabY + ((TabH - TS)/2)
Bt1W = TS
Bt1H = TS

Bt2X = (TabX + TabW) - 2*(TS + POF)
Bt2Y = TabY + ((TabH - TS)/2)
Bt2W = TS
Bt2H = TS

Bt3X = (TabX + TabW) - 1*(TS + POF)
Bt3Y = TabY + ((TabH - TS)/2)
Bt3W = TS
Bt3H = TS

SwdX = TabX
SwdY = (TabY + TabH) + POF
SwdW = TabW
SwdH = WinH - (TabH + (3*POF))
SwdR = 0xE2/0xFF
SwdG = 0xE2/0xFF
SwdB = 0xE2/0xFF

function numToIndex(n)
	local ret = ""
	local cs = {
		[0]="0", [1]="1", [2]="2", [3]="3",
		[4]="4", [5]="5", [6]="6", [7]="7",
		[8]="8", [9]="9", [10]="A", [11]="B",
		[12]="C", [13]="D", [14]="E", [15]="F",
	}
	
	local index = 17
	while(n > 0) do
		ret = cs[(n % 16)]..ret
		n = math.floor(n/16)
		index = index - 1
	end
	while(index > 1) do
		ret = "0"..ret
		index = index - 1
	end
	
	return ret
end

function indexToNum(ind)
	local ret = 0
	local cs = {
		["0"]=0, ["1"]=1, ["2"]=2, ["3"]=3,
		["4"]=4, ["5"]=5, ["6"]=6, ["7"]=7,
		["8"]=8, ["9"]=9, ["A"]=10, ["B"]=11,
		["C"]=12, ["D"]=13, ["E"]=14, ["F"]=15,
	}
	
	for i = 1, #ind do
		ret = ret + (cs[ind:sub(i,i)] * math.pow(16,16 - i))
	end
	
	return ret
end

function loading(dt)
	local size, flags = ldb.read_db_head(PATH)
	NODES = ((size - ldb.headersize)/ldb.nodesize)
	print(NODES, numToIndex(NODES), indexToNum(numToIndex(NODES)))
	TASK = "Overview"
end

function new_values(t)
	
end

function new_keys(key)
	
end

function overview(dt)
	W01X = TabX + POF
	W01Y = (TabY + TabH) + (2*POF)
	W01W = ((TabW - (2*POF))/2)
	W01H = WinH - (TabH + (5*POF))
	W01R = 0xE2/0xFF
	W01G = 0x02/0xFF
	W01B = 0xE2/0xFF
	
	W02X = W01X + W01W + POF
	W02Y = (TabY + TabH) + (2*POF)
	W02W = ((TabW - (2*POF))/2) - POF
	W02H = WinH - (TabH + (5*POF))
	W02R = 0x02/0xFF
	W02G = 0xE2/0xFF
	W02B = 0x02/0xFF
	
	MainWindow.fore:put(function()
		love.graphics.print({{1,1,1},"Path: "..PATH},W01X,W01Y)
		love.graphics.print({{1,1,1},"Nodes: "..NODES},W01X,W01Y + TS)
		love.graphics.print({{1,1,1},"Index: "},W02X,W02Y)
		love.graphics.print({{1,1,1},"Value: "},W02X,W02Y + TS)
		love.graphics.print({{1,1,1},"Taken: "},W02X,W02Y + (2*TS))
		love.graphics.print({{1,1,1},"Moveable: "},W02X,W02Y + (3*TS))
		love.graphics.print({{1,1,1},"Missing: "},W02X,W02Y + (4*TS))
		love.graphics.print({{1,1,1},"Condition: "},W02X,W02Y + (5*TS))
	end)
	
	MainWindow.fore:put(function()
		love.graphics.setColor({0,0,0})
		love.graphics.line(W01X,W01Y,W01X + W01W,W01Y)
		love.graphics.line(W01X,W01Y,W01X,W01Y + W01H)
		love.graphics.line(W02X,W02Y,W02X + W02W,W02Y)
		love.graphics.line(W02X,W02Y,W02X,W02Y + W02H)
		love.graphics.setColor({1,1,1})
		love.graphics.line(W01X + W01W,W01Y,W01X + W01W,W01Y + W01H)
		love.graphics.line(W01X,W01Y + W01H,W01X + W01W,W01Y + W01H)
		love.graphics.line(W02X + W02W,W02Y,W02X + W02W,W02Y + W02H)
		love.graphics.line(W02X,W02Y + W02H,W02X + W02W,W02Y + W02H)
	end)
	
	MainWindow.fore:put(function()
		love.graphics.setColor({W01R,W01G,W01B})
		love.graphics.rectangle("fill",W01X,W01Y,W01W,W01H)
		love.graphics.setColor({W02R,W02G,W02B})
		love.graphics.rectangle("fill",W02X,W02Y,W02W,W02H)
		love.graphics.setColor({1,1,1})
	end)
end

function overview_key(key)
	
end

function viewing(dt)
	
end

function viewing_text(t)
	
end

function viewing_key(key)
	
end

UPDATE = {
	["Loading"] = loading,
	["Overview"] = overview,
	["Viewing"] = viewing,
}
TEXTINPUT = {
	["New_Values"] = new_values,
	["Viewing"] = viewing_text,
}
KEYPRESSED = {
	["New_Keys"] = new_keys,
	["Overview"] = overview_key,
	["Viewing"] = viewing_key,
}

function love.load()
	TASK = "Loading"
	love.keyboard.setKeyRepeat(true)
	for i,v in pairs(ldb) do
		print(i,tostring(v))
	end
	
	love.graphics.setBackgroundColor(BR,BG,BB)
	font.newFont('main','/Fonts/W95FA.otf',TS)
	love.graphics.setFont(font.getFont('main'))
	
	MainWindow = Window.new()
	
	if (ldb.db_exists(PATH) == 0) then
		ldb.new_db(PATH)
	end
end

function love.update(dt)
	local f = UPDATE[TASK]
	if f then f(dt) else 
		
	end
end

function love.textinput(t)
	local f = TEXTINPUT[TASK]
	if f then f(t) end
end

function love.keypressed(key)
	local f = KEYPRESSED[TASK]
	if f then f(key) end
end

function love.draw()
	MainWindow.back:put(function()
		love.graphics.line(WinX,WinY,WinX + WinW,WinY)
		love.graphics.line(WinX,WinY,WinX,WinY + WinH)
		love.graphics.line(Bt1X,Bt1Y,Bt1X + Bt1W,Bt1Y)
		love.graphics.line(Bt1X,Bt1Y,Bt1X,Bt1Y + Bt1H)
		love.graphics.line(Bt2X,Bt2Y,Bt2X + Bt2W,Bt2Y)
		love.graphics.line(Bt2X,Bt2Y,Bt2X,Bt2Y + Bt2H)
		love.graphics.line(Bt3X,Bt3Y,Bt3X + Bt3W,Bt3Y)
		love.graphics.line(Bt3X,Bt3Y,Bt3X,Bt3Y + Bt3H)
		love.graphics.setColor({0,0,0})
		love.graphics.line(WinX + WinW,WinY,WinX + WinW,WinY + WinH)
		love.graphics.line(WinX,WinY + WinH,WinX + WinW,WinY + WinH)
		love.graphics.line(Bt1X + Bt1W,Bt1Y,Bt1X + Bt1W,Bt1Y + Bt1H)
		love.graphics.line(Bt1X,Bt1Y + Bt1H,Bt1X + Bt1W,Bt1Y + Bt1H)
		love.graphics.line(Bt2X + Bt2W,Bt2Y,Bt2X + Bt2W,Bt2Y + Bt2H)
		love.graphics.line(Bt2X,Bt2Y + Bt2H,Bt2X + Bt2W,Bt2Y + Bt2H)
		love.graphics.line(Bt3X + Bt3W,Bt3Y,Bt3X + Bt3W,Bt3Y + Bt3H)
		love.graphics.line(Bt3X,Bt3Y + Bt3H,Bt3X + Bt3W,Bt3Y + Bt3H)
		love.graphics.setColor({1,1,1})
	end)
	
	MainWindow.back:put(function()
		love.graphics.setColor({WinR,WinG,WinB})
		love.graphics.rectangle("fill",WinX,WinY,WinW,WinH)
		
		love.graphics.setColor({TabR,TabG,TabB})
		love.graphics.rectangle("fill",TabX,TabY,TabW,TabH)
		
		love.graphics.setColor({WinR,WinG,WinB})
		love.graphics.rectangle("fill",Bt1X,Bt1Y,Bt1W,Bt1H)
		love.graphics.rectangle("fill",Bt2X,Bt2Y,Bt2W,Bt2H)
		love.graphics.rectangle("fill",Bt3X,Bt3Y,Bt3W,Bt3H)
		
		love.graphics.setColor({0,0,0})
		love.graphics.print("-",Bt1X + (TS/8),Bt1Y)
		love.graphics.print("#",Bt2X + (TS/8),Bt2Y)
		love.graphics.print("x",Bt3X + (TS/8),Bt3Y)
		
		love.graphics.setColor({1,1,1})
		
		local TOF = (TabH - TS)/2
		love.graphics.print("<o>    Personal Record Keeper v"..tostring(VERSION).."    |    "..(TASK),TabX + TOF,TabY + TOF)
	end)
	
	MainWindow.mid:put(function()
		love.graphics.setColor({0,0,0})
		love.graphics.line(SwdX,SwdY,SwdX + SwdW,SwdY)
		love.graphics.line(SwdX,SwdY,SwdX,SwdY + SwdH)
		love.graphics.setColor({1,1,1})
		love.graphics.line(SwdX + SwdW,SwdY,SwdX + SwdW,SwdY + SwdH)
		love.graphics.line(SwdX,SwdY + SwdH,SwdX + SwdW,SwdY + SwdH)
	end)
	
	MainWindow.mid:put(function()
		love.graphics.setColor({SwdR,SwdG,SwdB})
		love.graphics.rectangle("fill",SwdX,SwdY,SwdW,SwdH)
		love.graphics.setColor({1,1,1})
	end)
	
	MainWindow()
end
