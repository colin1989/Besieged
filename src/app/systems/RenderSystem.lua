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
		local row = dbComponent.db.row

		renderComponent.container:setAnchorPoint(cc.p(positionComponent.ax, positionComponent.ay))
		renderComponent.container:setPosition(cc.p(positionComponent.x, positionComponent.y))
		if renderComponent.isStatic then
			if not renderComponent.sprite then
				renderComponent.sprite = display.newSprite(renderComponent.assetName, 0, 0)	
				local logic_height = dbComponent.db.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
			    local anchorY = renderComponent.sprite:getContentSize().height > logic_height and (logic_height / 2 / renderComponent.sprite:getContentSize().height) or 0.5
			    renderComponent.sprite:setAnchorPoint(cc.p(0.5, anchorY))
			    renderComponent.container:addChild(renderComponent.sprite, 1)
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
					game.MapManager.getMap():getLayer("ground"):setTileGID(dbComponent.db.groundGID, v)
				end
			end
		end

		-- place button
		local placeBtnComponent = EntityManager:getComponent("RenderPlaceBtnComponent", entity)
		if placeBtnComponent and placeBtnComponent.active then
			if not placeBtnComponent.container then
				placeBtnComponent.container = game.PlaceBtnView.createLayout(entity)--:move(0, 0)
				renderComponent.container:addChild(placeBtnComponent.container, 2)
			end
		end

		-- color board
		local colorBoardComponent = EntityManager:getComponent("RenderColorBoardComponent", entity)
		if colorBoardComponent and colorBoardComponent.active then
			local invalidPosition = not EntityManager:getComponentMember("StateComponent", "invalidPosition", entity)
			local colorBoardComponent = EntityManager:getComponent("RenderColorBoardComponent", entity)
			if colorBoardComponent and colorBoardComponent.bool ~= invalidPosition then
				colorBoardComponent.bool = invalidPosition
				colorBoardComponent:destroy()
			end

			if not colorBoardComponent.container then
				colorBoardComponent.container = game.MapUtils.createColorBoard(row, colorBoardComponent.bool)
				renderComponent.container:addChild(colorBoardComponent.container, 0)
			end
			renderComponent.container:setLocalZOrder(2)
		else
			renderComponent.container:setLocalZOrder(1)
		end

		-- arrow
		local arrowComponent = EntityManager:getComponent("RenderArrowComponent", entity)
		if arrowComponent and arrowComponent.active then
			if not arrowComponent.container then
				arrowComponent.container = cc.SpriteBatchNode:create("map/UI_Building.pvr.ccz")
				cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou1.png")
					:align(cc.p(0,0), game.g_mapTileSize.width/4 * row, game.g_mapTileSize.height/4 * row)
					:addTo(arrowComponent.container)
				cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou2.png")
					:align(cc.p(1,1), -game.g_mapTileSize.width/4 * row, -game.g_mapTileSize.height/4 * row)
					:addTo(arrowComponent.container)
				cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou3.png")
					:align(cc.p(1,0), -game.g_mapTileSize.width/4 * row, game.g_mapTileSize.height/4 * row)
					:addTo(arrowComponent.container)
				cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou4.png")
					:align(cc.p(0,1), game.g_mapTileSize.width/4 * row, -game.g_mapTileSize.height/4 * row)
					:addTo(arrowComponent.container)
				renderComponent.container:addChild(arrowComponent.container, 1)
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