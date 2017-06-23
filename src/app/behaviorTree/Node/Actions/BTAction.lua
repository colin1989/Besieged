local super = game.BTNode
local BTAction = class("BTAction", super)

function BTAction:ctor( ... )
	self:init(...)
end

function BTAction:load( tree, id )
	super.load(self, tree, id)	
end

function BTAction:enter( ... )
end

function BTAction:exit( ... )
	
end

function BTAction:tick( ... )
	return super.tick(self)
end

function BTAction:execute( ... )
	super.execute(self)
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTAction:_evaluate( ... )
	return true
end

return BTAction