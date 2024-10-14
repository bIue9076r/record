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

function love.load()
	love.keyboard.setKeyRepeat(true)
	for i,v in pairs(ldb) do
		print(i,tostring(v))
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
	love.graphics.setColor({0.5,0.5,0.5})
	love.graphics.rectangle("fill",0,0,250,300)
	love.graphics.setColor({1,1,1})
	love.graphics.rectangle("fill",50,50,100,50)
	love.graphics.print({{0,0,0},instring},50,50)
end
