local Building = game.Building
local MapUtils = game.MapUtils
local Notification = game.NotificationManager
local TouchStatus = game.TouchStatus

local MapLayer = class("MapLayer", cc.Layer)

MapLayer.map_ = nil
MapLayer.selectedUnit_ = nil
MapLayer.selectIndex_ = nil

function MapLayer:ctor( ... )
	self:move(cc.p(0, 0))

	self.map_ = cc.TMXTiledMap:create("map/mymap.tmx")
        :align(cc.p(0.5, 0.5), display.center)
        :addTo(self)
        :setMapOrientation(3)
  		:setScale(0.5)

  	-- 设置
	local mapsize = self.map_:getMapSize()  	
    game.g_mapSize = mapsize
    game.g_mapGridNum = mapsize.width * mapsize.height
    game.g_mapTileSize = self.map_:getTileSize()
    game.MapLogicInfo = game.MapLogicInfo:create(mapsize.width, mapsize.height)

    self:test()
end

function MapLayer:test( ... )
	local vertex = cc.p(34, 1)
	local position = MapUtils.vertex_2_real(self.map_, vertex, 5)

	local building = game.MapManager.newBuilding(10001, vertex, self.map_)
	game.MapManager.addUnit(building)
	building:refresh(U_ST_BUILDED)

	do
		local vertex = cc.p(15, 15)
		local position = MapUtils.vertex_2_real(self.map_, vertex, 5)

		local building = game.MapManager.newBuilding(10001, vertex, self.map_)
		game.MapManager.addUnit(building)
		building:refresh(U_ST_BUILDED)
	end
end

function MapLayer:touchBegan( event )
	print("MapLayer touchBegan")
	local touch = cc.p(event.points[0].x, event.points[0].y)
	local maptouch = MapUtils.screen_2_map(self.map_, touch)
	local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
	local unit = MapUtils:isTouchedUnit(tileCoordinate)
	if unit then
		print("touched unit, judge is selected")
		if unit:isSelected() then  -- 点中了选择状态的unit，屏蔽zoomlayer
			print("pressed")
			unit:refresh(U_ST_PRESSED)
			self.selectedUnit_ = unit
			self.selectIndex_ = tileCoordinate  -- 点中的grid

			TouchStatus.switch_press_unit()
			
		end
	end
end

function MapLayer:touchMoved( event )
	if table.nums(event.points) > 1 then
		return
	end
	if TouchStatus.isStatus(OP_MOVE_MAP) or TouchStatus.isStatus(OP_ZOOM_MAP) then
		return
	end
	print("MapLayer touchMoved")
	if self.selectedUnit_ then
		TouchStatus.switch_move_unit()  -- 只要按下了高亮的unit，就算是移动建筑，不管移动的目标位置是否正确

		local touch = cc.p(event.points[0].x, event.points[0].y)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
		if MapUtils.isIndexValid(tileCoordinate) and tileCoordinate.x ~= self.selectIndex_.x or tileCoordinate.y ~= self.selectIndex_.y  then
			local vertex = self.selectedUnit_.vertex_
			local new_vertex = cc.p(vertex.x + tileCoordinate.x - self.selectIndex_.x,
									vertex.y + tileCoordinate.y - self.selectIndex_.y)
			local row = self.selectedUnit_.row_

			if MapUtils.isUnitValid(new_vertex, row) then
				game.MapManager.tryUpdateUnit(self.selectedUnit_, new_vertex, row)  -- 只改变位置，不改变逻辑数据

				self.selectIndex_ = tileCoordinate  -- 保存本次选中的index

				self.selectedUnit_:refresh(U_ST_MOVING, new_vertex)
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
		self.selectedUnit_:refresh(U_ST_UNPRESSED)
		self.selectedUnit_ = nil
	end
	if not TouchStatus.isStatus(OP_MOVE_UNIT) then
		-- 选中判定
		local touch = cc.p(event.points[0].x, event.points[0].y)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
		print(tileCoordinate.x, tileCoordinate.y)
		local unit = MapUtils:isTouchedUnit(tileCoordinate)
		if unit and TouchStatus.isStatus(OP_NONE) then
			print("选中了")
			game.NotificationManager.post(MSG_UNSELECTED_UNIT)
			unit:refresh(U_ST_SELECTED)
		else
			print("没选中")
			game.NotificationManager.post(MSG_UNSELECTED_UNIT)  -- 没选中则取消掉已选中状态的unit
		end
	end
	TouchStatus.switch_none()

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

	-- 	local building = game.MapManager.newBuilding(unitId, tileCoordinate, self.map_)
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
	}
end

function MapLayer:MSG_MAP_ADD( tileCoordinate, type )
	
end

return MapLayer