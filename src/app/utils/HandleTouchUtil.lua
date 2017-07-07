--
-- Author: Your Name
-- Date: 2017-07-03 11:21:26
-- 处理entity、zoom layer的移动和放缩
-- 为了触摸的响应及时性而不做成system
--
local HandleTouchUtil = {}
local EntityManager = game.EntityManager:getInstance()

function HandleTouchUtil.handleEntity( touchComponent )
	if not touchComponent.state then
		return false
	end
	if table.nums(touchComponent.touches) > 1 then
		return false
	end
	if touchComponent.state == "began" or touchComponent.state == "moved" then
		if touchComponent.nums > 1 then
			return false
		end
	elseif touchComponent.state == "ended" then
		if touchComponent.nums > 0 then
			return false
		end
	end

	local touch = table.values(touchComponent.touches)[1]
	
	-- 屏幕坐标转map坐标
	local maptouch = game.MapUtils.screen_2_map(game.MapManager:getMap(), touch)
	-- map坐标转格子坐标
	local tiletouch = game.MapUtils.map_2_tile(game.MapManager:getMap(), maptouch)
	local touchedEntity = game.GridManager:isTouchEntity(tiletouch.x, tiletouch.y)
	-- 当非法位置 或者 waiting状态时
	-- isTouchEntity会获取不到当前entity
	local singletonCurEntity = game.SingletonCurrentEntityComponent:getInstance()
	if singletonCurEntity.entity and singletonCurEntity.entity ~= touchedEntity then
		local vertexComponent = EntityManager:getComponent("VertexComponent", singletonCurEntity.entity)
		local dbComponent = EntityManager:getComponent("DBComponent", singletonCurEntity.entity)
		if game.MapUtils.isInBound(tiletouch, vertexComponent, dbComponent.db.row) then
			touchedEntity = singletonCurEntity.entity
		end
	end

	-- 切换当前操作的entity
	if touchComponent.state == "ended" then
		if not touchComponent.isMoved then
			singletonCurEntity:switch(touchedEntity)
		end
	end

	local returnValue = false
	local entities = EntityManager:getEntitiesIntersection("SingletonTouchComponent", "VertexComponent", "StateComponent")
	for _, entity in pairs(entities) do
		local vertexComponent = EntityManager:getComponent("VertexComponent", entity)
		local dbComponent = EntityManager:getComponent("DBComponent", entity)
		local stateComponent = EntityManager:getComponent("StateComponent", entity)
		
		if touchComponent.state == "began" then
			touchComponent.preTile = tiletouch
			if touchedEntity and touchedEntity == entity then
				if stateComponent.selected then
					stateComponent.pressed = true
					returnValue = true
				end
			end
		elseif touchComponent.state == "moved" then
			if stateComponent.pressed then
				if game.MapUtils.isIndexValid(tiletouch) and tiletouch.x ~= touchComponent.preTile.x or tiletouch.y ~= touchComponent.preTile.y  then
					local new_vertex = cc.p(vertexComponent.x + tiletouch.x - touchComponent.preTile.x, 
											vertexComponent.y + tiletouch.y - touchComponent.preTile.y)
					if game.MapUtils.isUnitValid(new_vertex, dbComponent.db.row) then
						touchComponent.preTile = tiletouch  -- 保存本次选中的index
						vertexComponent.x = new_vertex.x
						vertexComponent.y = new_vertex.y
						-- 检测位置是否合法
						stateComponent.invalidPosition = not EntityManager:getGridManager():isAreaEmpty(new_vertex.x, new_vertex.y, dbComponent.db.row, entity)
					end
				end
				returnValue = true
			end
		elseif touchComponent.state == "ended" then
			if not touchComponent.isMoved then
				returnValue = touchedEntity ~= nil
			else
				if stateComponent.pressed == true then
					-- 移动完更新substrate位置和缓存信息
					local substrateComponent = EntityManager:getComponent("RenderSubstrateComponent", entity)
					if substrateComponent then
						substrateComponent.vx = vertexComponent.x
						substrateComponent.vy = vertexComponent.y
						substrateComponent.grids = game.MapUtils.getEntityPoints(vertexComponent, dbComponent.db.row)
					end
					-- 检查位置是否可更新
					local isEmpty = EntityManager:getGridManager():isAreaEmpty(vertexComponent.x, vertexComponent.y, dbComponent.db.row, entity)
					-- 标记可更新位置
					EntityManager:setComponentMember("StoreComponent", "update", isEmpty, entity)
				end

				returnValue = true
			end
			stateComponent.pressed = false
		end
	end
	return returnValue
end

function HandleTouchUtil.handleZoomLayer( touchComponent )
	local zoomLayer = game.Layers.ZoomLayer
	if not touchComponent.state then
		return false
	end
	-- print("handleZoomLayer", table.nums(touchComponent.prePositions or {}))
	if touchComponent.nums == 1 then  -- 单点
		local touch = table.values(touchComponent.touches)[1]
		if touchComponent.state == "moved" then
			local new_position = cc.p(zoomLayer:getPositionX() + touch.x - touchComponent.prePosition.x, 
									zoomLayer:getPositionY() + touch.y - touchComponent.prePosition.y)
			zoomLayer:setPosition(HandleTouchUtil.calcZoomPosition(new_position))
		end
	elseif touchComponent.nums == 2 then  -- 多点
		local touches = table.values(touchComponent.touches)
		if touchComponent.state == "moved" then
			local curMidPosition = cc.pMidpoint(touches[1], touches[2])
			local curDistance = cc.pGetDistance(touches[1], touches[2])
			local lastMidPosition = cc.pMidpoint(touchComponent.prePositions[1], touchComponent.prePositions[2])
			local lastDistance = cc.pGetDistance(touchComponent.prePositions[1], touchComponent.prePositions[2])
			local curScale = zoomLayer:getScale()
			local scale = HandleTouchUtil.calcZoomScale(curDistance / lastDistance * curScale)
			-- 记录中点的地图坐标
			local mpoint = game.MapUtils.screen_2_map(game.MapManager.getMap(), lastMidPosition)
			-- 缩放
			zoomLayer:setScale(scale)
			-- 记录地图缩放后中点坐标的世界坐标
			local wpoint = game.MapUtils.map_2_screen(game.MapManager.getMap(), mpoint)  
			-- 平移的距离
			local movement = cc.p(curMidPosition.x - lastMidPosition.x, curMidPosition.y - lastMidPosition.y)
			-- 缩放的平移距离
			local scalemovement = cc.p(wpoint.x - lastMidPosition.x, wpoint.y - lastMidPosition.y)
			-- 新的位置
			local new_position = cc.p(zoomLayer:getPositionX() - scalemovement.x + movement.x,
									zoomLayer:getPositionY() - scalemovement.y + movement.y)

			zoomLayer:setPosition(HandleTouchUtil.calcZoomPosition(new_position))
		end
	end
end

-- 计算合法位置
function HandleTouchUtil.calcZoomPosition( position )
	local zoomLayer = game.Layers.ZoomLayer
	local scale = zoomLayer:getScale()
	local maxX = (zoomLayer:getBackgroudSize().width * scale - display.width) / 2
	local minX = -maxX
	local maxY = (zoomLayer:getBackgroudSize().height * scale - display.height) / 2
	local minY = -maxY
	position.x = position.x > maxX and maxX or position.x
	position.x = position.x < minX and minX or position.x
	position.y = position.y > maxY and maxY or position.y
	position.y = position.y < minY and minY or position.y
	return position
end

-- 计算合法缩放
function HandleTouchUtil.calcZoomScale( scale )
	scale = scale < 3 and scale or 3
	scale = scale > 0.8 and scale or 0.8
	return scale
end

return HandleTouchUtil