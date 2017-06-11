local super = game.BTAction
local BTSucceeder = class("BTSucceeder", super)

function BTSucceeder:ctor( ... )
	self:init(...)
end

function BTSucceeder:load( tree, id )
	super.load(self, tree, id)
	print("BTSucceeder load")
	
end

function BTSucceeder:enter( ... )
end

function BTSucceeder:exit( ... )
	
end

function BTSucceeder:tick( ... )
	return super.tick(self)
end

function BTSucceeder:execute( ... )
	print("BTSucceeder execute")
	return BTStatus.ST_TRUE
end

function BTSucceeder:_evaluate( ... )
	return true
end

return BTSucceeder