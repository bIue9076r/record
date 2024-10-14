SubWindow = {}
SubWindow.items = {}

function SubWindow.new(i)
	tbl = {
		items = {i or nil}
	}
	
	mt = {
		__index = SubWindow,
		__call = SubWindow.draw,
	}
	
	return setmetatable(tbl,mt)
end

function SubWindow:put(i)
	self.items[#self.items + 1] = i
end

function SubWindow:pop()
	r = self.items[#self.items]
	self.items[#self.items] = nil
	return r
end

function SubWindow:draw()
	l = #self.items
	for i = 1,l do
		v = self:pop()
		v()
	end
end

Window = {}
Window.fore = SubWindow.new()
Window.mid = SubWindow.new()
Window.back = SubWindow.new()

Window.Subs = {}
Window.SubsIndex = 0

function Window.new(l)
	tbl = {
		fore = SubWindow.new(),
		mid = SubWindow.new(),
		back = SubWindow.new(),
		
		Subs = {},
		SubsIndex = 0,
	}
	
	if l then
		for i = 1,l do
			Window.newlevel(tbl)
		end
	end
	
	mt = {
		__call = Window.draw,
		__index = Window,
	}
	
	return setmetatable(tbl,mt)
end

function Window:draw()
	if self.SubsIndex < 1 then
		self.back:draw()
		self.mid:draw()
		self.fore:draw()
	else
		for i = SubsIndex,1,-1 do
			self.Subs[i]:draw()
		end
	end
end

function Window:newLevel()
	self.SubsIndex = self.SubsIndex + 1
	self.Subs[self.SubsIndex] = SubWindow.new()
end
