--
-- Author: Your Name
-- Date: 2017-07-06 15:55:25
--
local AttributeSystem = class("AttributeSystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function AttributeSystem:execute( ... )
	local entities = EntityManager:getEntitiesIntersection("AttributeComponent")
	for _, entity in pairs(entities) do
		local operateAttrComponent = EntityManager:getComponent("AttributeComponent", entity)
		
	end
end

return AttributeSystem