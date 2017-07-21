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
			local transformComponent = EntityManager:getComponent("TransformComponent", entity)
			local dbComponent = EntityManager:getComponent("DBComponent", entity)
			local stateComponent = EntityManager:getComponent("StateComponent", entity)
			if stateComponent.buildState == U_ST_WAITING then
				return
			end

			local vertex = cc.p(transformComponent.vx, transformComponent.vy)
			local isEmpty = EntityManager:getGridManager():isAreaEmpty(vertex.x, vertex.y, dbComponent.db.row, entity)
			if not isEmpty then
				local realVertex = EntityManager:getGridManager():getVertex(entity)
				vertex.x = realVertex.x
				vertex.y = realVertex.y
				local substrateComponent = EntityManager:getComponent("RenderSubstrateComponent", entity)
				if substrateComponent then
					substrateComponent.vx = vertex.x
					substrateComponent.vy = vertex.y
					substrateComponent.grids = game.MapUtils.getEntityPoints(vertex, dbComponent.db.row)
				end
				stateComponent.invalidPosition = false
			end

			local uiComponent = EntityManager:getComponent("UIOperateComponent", entity)
			if uiComponent and uiComponent.visible then
				uiComponent:destroy()
			end
			stateComponent.selected = false
			singletonCurEntity.preEntity = nil
		end

		if singletonCurEntity.entity then
			local entity = singletonCurEntity.entity
			local stateComponent = EntityManager:getComponent("StateComponent", entity)
			stateComponent.selected = true

			local uiComponent = EntityManager:getComponent("UIOperateComponent", entity)
			if uiComponent and stateComponent.buildState ~= U_ST_WAITING then
				uiComponent.visible = true
			end
		end
	end
end

return CurrentEntitySystem