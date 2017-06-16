local super = game.BTNode
local BTConditionIsHaveEnemy = class("BTConditionIsHaveEnemy", super)

function BTConditionIsHaveEnemy:ctor( ... )
	self:init(...)
end

function BTConditionIsHaveEnemy:execute( ... )
	print("BTConditionIsHaveEnemy execute")
	super.execute(self)
	print("BTConditionIsHaveEnemy status ", self.status)
	return self.status
end

function BTConditionIsHaveEnemy:_evaluate( ... )
	return true
end

return BTConditionIsHaveEnemy