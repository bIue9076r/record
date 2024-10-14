font = {}

function font.newFont(n,p,s)
	Font = love.graphics.newFont(p,s)
	font[n] = Font
end

function font.getFont(n)
	n = n or ''
	if font[n] == nil then
		return love.graphics.newFont() -- blank font
	end
	return font[n]
end
