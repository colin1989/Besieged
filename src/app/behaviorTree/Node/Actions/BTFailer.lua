local super = game.BTAction
local BTFailer = class("BTFailer", super)

function BTFailer:ctor( ... )
	self:init(...)
end

function BTFailer:load( tree, id )
	super.load(self, tree, id)
	print("BTFailer load")
	
end

function BTFailer:enter( ... )
end

function BTFailer:exit( ... )
	
end

function BTFailer:tick( ... )
	return super.tick(self)
end

function BTFailer:execute( ... )
	print("BTFailer execute")
	return BTStatus.ST_FALSE
end

function BTFailer:_evaluate( ... )
	return true
end

return BTFailer