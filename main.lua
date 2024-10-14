-- Love Graphical User Interface
jit.off()
love.graphics.setDefaultFilter("nearest", "nearest")
require("Modules/image")
require("Modules/Fonts")
require("Modules/file")
require("Modules/window")
require("Modules/ticker")
require("ldb")

focus = nil
instring = ""

BR = 0
BG = 0x80/0xFF
BB = 0x7F/0xFF
TS = 14

WinX = 15
WinY = 15
WinW = 800 - 30
WinH = 600 - 30
WinR = 0xD2/0xFF
WinG = 0xD4/0xFF
WinB = 0xD4/0xFF

function love.load()
	love.keyboard.setKeyRepeat(true)
	for i,v in pairs(ldb) do
		print(i,tostring(v))
	end
	
	love.graphics.setBackgroundColor(BR,BG,BB)
	font.newFont('main','/Fonts/W95FA.otf',TS)
	love.graphics.setFont(font.getFont('main'))
	
	MainWindow = Window.new()
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
		love.graphics.setColor({1,1,1})
	end)
	
	MainWindow.mid:put(function()
		love.graphics.line(WinX,WinY,WinX + WinW,WinY)
		love.graphics.line(WinX,WinY,WinX,WinY + WinH)
		love.graphics.setColor({0,0,0})
		love.graphics.line(WinX + WinW,WinY,WinX + WinW,WinY + WinH)
		love.graphics.line(WinX,WinY + WinH,WinX + WinW,WinY + WinH)
		love.graphics.setColor({1,1,1})
	end)
	
	MainWindow()
end
