-- Love Graphical User Interface
jit.off()
love.graphics.setDefaultFilter("nearest", "nearest")
require("Modules/image")
require("Modules/Fonts")
require("Modules/file")
require("Modules/window")
require("Modules/ticker")
require("ldb")

VERSION = 0
focus = nil
instring = ""

BR = 0
BG = 0x80/0xFF
BB = 0x7F/0xFF
TS = 15

WinX = 15
WinY = 15
WinW = 800 - 30
WinH = 600 - 30
WinR = 0xD2/0xFF
WinG = 0xD4/0xFF
WinB = 0xD4/0xFF

TabX = WinX + 5
TabY = WinY + 5
TabW = WinW - 10
TabH = 20
TabR = 0x2A/0xFF
TabG = 0x2A/0xFF
TabB = 0x80/0xFF

Bt1X = (TabX + TabW) - 3*(TS + 5)
Bt1Y = TabY + ((TabH - TS)/2)
Bt1W = TS
Bt1H = TS

Bt2X = (TabX + TabW) - 2*(TS + 5)
Bt2Y = TabY + ((TabH - TS)/2)
Bt2W = TS
Bt2H = TS

Bt3X = (TabX + TabW) - 1*(TS + 5)
Bt3Y = TabY + ((TabH - TS)/2)
Bt3W = TS
Bt3H = TS

function love.load()
	love.keyboard.setKeyRepeat(true)
	for i,v in pairs(ldb) do
		print(i,tostring(v))
	end
	
	love.graphics.setBackgroundColor(BR,BG,BB)
	font.newFont('main','/Fonts/W95FA.otf',TS)
	love.graphics.setFont(font.getFont('main'))
	
	MainWindow = Window.new()
	
	if (ldb.db_exists("./Records.ldb") == 0) then
		ldb.new_db("./Records.ldb")
	end
end

function love.update()
	
end

function love.textinput(t)
	
end

function love.keypressed(key)
	
end

function love.draw()
	love.graphics.print("Hello World",250,300)
	
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
		love.graphics.print("<o>    Personal Record Keeper v"..tostring(VERSION).."    |    "..("Standby"),TabX + TOF,TabY + TOF)
	end)
	
	MainWindow.mid:put(function()
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
	
	MainWindow.fore:put(function()
		
	end)
	
	MainWindow.fore:put(function()
		love.graphics.setColor({0,0,0})
		
		love.graphics.setColor({1,1,1})
	end)
	
	MainWindow()
end
