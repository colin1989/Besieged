local super = game.BTNode
local BTCondition = class("BTCondition", super)

function BTCondition:ctor( ... )
	self:init(...)
end

function BTCondition:execute( ... )
	super.execute(self)
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTCondition:_evaluate( ... )
	return true
end

return BTCondition