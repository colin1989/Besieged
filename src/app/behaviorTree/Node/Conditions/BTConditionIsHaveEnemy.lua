local super = game.BTNode
local BTConditionIsHaveEnemy = class("BTConditionIsHaveEnemy", super)

function BTConditionIsHaveEnemy:ctor( ... )
	self:init(...)
end

function BTConditionIsHaveEnemy:execute( ... )
	super.execute(self)
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTConditionIsHaveEnemy:_evaluate( ... )
	return true
end

return BTConditionIsHaveEnemy