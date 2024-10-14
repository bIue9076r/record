image = {}

function image.newImage(n,p)
	Image = love.graphics.newImage(p)
	image[n] = Image
end

function image.getImage(n)
	n = n or ''
	if image[n] == nil then
		return image[1] -- replace with blank image
	end
	return image[n]
end
