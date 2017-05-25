local UnitSelectedView = game.UnitSelectedView
local Unit = class("Unit")

function Unit:ctor( id )
	self.init(id)
end

function Unit:init( id, type )  -- final
	self:reset()
	
	self.type_ = type
	self:init_db(id)
	self.unique_ = os.clock()  -- 唯一性
	self.operability_ = false  -- 默认不可操作
	self.Node_ = display.newNode():align(cc.p(0.5, 0.5), 0, 0)

	self.Node_:onNodeEvent("enter", function ( ... )
		game.NotificateDelegate.add(self, self.unique_)
	end)
	self.Node_:onNodeEvent("exit", function ( ... )
		game.NotificateDelegate.remove(self, self.unique_)
	end)
end

function Unit:init_db( id )  -- virtaul
	if self.type_ == U_BUILDING then
		self.db_ = game.DB_Building.getById(tonumber(id))
		self.row_ = self.db_.occupy + 2 * self.db_.edge
		self.level_ = self.db_.level
	elseif self.type_ == U_PLANT then
		self.db_ = game.DB_Plant.getById(tonumber(id))
		self.row_ = self.db_.occupy + 2 * self.db_.edge
	elseif self.type_ == U_PEOPLE then
		self.db_ = game.DB_Soldier.getById(tonumber(id))
		self.row_ = self.db_.occupy + 2 * self.db_.edge
	end
end

function Unit:reset( ... )  -- final
	self.unique_ = nil
	self.level_ = nil
	-- 当手指移动unit时，unit只是改变了显示位置而没有改变逻辑数据
	self.vertex_ = {x = 0, y = 0}  -- 顶点mapidnex
	self.db_ = nil
	self.status_ = nil  -- 状态
	self.row_ = nil
	self.map_ = nil
	-- self.type_ = nil
	self.operability_ = nil  -- 是否可操作
	self.scheduleId_ = nil
	self.colorBoard_ = nil
	self.isSelected_ = false
	self.isValidPosition_ = true  -- 是否在正确的位置

	self.Node_ = nil
	self.render_ = nil
	self.BTN_OK_ = nil
	self.BTN_CANCEL_ = nil
	self.BATCH_ARROWS_ = nil
end

function Unit:delete( ... )
	self:unschedule()
	self:clearSubstrate()
	self.Node_:removeSelf()
	self.Node_ = nil
	self:reset()
end

function Unit:hideWidgets( ... )
	self:setBuildBtnVisible(false)
	self:setArrowVisible(false)
	self:setColorBoardVisible(false)
end

function Unit:refresh( status, ... )
	self:hideWidgets()

	if status == U_ST_WAITING then
		self.status_ = status
		self.isSelected_ = true

		self:setBuildBtnVisible(true)
		self:setColorBoardVisible(true)

	elseif status == U_ST_BUILDING then
		self.status_ = status
		-- 底部
		self:drawSubstrate()
		self:setBuildBtnVisible(false)
		self:setColorBoardVisible(false)
		self:setArrowVisible(false)
	elseif status == U_ST_BUILDED then
		self.status_ = status
		-- 底部
		self:drawSubstrate()
		self:setBuildBtnVisible(false)
		self:setColorBoardVisible(false)
		self:setArrowVisible(false)
	end
end

function Unit:setStatus( status )
	self.status_ = status
end

function Unit:render( ... )
	self:hideWidgets()
	if self.status_ == U_ST_WAITING then
		self.isSelected_ = true

		self:setBuildBtnVisible(true)
		self:setColorBoardVisible(true)
	elseif self.status_ == U_ST_BUILDING then
		self:drawSubstrate()
		self:setBuildBtnVisible(false)
		self:setColorBoardVisible(false)
		self:setArrowVisible(false)
	elseif self.status_ == U_ST_BUILDED then
		self:drawSubstrate()
		self:setBuildBtnVisible(false)
		self:setColorBoardVisible(false)
		self:setArrowVisible(false)
	end
end

function Unit:setVertex( vertex )
	if self.vertex_.x == vertex.x and self.vertex_.y == vertex.y then
		return
	end
	self.vertex_ = vertex
	local position = game.MapUtils.vertex_2_real(self.map_, vertex, self.row_)
	self.Node_:move(position)
end

function Unit:onBtnBuild( sender )
	print("Unit Build")
	self.status_ = U_ST_BUILDED
	if self:isSelected() then
		self:onUnSelected()
	end
	-- 更新数据	
	game.MapManager.updateUnit(self, self.vertex_, self.row_)
	-- 取消选中状态
	game.NotificationManager.post(MSG_MAP_UNSELECTED)
end

function Unit:onBtnRemove( sender )
	print("Unit Cancel")
	-- self:delete()
	game.MapManager.removeUnit(self)
end

function Unit:onSelected( ... )
	self:hideWidgets()
	self.isSelected_ = true

	local actions = {}
	actions[#actions + 1] = cc.ScaleTo:create(0.1, 1.3, 1.3)
	actions[#actions + 1] = cc.ScaleTo:create(0.1, 1, 1)
	self.render_:runAction(transition.sequence(actions))

	self:setArrowVisible(true)
	self:resetZOrder(ZORDER_MOVING)

	-- 选中unit后打开的菜单
	game.UnitSelectedView:create(self)
end

function Unit:isSelected( ... )
	return self.isSelected_
end

function Unit:onUnSelected( ... )
	self:render()
	self.isSelected_ = false
	self:clearSubstrate()
	-- 如果当前位置不可用，则回到原来的位置
	local usable = game.MapManager.isUsableExcept(self.vertex_, self.row_, self.unique_)
	local real_vertex = game.MapManager.logicVertex(self)
	if not usable then
		self:setVertex(real_vertex)
	else
		local new_vertex = self.vertex_
		self.vertex_ = real_vertex
		game.MapManager.updateUnit(self, new_vertex, self.row_)
	end
	self.isValidPosition_ = true
	self:drawSubstrate()
	self:resetZOrder(ZORDER_NORMAL)
end

function Unit:onPressed( ... )
	self:render()
	self:drawSubstrate()
	self:setArrowVisible(true)
	self:setColorBoardVisible(false)
end

function Unit:onUnPressed( ... )
	self:render()
	self:drawSubstrate()
	self:setArrowVisible(true)
	self:setColorBoardVisible(false)
	self:resetZOrder(self.isValidPosition_ and ZORDER_NORMAL or ZORDER_MOVING)
end

function Unit:onMoving( new_vertex )
	if not self.db_.isCanMove then
		return
	end
	self:render()
	self:clearSubstrate()  -- 清楚上一步的基座
	local usable = game.MapManager.isUsableExcept(new_vertex, self.row_, self.unique_)  -- 新位置是否可用
	self.isValidPosition_ = usable
	game.MapManager.tryUpdateUnit(self, new_vertex, self.row_)  -- 只改变位置，不改变逻辑数据
	if self.colorBoard_ then
		if self.colorBoard_.flag ~= usable then
			self.colorBoard_:removeSelf()
			self.colorBoard_ = game.MapUtils.createColorBoard(self.row_, usable)
		    self.colorBoard_.flag = usable
		    self.Node_:addChild(self.colorBoard_, 0)
		end
	end
	self:setColorBoardVisible(true)  -- 颜色底板可见性
	self:resetZOrder(ZORDER_MOVING)  -- 重设z值
	self:setArrowVisible(true)  -- 显示箭头
end

function Unit:setArrowVisible( visible )
	if not self.db_.isCanMove then
		visible = false
	end
	if self.status_ == U_ST_WAITING then
		visible = true
	end
	if self.BATCH_ARROWS_ then
		self.BATCH_ARROWS_:setVisible(visible)
	end
end

function Unit:setBuildBtnVisible( visible )
	if self.status_ == U_ST_WAITING then
		visible = true
	end
	if self.BTN_OK_ then
		self.BTN_OK_:setVisible(visible)
	end
	if self.BTN_CANCEL_ then
		self.BTN_CANCEL_:setVisible(visible)
	end
end

function Unit:drawSubstrate( ... )
	if not self.isValidPosition_ then
		return
	end
	local pos = self.vertex_
	local row = self.row_
	for i = pos.x, pos.x + row - 1 do
		for j = pos.y, pos.y + row - 1 do
			if game.MapUtils.isIndexValid(cc.p(i, j)) then
				self.map_:getLayer("ground"):setTileGID(self.db_.groundGID, cc.p(i, j))
			end
		end
	end
end

function Unit:clearSubstrate( ... )
	if not self.isValidPosition_ then
		return
	end
	local pos = self.vertex_
	local row = self.row_
	for i = pos.x, pos.x + row - 1 do
		for j = pos.y, pos.y + row - 1 do
			if game.MapUtils.isIndexValid(cc.p(i, j)) then
				self.map_:getLayer("ground"):setTileGID(25, cc.p(i, j))
			end
		end
	end
end

function Unit:setColorBoardVisible( visible )
	if self.colorBoard_ then
		if not self.isValidPosition_ and self.isSelected_ then  -- 选中状态松手的时候，如果位置不可用，则不隐藏地板
			visible = true
		end
		if self.status_ == U_ST_WAITING then
			visible = true
		end
		if not self.db_.isCanMove then  -- 不可移动的unit，不显示地面
			visible = false
		end
		self.colorBoard_:setVisible(visible)
	end
end

function Unit:resetZOrder( z )
	self.Node_:setZOrder(z)
end

function Unit:schedule( interval )
	self.scheduleId_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
		self:update(...)
	end, interval or 1 / 60, false)
end

function Unit:unschedule( ... )
	if self.scheduleId_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId_)
		self.scheduleId_ = nil
	end
end

function Unit:update( ... )
	
end

function Unit:operability( ... )
	return self.operability_
end


function Unit:notifications( ... )  -- virtual
	return {
		MSG_UNIT_UNSELECTED,
	}
end

-- 取消所有选中的unit
function Unit:MSG_UNIT_UNSELECTED( unit )
	if not unit or self.unique_ ~= unit.unique_ then
		return
	end
	if self.status_ == U_ST_WAITING then
		self:delete()
	elseif self:isSelected() then
		self:onUnSelected()
	end
end

return Unit