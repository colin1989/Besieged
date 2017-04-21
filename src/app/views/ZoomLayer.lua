--[[
	控制地图缩放和移动的层
]]

local TouchStatus = game.TouchStatus
local TouchPoint = game.TouchPoint

-- 控制移动和放大缩小的的基础层
-- 地图层的根节点
local ZoomLayer = class("ZoomLayer", cc.Layer)
ZoomLayer.background_ = nil

ZoomLayer.startPosition_ = nil
ZoomLayer.prevPosition_ = nil

ZoomLayer.midPosition_ = nil
ZoomLayer.distance_ = nil


function ZoomLayer:ctor( ... )
	self:move(cc.p(0, 0))
	self.background_ = cc.Sprite:createWithSpriteFrameName("beijing.png")
								:move(display.cx, display.cy)
								:addTo(self)
end

function ZoomLayer:touchBegan( event )
	if TouchStatus.isStatus(OP_PRESS_UNIT) then
		return
	end
	print("zoomLayer touchBegan ", table.nums(TouchPoint.points_))
	if table.nums(TouchPoint.points_) == 1 then
		self.startPosition_ = cc.p(TouchPoint.points_[1].x, TouchPoint.points_[1].y)
		self.prevPosition_ = cc.p(TouchPoint.points_[1].x, TouchPoint.points_[1].y)
	elseif table.nums(TouchPoint.points_) == 2 then
		self.midPosition_ = cc.pMidpoint(TouchPoint.points_[1], TouchPoint.points_[2])
		self.distance_ = cc.pGetDistance(TouchPoint.points_[1], TouchPoint.points_[2])
	end
	return true
end

function ZoomLayer:touchMoved( event )
	if TouchStatus.isStatus(OP_PRESS_UNIT) or TouchStatus.isStatus(OP_MOVE_UNIT) then
		return
	end

	print("zoomLayer touchMoved ", table.nums(TouchPoint.points_))
	if table.nums(TouchPoint.points_) == 1 then
		local curPosition = cc.p(TouchPoint.points_[1].x, TouchPoint.points_[1].y)
		local new_position = cc.p(self:getPositionX() + curPosition.x - self.prevPosition_.x, 
								self:getPositionY() + curPosition.y - self.prevPosition_.y)
		self:calcPosition(new_position)
		self:setPosition(new_position)
		self.prevPosition_ = curPosition

		TouchStatus.switch_move_map()
	elseif table.nums(TouchPoint.points_) == 2 then
		local curMidPosition = cc.pMidpoint(TouchPoint.points_[1], TouchPoint.points_[2])
		local curDistance = cc.pGetDistance(TouchPoint.points_[1], TouchPoint.points_[2])
		local curScale = self:getScale()
		local scale = curDistance / self.distance_ * curScale
		scale = scale < 3 and scale or 3
        scale = scale > 0.8 and scale or 0.8
		-- 记录中点的地图坐标
		local mpoint = game.Layers.MapLayer.map_:convertToNodeSpace(self.midPosition_)
		-- 缩放
		self:setScale(scale)
		-- 记录地图缩放后中点坐标的世界坐标
		local wpoint = game.Layers.MapLayer.map_:convertToWorldSpace(mpoint)  
		-- 平移的距离
		local movement = cc.p(curMidPosition.x - self.midPosition_.x, curMidPosition.y - self.midPosition_.y)
		-- 缩放的平移距离
		local scalemovement = cc.p(wpoint.x - self.midPosition_.x, wpoint.y - self.midPosition_.y)
		-- 新的位置
		local new_position = cc.p(self:getPositionX() - scalemovement.x + movement.x,
								self:getPositionY() - scalemovement.y + movement.y)
		self:calcPosition(new_position)

		self:setPosition(new_position)
				
		self.midPosition_ = curMidPosition
		self.distance_ = curDistance

		TouchStatus.switch_zoom_map()
	end
end

function ZoomLayer:touchEnded( event )
	print("zoomLayer touchEnded ", table.nums(TouchPoint.points_))
	
	if table.nums(TouchPoint.points_) == 1 then
		self.prevPosition_ = cc.p(TouchPoint.points_[1].x, TouchPoint.points_[1].y)
	elseif table.nums(TouchPoint.points_) == 0 then
		self.startPosition_ = nil
		self.prevPosition_ = nil
		self.midPosition_ = nil
		self.distance_ = nil
		TouchStatus.switch_none()
	end
end

function ZoomLayer:touchCancelled( event )
	print("zoomLayer touchCancelled")

	if table.nums(TouchPoint.points_) == 1 then
		self.prevPosition_ = cc.p(TouchPoint.points_[1].x, TouchPoint.points_[1].y)  -- 双指切换到单指后，更新prevposition，防止地图大漂移
	elseif table.nums(TouchPoint.points_) == 0 then
		self.startPosition_ = nil
		self.prevPosition_ = nil
		self.midPosition_ = nil
		self.distance_ = nil
		TouchStatus.switch_none()
	end
end

-- 计算合法位置
function ZoomLayer:calcPosition( position )
	local scale = self:getScale()
	local maxX = (self.background_:getContentSize().width * scale - display.width) / 2
	local minX = -maxX
	local maxY = (self.background_:getContentSize().height * scale - display.height) / 2
	local minY = -maxY
	position.x = position.x > maxX and maxX or position.x
	position.x = position.x < minX and minX or position.x
	position.y = position.y > maxY and maxY or position.y
	position.y = position.y < minY and minY or position.y
	return position
end

return ZoomLayer