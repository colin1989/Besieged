--[[
	用于显示地图的层
]]

local Building = game.Building
local Plant = game.Plant
local MapUtils = game.MapUtils
local Notification = game.NotificationManager
local TouchStatus = game.TouchStatus
local TouchPoint = game.TouchPoint
local UnitFactory = game.UnitFactory
local MapManager = game.MapManager

local MapLayer = class("MapLayer", cc.Layer)

MapLayer.map_ = nil
MapLayer.selectedUnit_ = nil
MapLayer.selectedUnitVertex_ = nil
MapLayer.pressedIndex_ = nil

function MapLayer:ctor( ... )
	self:move(cc.p(0, 0))

    self:onNodeEvent("enter", function ( ... )
		game.NotificateDelegate.add(self, "MapLayer")
	end)
	self:onNodeEvent("exit", function ( ... )
		game.NotificateDelegate.remove(self, "MapLayer")
	end)
end

function MapLayer:setMap( map )
	self.map_ = map
end

function MapLayer:touchBegan( event )
	if table.nums(TouchPoint.points_) > 1 then
		return
	end
	print("MapLayer touchBegan")
	local touch = game.MapUtils.getPoints(event)
	local maptouch = MapUtils.screen_2_map(self.map_, touch)
	local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
	if self.selectedUnit_ then
		if MapManager.isInBound(tileCoordinate, self.selectedUnit_.vertex_, self.selectedUnit_.row_) then
			if self.selectedUnit_:isSelected() then  -- 点中了选择状态的unit，屏蔽zoomlayer
				self.selectedUnit_:onPressed()
				self.pressedIndex_ = tileCoordinate  -- 点中的grid
				TouchStatus.switch_press_unit()
			end
		end
	end
end

function MapLayer:touchMoved( event )
	-- 如果当前触摸点大于1，并且没按住unit
	if table.nums(TouchPoint.points_) > 1 and not TouchStatus.isStatus(OP_PRESS_UNIT) then
		return
	end
	if TouchStatus.isStatus(OP_MOVE_MAP) or TouchStatus.isStatus(OP_ZOOM_MAP) then
		return
	end
	print("MapLayer touchMoved")
	if self.selectedUnit_ and self.pressedIndex_ then
		TouchStatus.switch_move_unit()  -- 只要按下了高亮的unit，就算是移动建筑，不管移动的目标位置是否正确

		local touch = game.MapUtils.getPoints(event)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
	
		if MapUtils.isIndexValid(tileCoordinate) and tileCoordinate.x ~= self.pressedIndex_.x or tileCoordinate.y ~= self.pressedIndex_.y  then
			local vertex = self.selectedUnit_.vertex_						
			local new_vertex = cc.p(vertex.x + tileCoordinate.x - self.pressedIndex_.x, 
									vertex.y + tileCoordinate.y - self.pressedIndex_.y)
			local row = self.selectedUnit_.row_

			if MapUtils.isUnitValid(new_vertex, row) then
				self.selectedUnitVertex_ = new_vertex
				self.pressedIndex_ = tileCoordinate  -- 保存本次选中的index

				self.selectedUnit_:onMoving(new_vertex)
			end
		end
	end
end

function MapLayer:touchEnded( event )
	if TouchStatus.isStatus(OP_MOVE_MAP) or TouchStatus.isStatus(OP_ZOOM_MAP) or TouchStatus.isStatus(OP_CCUI) then
		return
	end
	print("MapLayer touchEnded")
	if self.selectedUnit_ then
		self.selectedUnit_:onUnPressed()
	end
	self.pressedIndex_ = nil
	-- 没移动过，则执行点击判定
	if not TouchStatus.isStatus(OP_MOVE_UNIT) then
		-- 选中判定
		local touch = game.MapUtils.getPoints(event)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
		local unit = MapManager.isTouchedUnit(tileCoordinate)
		if unit and not unit:isSelected() and TouchStatus.isStatus(OP_NONE) then
			game.NotificationManager.post(MSG_UNSELECTED_UNIT)  -- 先清掉之前选中的unit
			unit:onSelected()
			self.selectedUnit_ = unit
			self.selectedUnitVertex_ = unit.vertex_
		else
			game.NotificationManager.post(MSG_UNSELECTED_UNIT)  -- 没选中则取消掉已选中状态的unit
			self.selectedUnit_ = nil
			self.selectedUnitVertex_ = nil
		end
	end
	if table.nums(TouchPoint.points_) == 0 then
		TouchStatus.switch_none()	
	end

	-- local unitId = 10001
	-- local unitdb = game.DB_Building.getById(unitId)
	-- -- 获取占地行数
	-- local occupy = unitdb.occupy
	-- -- 边宽
	-- local edge = unitdb.edge
	-- local tilesize = game.g_mapTileSize
	-- local row = occupy + 2 * edge
	--  --   /\ ______ 基准点
	--  --  /\/\
	--  -- /\/\/\
	--  -- \/\/\/
	--  --  \/\/
	--  --   \/
	--  -- 保存矩形 只需要保存基准点的位置，以及宽高
	-- -- 假定点击放置建筑，点击的点是建筑以为底板的左上角
	-- if game.MapLogicInfo:isCanUse(tileCoordinate, row) then

	-- 	local building = UnitFactory.newBuilding(unitId, tileCoordinate, self.map_)
	-- 	building.Node_:addTo(self.map_)
	-- 	building:refresh(U_ST_BUILDED)

	-- 	-- print("touch ", touch.x, touch.y)
	-- 	-- print("maptouch ", maptouch.x, maptouch.y)
	-- 	print("tileCoordinate ", tileCoordinate.x, tileCoordinate.y)
	-- else
	-- 	print("此位置已存在单位")
	-- end
end

function MapLayer:touchCancelled( event )
	print("MapLayer touchCancelled")
	self.selectedUnit_ = nil

	TouchStatus.switch_none()
end

function MapLayer:notifications( ... )
	return {
		MSG_MAP_ADD,
		"TEST",
	}
end

function MapLayer:MSG_MAP_ADD( tileCoordinate, type )
	
end

function MapLayer:TEST( ... )
	print("TEST")

	local vertex = cc.p(34, 1)
	local building = UnitFactory.newBuilding(10001, vertex, self.map_)
	MapManager.addUnit(building)
	building:refresh(U_ST_BUILDED)

	do
		local vertex = cc.p(15, 15)
		local building = UnitFactory.newBuilding(10004, vertex, self.map_)
		MapManager.addUnit(building)
		building:refresh(U_ST_BUILDED)
	end

	local plants = {11001, 11001, 11003, 11002, 11001, 11004, 11005, 11006, 11001, 11004, 11005, 11006, 11001, 11004}
	local vers = {cc.p(1,1), cc.p(2,5), cc.p(4,10), cc.p(5,15), cc.p(5,1), cc.p(10,10), cc.p(15,7), cc.p(36,10),
					cc.p(35,36), cc.p(30,13), cc.p(22,31), cc.p(26,1), cc.p(27,19), cc.p(32,3)}
	for k,v in pairs(plants) do
		local plant = UnitFactory.newPlant(v, vers[k], self.map_)
		MapManager.addUnit(plant)
		plant:refresh(U_ST_BUILDED)
	end
end

return MapLayer