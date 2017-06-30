--
-- Author: Your Name
-- Date: 2017-06-30 14:18:33
-- 处理可建造的entity的状态
--
local BuildingStateSystem = class("BuildingStateSystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function BuildingStateSystem:enter( ... )
	-- body
end

function BuildingStateSystem:execute( ... )
	-- print("BuildingStateSystem")
	local entities = EntityManager:getEntitiesIntersection("BuildStateComponent")
	for _, entity in pairs(entities) do
		local bstateComponent = EntityManager:getComponent("BuildStateComponent", entity)
		if bstateComponent.state == U_ST_WAITING then
			-- 添加放置按钮的component
			local placeBtnCom = EntityManager:getComponent("RenderPlaceBtnComponent", entity)
			if not placeBtnCom then
				placeBtnCom = game.ComponentFactory.createRenderPlaceBtn()
				EntityManager:addComponent(placeBtnCom, entity)
			end
			-- 禁用底座
			local substrateCom = EntityManager:getComponent("RenderSubstrateComponent", entity)
			if substrateCom then
				substrateCom.active = false
			end
			

		elseif bstateComponent.state == U_ST_BUILDING then
			-- 添加建造进度条
		else
			EntityManager:removeComponent("RenderPlaceBtnComponent", entity)
			local substrateCom = EntityManager:getComponent("RenderSubstrateComponent", entity)
			if substrateCom then
				substrateCom.active = true
			end
		end
	end
end

function BuildingStateSystem:exit( ... )
	-- body
end

return BuildingStateSystem