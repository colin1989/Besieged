local super = game.BTNode
local BTCondition = class("BTCondition", super)

BTCondition.method = nil

function BTCondition:ctor( ... )
	print("asdasdas ", ...)
	self:init(...)
	self.method = nil
end

function BTCondition:load( tree, id )
	super.load(self, tree, id)
	print("BTCondition load ")
	
end

function BTCondition:enter( ... )
end

function BTCondition:exit( ... )
	
end

function BTCondition:tick( ... )
	return super.tick(self)
end

function BTCondition:execute( ... )
	print("BTCondition execute")
	super.execute(self)
	print("BTCondition status ", self.status)
	return self.status
end

function BTCondition:_evaluate( ... )
	return true
end

return BTCondition