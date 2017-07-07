--
-- Author: Your Name
-- Date: 2017-07-06 16:45:25
--
local AISystem = class("AISystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function AISystem:execute( ... )
	local entities = EntityManager:getEntitiesIntersection("AIComponent")
	for _, entity in pairs(entities) do
		local aiComponent = EntityManager:getComponent("AIComponent", entity)
		if aiComponent.active then
			if not aiComponent.root then
				aiComponent.root = game.BTFactory.createTree(entity, aiComponent.treeName)
				aiComponent.root:activate()
			end	
			aiComponent.root:tick()
		end
		
	end
end

return AISystem