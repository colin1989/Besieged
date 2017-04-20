local TouchStatus = game.TouchStatus
local TouchPoint = game.TouchPoint

-- 控制移动和放大缩小的的基础层
-- 地图层的根节点
local ZoomLayer = class("ZoomLayer", cc.Layer)
ZoomLayer.startPosition_ = nil
ZoomLayer.prevPosition_ = nil

ZoomLayer.midPosition_ = nil
ZoomLayer.distance_ = nil
ZoomLayer.startScale_ = nil


function ZoomLayer:ctor( ... )
	self:move(cc.p(0, 0))
	cc.Sprite:createWithSpriteFrameName("beijing.png")
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
		
		self.startScale_ = self:getScale()
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
		self:setPosition(cc.p(self:getPositionX() + curPosition.x - self.prevPosition_.x, 
								self:getPositionY() + curPosition.y - self.prevPosition_.y))
		self.prevPosition_ = curPosition

		TouchStatus.switch_move_map()
	elseif table.nums(TouchPoint.points_) == 2 then
		local curMidPosition = cc.pMidpoint(TouchPoint.points_[1], TouchPoint.points_[2])
		local curDistance = cc.pGetDistance(TouchPoint.points_[1], TouchPoint.points_[2])
		local curScale = self:getScale()

		self:setPosition(cc.p(self:getPositionX() + curMidPosition.x - self.midPosition_.x, 
								self:getPositionY() + curMidPosition.y - self.midPosition_.y))
		self:setScale(curDistance / self.distance_ * self.startScale_)
		
		self.midPosition_ = curMidPosition
		self.distance_ = curDistance
		self.startScale_ = self:getScale()

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
		self.startScale_ = nil
	end

	TouchStatus.switch_none()
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
		self.startScale_ = nil
	end

	TouchStatus.switch_none()
end

return ZoomLayer