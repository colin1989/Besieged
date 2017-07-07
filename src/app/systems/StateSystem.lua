--
-- Author: Your Name
-- Date: 2017-06-30 14:18:33
-- 处理可建造的entity的状态
--
local StateSystem = class("StateSystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function StateSystem:enter( ... )
	-- body
end

function StateSystem:execute( ... )
	-- print("StateSystem")
	local entities = EntityManager:getEntitiesIntersection("StateComponent")
	for _, entity in pairs(entities) do
		local stateComponent = EntityManager:getComponent("StateComponent", entity)
		-- print(stateComponent.buildState, stateComponent.selected, stateComponent.pressed)

		-- substrate
		-- 已建造 并且 没按下 并且 位置合法
		if stateComponent.buildState ~= U_ST_WAITING and stateComponent.pressed == false and stateComponent.invalidPosition == false then
			EntityManager:setComponentEnabled("RenderSubstrateComponent", entity, true)
		else
			EntityManager:setComponentEnabled("RenderSubstrateComponent", entity, false)
		end
		-- arrow
		-- 待建造 或 选中 或 按下
		if stateComponent.buildState == U_ST_WAITING or stateComponent.selected or stateComponent.pressed then
			EntityManager:setComponentEnabled("RenderArrowComponent", entity, true)
		else
			EntityManager:setComponentEnabled("RenderArrowComponent", entity, false)
		end
		-- place button
		-- 待建造
		if stateComponent.buildState == U_ST_WAITING then
			EntityManager:setComponentEnabled("RenderPlaceBtnComponent", entity, true)
		else
			EntityManager:setComponentEnabled("RenderPlaceBtnComponent", entity, false)
		end
		-- color board
		-- 待建造 或 按下 或 不合法的位置
		if stateComponent.buildState == U_ST_WAITING or stateComponent.pressed or stateComponent.invalidPosition then
			EntityManager:setComponentEnabled("RenderColorBoardComponent", entity, true)
		else
			EntityManager:setComponentEnabled("RenderColorBoardComponent", entity, false)
		end
	end
end

function StateSystem:exit( ... )
	-- body
end

return StateSystem