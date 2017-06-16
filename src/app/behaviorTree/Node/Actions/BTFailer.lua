local super = game.BTAction
local BTFailer = class("BTFailer", super)

function BTFailer:ctor( ... )
	self:init(...)
end

function BTFailer:execute( ... )
	print("BTFailer execute")
	return BTStatus.ST_FALSE
end

function BTFailer:_evaluate( ... )
	return true
end

return BTFailer