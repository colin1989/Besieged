local super = game.BTNode
local BTCondition = class("BTCondition", super)

function BTCondition:ctor( ... )
	print("asdasdas ", ...)
	self:init(...)
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