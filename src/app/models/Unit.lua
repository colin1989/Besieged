local Unit = class("Unit")

function Unit:ctor( id )
	self.init(id)
end

function Unit:init( ... )  -- final
	self:reset()
	self:init_db(...)
	self.unique_ = os.clock()  -- 唯一性，临时用时间表示
	self.type_ = U_EMPTY
	self.operability_ = false  -- 默认不可操作
	self.Node_ = display.newNode():align(cc.p(0.5, 0.5), 0, 0)

	cc.SpriteFrameCache:getInstance():addSpriteFrames("map/UI_Building.plist", "map/UI_Building.pvr.ccz")
	self.BATCH_ARROWS_ = cc.SpriteBatchNode:create("map/UI_Building.pvr.ccz"):addTo(self.Node_, 1)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou1.png")
		:align(cc.p(0,0), game.g_mapTileSize.width/4 * self.row_, game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou2.png")
		:align(cc.p(1,1), -game.g_mapTileSize.width/4 * self.row_, -game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou3.png")
		:align(cc.p(1,0), -game.g_mapTileSize.width/4 * self.row_, game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou4.png")
		:align(cc.p(0,1), game.g_mapTileSize.width/4 * self.row_, -game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	self.BATCH_ARROWS_:setVisible(false)

	self.BTN_OK_ = ccui.Button:create()
	self.BTN_OK_:loadTextures("ui/ui_public_btn_ok.png", "ui/ui_public_btn_ok.png", nil)
	self.BTN_OK_:setPosition(cc.p(self.BTN_OK_:getSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
	self.Node_:addChild(self.BTN_OK_, 2)
	self.BTN_OK_:addClickEventListener(function ( ... )
		game.TouchStatus.switch_ccui()
		self:onBuild(...)
	end)

	self.BTN_CANCEL_ = ccui.Button:create()
	self.BTN_CANCEL_:loadTextures("ui/ui_public_btn_closed.png", "ui/ui_public_btn_closed.png", nil)
	self.BTN_CANCEL_:setPosition(cc.p(-self.BTN_CANCEL_:getSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
	self.Node_:addChild(self.BTN_CANCEL_, 3)
	self.BTN_CANCEL_:addClickEventListener(function ( ... )
		game.TouchStatus.switch_ccui()
		self:onRemove(...)
	end)

	self.Node_:onNodeEvent("enter", function ( ... )
		game.NotificateUtil.add(self, self.unique_)
	end)
	self.Node_:onNodeEvent("exit", function ( ... )
		game.NotificateUtil.remove(self, self.unique_)
	end)
end

function Unit:init_db( ... )  -- virtaul
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
	self.type_ = nil
	self.operability_ = nil  -- 是否可操作
	self.scheduleId_ = nil
	self.background_ = nil
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
	self.Node_:removeSelf()
	self.Node_ = nil
	self:reset()
end

function Unit:hideWidgets( ... )
	self.BTN_OK_:setVisible(false)
	self.BTN_CANCEL_:setVisible(false)
	self.BATCH_ARROWS_:setVisible(false)
	if self.background_ then
		self.background_:setVisible(false)
	end
end

function Unit:refresh( status, ... )
	self:hideWidgets()

	if status == U_ST_WAITING then
		self.status_ = status

		self.BTN_OK_:setVisible(true)
		self.BTN_CANCEL_:setVisible(true)
		if self.background_ then
			self.background_:setVisible(true)
		end

	elseif status == U_ST_BUILDING then
		self.status_ = status
		-- 底部
		self:drawSubstrate()
	elseif status == U_ST_BUILDED then
		self.status_ = status
		-- 底部
		self:drawSubstrate()
	elseif status == U_ST_SELECTED then
		self.isSelected_ = true

		local actions = {}
		actions[#actions + 1] = cc.ScaleTo:create(0.2, 1.3, 1.3)
		actions[#actions + 1] = cc.ScaleTo:create(0.2, 1, 1)
		self.render_:runAction(transition.sequence(actions))
		self.BATCH_ARROWS_:setVisible(true)
		self:resetZOrder(ZORDER_MOVING)
	elseif status == U_ST_UNSELECTED then
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
	elseif status == U_ST_PRESSED then
		self:drawSubstrate()
		self.BATCH_ARROWS_:setVisible(true)
		self:setBackgroundVisible(false)
	elseif status == U_ST_UNPRESSED then
		self:drawSubstrate()
		self.BATCH_ARROWS_:setVisible(true)
		self:setBackgroundVisible(false)
		self:resetZOrder(self.isValidPosition_ and ZORDER_NORMAL or ZORDER_MOVING)
	elseif status == U_ST_MOVING then
		local new_vertex = ...  -- 因为当前逻辑数据没更新，所以不能用self.vertex_
		self:clearSubstrate()  -- 清楚上一步的基座
		local usable = game.MapManager.isUsableExcept(new_vertex, self.row_, self.unique_)  -- 新位置是否可用
		self.isValidPosition_ = usable
		game.MapManager.tryUpdateUnit(self, new_vertex, self.row_)  -- 只改变位置，不改变逻辑数据
		if self.background_ then
			if self.background_.flag ~= usable then
				self.background_:removeSelf()
				self.background_ = game.MapUtils.createXXX(self.row_, usable)
			    self.background_.flag = usable
			    self.Node_:addChild(self.background_, 0)
			end
		end
		self:setBackgroundVisible(true)  -- 颜色底板可见性
		self:resetZOrder(ZORDER_MOVING)  -- 重设z值
		self.BATCH_ARROWS_:setVisible(true)  -- 显示箭头
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

function Unit:onBuild( sender )
	print("Unit Build")
	game.MapManager.updateUnit(self, self.vertex_, self.row_)
	self:refresh(U_ST_BUILDED)
end

function Unit:onRemove( sender )
	print("Unit Cancel")
	self:delete()
end

function Unit:onSelected( ... )
	
end

function Unit:isSelected( ... )
	return self.isSelected_
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

function Unit:setBackgroundVisible( visible )
	if self.background_ then
		if not self.isValidPosition_ then
			visible = true
		end
		self.background_:setVisible(visible)
	end
end

function Unit:resetZOrder( z )
	self.Node_:setZOrder(z)
end

function Unit:schedule( interval )
	self.scheduleId_ = cc.Scheduler:scheduleScriptFunc(interval or 1 / 60, function ( ... )
		self:update(...)
	end)
end

function Unit:unschedule( ... )
	if self.scheduleId_ then
		cc.Scheduler:unscheduleScriptEntry(self.scheduleId_)
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
		MSG_UNSELECTED_UNIT,
	}
end

-- 取消所有选中的unit
function Unit:MSG_UNSELECTED_UNIT( ... )
	if self:isSelected() then
		self:refresh(U_ST_UNSELECTED)
	end
end

return Unit