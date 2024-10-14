-- Ticker

ticker = {}
ticker.ticker = {
	i = 0,
}
ticker.flags = {}

function ticker.new()
	tbl = {
		ticker = {
			i = 0,
		},
		flags = {},
	}
	
	mt = {
		__index = ticker,
		__call = ticker.inc,
	}
	
	return setmetatable(tbl,mt)
end

function ticker:flagSet(i,v)
	self.flags[i] = v
end

function ticker:flagGet(i)
	return self.flags[i]
end

function ticker:reset()
	self.ticker.i = 0
end

function ticker:set(v)
	self.ticker.i = v
end

function ticker:get()
	return self.ticker.i
end

function ticker:inc()
	self.ticker.i = self.ticker.i + 1
end

sticker = {}
sticker.t = ticker.new()
sticker.s = ""
sticker.tr = 1

function sticker.new(s,tr)
	tbl = {
		t = ticker.new(),
		s = s or "", tr = tr or 1
	}

	mt = {
		__index = sticker,
		__call = sticker.print,
	}

	return setmetatable(tbl,mt)
end

function sticker:print()
	s = self.s
	l = #s
	lt = l*(self.tr)
	t = self.t:get()
	n = floor((t * (l/lt)) + 1)
	ub = min(l,n)
	r = sub(s,1,ub)
	if (n < l) then
		self.t:inc()
	end
	return r
end

function sticker:reset()
	self.t:reset()
end
