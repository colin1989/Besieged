--
-- Author: Your Name
-- Date: 2017-07-05 13:59:53
--
local StoreSystem = class("StoreSystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function StoreSystem:execute( ... )
	local entities = EntityManager:getEntitiesIntersection("StoreComponent")
	for _, entity in pairs(entities) do
		local storeComponent = EntityManager:getComponent("StoreComponent", entity)
		if storeComponent.save then
			storeComponent.save = false
			EntityManager:getGridManager():addEntity(entity, storeComponent.storeType)
		end
		if storeComponent.update then
			storeComponent.update = false
			EntityManager:getGridManager():updateEntity(entity, storeComponent.storeType)
		end
		if storeComponent.remove then
			storeComponent.remove = false
			EntityManager:getGridManager():removeEntity(entity, storeComponent.storeType)
		end
	end
end

return StoreSystem