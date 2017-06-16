local super = game.BTNode
local BTAction = class("BTAction", super)

function BTAction:ctor( ... )
	self:init(...)
end

function BTAction:load( tree, id )
	super.load(self, tree, id)
	print("BTAction load")
	
end

function BTAction:enter( ... )
end

function BTAction:exit( ... )
	
end

function BTAction:tick( ... )
	return super.tick(self)
end

function BTAction:execute( ... )
	print("BTAction execute")
	super.execute(self)
	return self.status
end

function BTAction:_evaluate( ... )
	return true
end

return BTAction