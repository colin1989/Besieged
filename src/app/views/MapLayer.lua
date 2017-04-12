local Building = game.Building
local MapUtils = game.MapUtils
local Notification = game.NotificationManager

local MapLayer = class("MapLayer", cc.Layer)

MapLayer.map_ = nil
MapLayer.selectedUnit_ = nil
MapLayer.selectIndex_ = nil

function MapLayer:ctor( ... )
	self:move(cc.p(0, 0))
	self:addobserver()

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
	local vertex = cc.p(34, 0)
	local position = MapUtils.vertex_2_real(self.map_, vertex, 5)

	local building = game.MapManager.newBuilding(10001, vertex, self.map_)
	building.Node_:addTo(self.map_)
	building:refresh(U_ST_WAITING)
end

function MapLayer:touchBegan( event )
	print("MapLayer touchBegan")
	local touch = cc.p(event.points[0].x, event.points[0].y)
	local maptouch = MapUtils.screen_2_map(self.map_, touch)
	local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
	local unit = game.MapLogicInfo:isTouchedUnit(tileCoordinate)
	if unit then
		if unit:isSelected() then  -- 点中了选择状态的unit，屏蔽zoomlayer
			self.selectedUnit_ = unit
			self.selectIndex_ = tileCoordinate  -- 点中的grid
			return true
		end
	end
	return false
end

function MapLayer:touchMoved( event )
	if self.selectedUnit_ then
		print("1")
		local touch = cc.p(event.points[0].x, event.points[0].y)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
		if tileCoordinate.x ~= self.selectIndex_.x or tileCoordinate.y ~= self.selectIndex_.y  then
			print("3")
			local vertex = self.selectedUnit_.vertex_
			local new_vertex = cc.p(vertex.x + self.selectIndex_.x - tileCoordinate.x,
									vertex.y + self.selectIndex_.y - tileCoordinate.y)
			if MapUtils.isIndexValid(new_vertex) then
				self.selectedUnit_:setVertex(new_vertex)
				self.selectIndex_ = new_vertex
			end
			self.selectedUnit_:refresh(U_ST_MOVING)
		end
	end
end

function MapLayer:touchEnded( event )
	print("MapLayer touchEnded")
	if self.selectedUnit_ then
		self.selectedUnit_:refresh(U_ST_UNSELECTED)
		-- self.selectedUnit_ = nil
	end
	-- 放置
	-- if event.moved then
	-- 	return
	-- end
	
	local touch = cc.p(event.points[0].x, event.points[0].y)
	local maptouch = MapUtils.screen_2_map(self.map_, touch)
	local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)

	local unit = game.MapLogicInfo:isTouchedUnit(tileCoordinate)
	if unit then
		print("选中了")
		unit:refresh(U_ST_SELECTED)
		return
	else
		print("没选中")
		game.NotificationManager.post(MSG_UNSELECTED_UNIT)  -- 没选中则取消掉已选中状态的unit
		return
	end

	local unitId = 10001
	local unitdb = game.DB_Building.getById(unitId)
	-- 获取占地行数
	local occupy = unitdb.occupy
	-- 边宽
	local edge = unitdb.edge
	local tilesize = game.g_mapTileSize
	local row = occupy + 2 * edge
	 --   /\ ______ 基准点
	 --  /\/\
	 -- /\/\/\
	 -- \/\/\/
	 --  \/\/
	 --   \/
	 -- 保存矩形 只需要保存基准点的位置，以及宽高
	-- 假定点击放置建筑，点击的点是建筑以为底板的左上角
	if game.MapLogicInfo:isCanUse(tileCoordinate, row) then

		local building = game.MapManager.newBuilding(unitId, tileCoordinate, self.map_)
		building.Node_:addTo(self.map_)
		building:refresh(U_ST_BUILDED)

		-- print("touch ", touch.x, touch.y)
		-- print("maptouch ", maptouch.x, maptouch.y)
		print("tileCoordinate ", tileCoordinate.x, tileCoordinate.y)
	else
		print("此位置已存在单位")
	end
end

function MapLayer:touchCancelled( event )
	print("MapLayer touchCancelled")
	self.selectedUnit_ = nil
end

function MapLayer:addobserver( ... )
	for k,v in pairs(self:notifications()) do
    	if self[v] then
    		Notification.add(v, self.__cname, function ( ... )
    			self[v](self, ...)
    		end)
    	end
    end
end

function MapLayer:notifications( ... )
	return {
		MSG_MAP_ADD,
	}
end

function MapLayer:MSG_MAP_ADD( tileCoordinate, type )
	
end

return MapLayer