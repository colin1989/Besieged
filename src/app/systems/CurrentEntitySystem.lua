--
-- Author: Your Name
-- Date: 2017-07-05 17:15:59
--
local CurrentEntitySystem = class("CurrentEntitySystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function CurrentEntitySystem:execute( ... )
	local singletonCurEntity = game.SingletonCurrentEntityComponent:getInstance()
	
	if singletonCurEntity.entity ~= singletonCurEntity.preEntity then
		-- 取消操作当前的entity
		if singletonCurEntity.preEntity then
			local entity = singletonCurEntity.preEntity
			local vertexComponent = EntityManager:getComponent("VertexComponent", entity)
			local dbComponent = EntityManager:getComponent("DBComponent", entity)
			local stateComponent = EntityManager:getComponent("StateComponent", entity)

			local isEmpty = EntityManager:getGridManager():isAreaEmpty(vertexComponent.x, vertexComponent.y, dbComponent.db.row, entity)
			if not isEmpty then
				local realVertex = EntityManager:getGridManager():getVertex(entity)
				vertexComponent.x = realVertex.x
				vertexComponent.y = realVertex.y
				local substrateComponent = EntityManager:getComponent("RenderSubstrateComponent", entity)
				if substrateComponent then
					substrateComponent.vx = vertexComponent.x
					substrateComponent.vy = vertexComponent.y
					substrateComponent.grids = game.MapUtils.getEntityPoints(vertexComponent, dbComponent.db.row)
				end
				stateComponent.invalidPosition = false
			end
			stateComponent.selected = false
			singletonCurEntity.preEntity = nil
		end

		if singletonCurEntity.entity then
			local entity = singletonCurEntity.entity
			-- local vertexComponent = EntityManager:getComponent("VertexComponent", entity)
			-- local dbComponent = EntityManager:getComponent("DBComponent", entity)
			local stateComponent = EntityManager:getComponent("StateComponent", entity)

			stateComponent.selected = true
		end
	end
end

return CurrentEntitySystem