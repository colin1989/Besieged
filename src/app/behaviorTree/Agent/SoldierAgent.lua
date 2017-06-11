local super = game.BaseAgent
local SoldierAgent = class("SoldierAgent", super)

-- function SoldierAgent:ctor( ... )
-- end

function SoldierAgent:load( treename )
	super.load(self, treename)
end

function SoldierAgent:activate( ... )
	super.activate(self)
end

function SoldierAgent:clear( ... )
	super.clear(self)
end

function SoldierAgent:update( ... )
	super.update(self, ...)
end

local testCount = 0
function SoldierAgent:isHaveEnemy( ... )
	print("SoldierAgent:isHaveEnemy")
	testCount = testCount + 1
	if testCount < 5 then
		print("return true")
		return true
	end
	if testCount == 10 then
		testCount = 0
	end
	print("return true")
	return true
end

function SoldierAgent:isCanAttack( ... )
	if testCount >= 8 then
		return true
	end
	return false
end

function SoldierAgent:idle( ... )
	print("SoldierAgent idle")
end

function SoldierAgent:walk( ... )
	print("SoldierAgent walk")
end

function SoldierAgent:attack( ... )
	print("SoldierAgent attack")
end

return SoldierAgent