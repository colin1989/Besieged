--
-- Author: Your Name
-- Date: 2017-06-28 11:16:44
-- 绘制系统，强制关心"PositionComponent", "RenderComponent"，并对所有RenderXxx组件关心
--
local RenderSystem = class("RenderSystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function RenderSystem:execute( ... )
	-- print("RenderSystem")
	local entities = EntityManager:getEntitiesIntersection("PositionComponent", "RenderComponent")
	-- print("entites", #entities)
	for _, entity in pairs(entities) do
		local positionComponent = EntityManager:getComponent("PositionComponent", entity)
		local renderComponent = EntityManager:getComponent("RenderComponent", entity)
		local dbComponent = EntityManager:getDBComponent(entity)

		renderComponent.container:setAnchorPoint(cc.p(positionComponent.ax, positionComponent.ay))
		renderComponent.container:setPosition(cc.p(positionComponent.x, positionComponent.y))
		if renderComponent.isStatic then
			if not renderComponent.sprite then
				renderComponent.sprite = display.newSprite(renderComponent.assetName, 0, 0)	
				local logic_height = dbComponent.db.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
			    local anchorY = renderComponent.sprite:getContentSize().height > logic_height and (logic_height / 2 / renderComponent.sprite:getContentSize().height) or 0.5
			    renderComponent.sprite:setAnchorPoint(cc.p(0.5, anchorY))
			    renderComponent.sprite:addTo(renderComponent.container)
			end
			
			if renderComponent.animate then
				renderComponent.animate:removeSelf()
				renderComponent.animate = nil
			end
		end

		-- substrate
		local substrateComponent = EntityManager:getComponent("RenderSubstrateComponent", entity)
		if substrateComponent and substrateComponent.active then
			for _,v in pairs(substrateComponent.grids) do
				if game.MapUtils.isIndexValid(v) then
					game.MapManager.getMap():getLayer("ground"):setTileGID(substrateComponent.GID, v)
				end
			end
		end

		-- place button
		local placeBtnComponent = EntityManager:getComponent("RenderPlaceBtnComponent", entity)
		if placeBtnComponent and placeBtnComponent.active then
			if not placeBtnComponent.layout then
				placeBtnComponent.layout = game.PlaceBtnView.createLayout(entity)--:move(0, 0)
				renderComponent.container:addChild(placeBtnComponent.layout)
			end
		end
	end
end

function RenderSystem:exit( ... )
	local entities = EntityManager:getEntitiesIntersection("PositionComponent", "RenderComponent")
	for _, entity in pairs(entities) do
		local positionComponent = EntityManager:getComponent("PositionComponent", entity)
		local renderComponent = EntityManager:getComponent("RenderComponent", entity)
		if renderComponent.container then
			renderComponent.container:removeSelf()
			renderComponent.container = nil
		end
	end
end

return RenderSystem