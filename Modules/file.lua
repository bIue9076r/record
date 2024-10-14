-- File Handler
File = {}
File.path = nil
File.file = nil

function File.new(p)
	local tbl = {
		path = p,
		file = nil,
	}
	
	local mt = {
		__index = File,
	}
	
	return setmetatable(tbl,mt)
end

function File:Exists()
	return love.filesystem.getInfo(self.path)
end

function File:Log(...)
	self.file = love.filesystem.newFile(self.path)
	self.file:open("a")
	self.file:write("[Log]: ")
	for i,v in pairs({...}) do
		self.file:write(tostring(v))
	end
	self.file:write("\n")
	self.file:close()
end

function File:Warn(...)
	self.file = love.filesystem.newFile(self.path)
	self.file:open("a")
	self.file:write("[Warning]: ")
	for i,v in pairs({...}) do
		self.file:write(tostring(v))
	end
	self.file:write("\n")
	self.file:close()
end

function File:Error(...)
	self.file = love.filesystem.newFile(self.path)
	self.file:open("a")
	self.file:write("[Error]: ")
	for i,v in pairs({...}) do
		self.file:write(tostring(v))
	end
	self.file:write("\n")
	self.file:close()
end
