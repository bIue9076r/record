function love.conf(t)
	t.version = "11.3"
	t.identity = "RECKEEP"
	t.window.title = "Record Keeper"
	t.window.width = 800
	t.window.height = 600
	t.window.fullscreen = false
	t.window.resizeable = false
	t.modules.keyboard = true
	t.modules.mouse = true
	t.modules.audio = true
	t.modules.font = true
	t.modules.timer = true
	t.modules.window = true
	t.modules.image = true
end