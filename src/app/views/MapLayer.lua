--[[
	用于显示地图的层
]]

local Building = game.Building
local Plant = game.Plant
local MapUtils = game.MapUtils
local NotificationManager = game.NotificationManager
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
	self.map_ = MapManager.getMap()
	self:move(cc.p(0, 0))

    self:onNodeEvent("enter", function ( ... )
		game.NotificateDelegate.add(self, "MapLayer")
	end)
	self:onNodeEvent("exit", function ( ... )
		game.NotificateDelegate.remove(self, "MapLayer")
	end)
end

function MapLayer:touchBegan( event )
	if table.nums(TouchPoint.points_) > 1 then
		return
	end
	print("MapLayer touchBegan")
	local touch = TouchPoint.points_[1]
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

		local touch = TouchPoint.points_[1]
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
		local touch = MapUtils.getPoints(event)
		local maptouch = MapUtils.screen_2_map(self.map_, touch)
		local tileCoordinate = MapUtils.map_2_tile(self.map_, maptouch)
		local unit = MapManager.isTouchedUnit(tileCoordinate)
		if unit --[[and not unit:isSelected() ]]and TouchStatus.isStatus(OP_NONE) then
			self:unitSelected(unit)
		else
			self:unitUnSelected()
		end
	end
	if table.nums(TouchPoint.points_) == 0 then
		TouchStatus.switch_none()	
	end
end

function MapLayer:touchCancelled( event )
	print("MapLayer touchCancelled")
	self.selectedUnit_ = nil

	TouchStatus.switch_none()
end

function MapLayer:unitSelected( unit )
	NotificationManager.post(MSG_UNIT_UNSELECTED, self.selectedUnit_)  -- 先清掉之前选中的unit
	unit:onSelected()
	self.selectedUnit_ = unit
	self.selectedUnitVertex_ = unit.vertex_
end

function MapLayer:unitUnSelected( ... )
	NotificationManager.post(MSG_UNIT_UNSELECTED, self.selectedUnit_)  -- 没选中则取消掉已选中状态的unit
	self.selectedUnit_ = nil
	self.selectedUnitVertex_ = nil
	if table.nums(TouchPoint.points_) == 0 then
		TouchStatus.switch_none()	
	end
end

function MapLayer:notifications( ... )
	return {
		MSG_ADD_TEST_UNIT,
		MSG_MAP_UNSELECTED,
		MSG_ADD_UNIT,
		MSG_REMOVE_UNIT,
		MSG_UPDATE_UNIT,
	}
end

-- 取消选中
function MapLayer:MSG_MAP_UNSELECTED( ... )
	print("In MSG_MAP_UNSELECTED")
	self:unitUnSelected()
end

-- 添加新unit
function MapLayer:MSG_ADD_UNIT( unit )
	if unit.status_ == U_ST_WAITING then
		NotificationManager.post(MSG_UNIT_UNSELECTED, self.selectedUnit_)  -- 先清掉之前选中的unit
		self.selectedUnit_ = unit
		self.selectedUnitVertex_ = unit.vertex_
	end
end

-- 移除unit
function MapLayer:MSG_REMOVE_UNIT( unit )
	-- 移除选中状态的unit
	if self.selectedUnit_ and self.selectedUnit_.unique_ == unit.unique_ then
		self.selectedUnit_ = nil
		self.selectedUnitVertex_ = nil
		if table.nums(TouchPoint.points_) == 0 then
			TouchStatus.switch_none()	
		end
	end
end

-- 更新unit
function MapLayer:MSG_UPDATE_UNIT( unit )
	
end

-- 添加测试unit
function MapLayer:MSG_ADD_TEST_UNIT( ... )
	print("MSG_ADD_TEST_UNIT")

	MapManager.addUnitById(10001, cc.p(34, 1), U_ST_WAITING)

	-- -- NotificationManager.post(MSG_UNIT_UNSELECTED, self.selectedUnit_)  -- 先清掉之前选中的unit
	-- MapManager.addUnitById(10004, cc.p(15, 15), U_ST_BUILDED)

	-- local plants = {30001, 30001, 30003, 30002, 30001, 30004, 30005, 30006, 30001, 30004, 30005, 30006, 30001, 30004}
	-- local vers = {cc.p(1,1), cc.p(2,5), cc.p(4,10), cc.p(5,15), cc.p(5,1), cc.p(10,10), cc.p(15,7), cc.p(36,10),
	-- 				cc.p(35,36), cc.p(30,13), cc.p(22,31), cc.p(26,1), cc.p(27,19), cc.p(32,3)}
	-- for k,v in pairs(plants) do
	-- 	MapManager.addUnitById(v, vers[k], U_ST_BUILDED)
	-- end

	local soldier = game.UnitFactory.newSoldier(20001, cc.p(1, 1), MapManager.getMap())	
	game.MapManager.addUnit(soldier)
end


return MapLayer