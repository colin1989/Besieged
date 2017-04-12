local Unit = class("Unit")

function Unit:ctor( id, lv )
	self.init(lv)
end

function Unit:init( ... )  -- final
	self:reset()
	self.type_ = U_EMPTY
	self.operability_ = false  -- 默认不可操作
	self.level_ = ...
	self.Node_ = display.newNode():align(cc.p(0.5, 0.5), 0, 0)
end

function Unit:reset( ... )
	self.Node_ = nil
	self.level_ = nil
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

	self.render_ = nil
end

function Unit:delete( ... )
	self:unschedule()
	self.Node_:removeSelf()
	self.Node_ = nil
	self:reset()
end

function Unit:refresh( status )

	if self.background_ then
		self.background_:setVisible(false)
	end
	if status == U_ST_WAITING then
		self.status_ = status
		-- 带√、x和方向
		local btn_ok = ccui.Button:create()
		btn_ok:loadTextures("ui/ui_public_btn_ok.png", "ui/ui_public_btn_ok.png", nil)
		btn_ok:setPosition(cc.p(btn_ok:getSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
		self.Node_:addChild(btn_ok, 2)

		self.Node_.btn_ok = btn_ok
		btn_ok:addClickEventListener(function ( ... )
			self:onBuild(...)
		end)

		local btn_cancel = ccui.Button:create()
		btn_cancel:loadTextures("ui/ui_public_btn_closed.png", "ui/ui_public_btn_closed.png", nil)
		btn_cancel:setPosition(cc.p(-btn_cancel:getSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
		self.Node_:addChild(btn_cancel, 2)

		self.Node_.btn_cancel = btn_cancel
		btn_cancel:addClickEventListener(function ( ... )
			self:onRemove(...)
		end)

		if self.background_ then
		self.background_:setVisible(true)
	end
	elseif status == U_ST_BUILDING then
		self.status_ = status
		-- 底部
		self:drawSubstrate()

		if self.Node_.btn_ok then
			self.Node_:removeChild(self.Node_.btn_ok, true)
			self.Node_.btn_ok = nil
		end
		if self.Node_.btn_cancel then
			self.Node_:removeChild(self.Node_.btn_cancel, true)
			self.Node_.btn_cancel = nil
		end
	elseif status == U_ST_BUILDED then
		self.status_ = status
		-- 底部
		self:drawSubstrate()

		if self.Node_.btn_ok then
			self.Node_:removeChild(self.Node_.btn_ok, true)
			self.Node_.btn_ok = nil
		end
		if self.Node_.btn_cancel then
			self.Node_:removeChild(self.Node_.btn_cancel, true)
			self.Node_.btn_cancel = nil
		end
	elseif status == U_ST_SELECTED then
		self.isSelected_ = true

		local actions = {}
		actions[#actions + 1] = cc.ScaleTo:create(0.2, 1.3, 1.3)
		actions[#actions + 1] = cc.ScaleTo:create(0.2, 1, 1)
		self.Node_:runAction(transition.sequence(actions))
	elseif status == U_ST_UNSELECTED then
		self.isSelected_ = false
	elseif status == U_ST_MOVING then
		self.background_:setVisible(true)
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
	game.MapManager.addBuilding(self)  -- 添加数据
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
	local pos = self.vertex_
	local row = self.row_
	for i = pos.x, pos.x + row - 1 do
		for j = pos.y, pos.y + row - 1 do
			self.map_:getLayer("ground"):setTileGID(self.db_.groundGID, cc.p(i, j))
		end
	end
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
return Unit