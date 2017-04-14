local TouchStatus = game.TouchStatus

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
	print("zoomLayer touchBegan")
	if table.nums(event.points) == 1 then
		self.startPosition_ = cc.p(event.points[0].x, event.points[0].y)
		self.prevPosition_ = self.startPosition_
	elseif table.nums(event.points) == 2 then
		self.midPosition_ = cc.pMidpoint(cc.p(event.points[0].x, event.points[0].y), cc.p(event.points[1].x, event.points[1].y))
		self.distance_ = cc.pGetDistance(cc.p(event.points[0].x, event.points[0].y), cc.p(event.points[1].x, event.points[1].y))
		
		self.startScale_ = self:getScale()
	end
	return true
end

function ZoomLayer:touchMoved( event )
	if TouchStatus.isStatus(OP_PRESS_UNIT) or TouchStatus.isStatus(OP_MOVE_UNIT) then
		return
	end
	print("zoomLayer touchMoved")
	if table.nums(event.points) == 1 then
		local curPosition = cc.p(event.points[0].x, event.points[0].y)
		self:setPosition(cc.p(self:getPositionX() + curPosition.x - self.prevPosition_.x, 
								self:getPositionY() + curPosition.y - self.prevPosition_.y))
		self.prevPosition_ = curPosition

		TouchStatus.switch_move_map()
	elseif table.nums(event.points) == 2 then
		local curMidPosition = cc.pMidpoint(cc.p(event.points[0].x, event.points[0].y), cc.p(event.points[1].x, event.points[1].y))
		local curDistance = cc.pGetDistance(cc.p(event.points[0].x, event.points[0].y), cc.p(event.points[1].x, event.points[1].y))
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
	print("zoomLayer touchEnded")
	self.startPosition_ = nil
	self.prevPosition_ = nil
	self.midPosition_ = nil
	self.distance_ = nil
	self.startScale_ = nil

	TouchStatus.switch_none()
end

function ZoomLayer:touchCancelled( event )
	print("zoomLayer touchCancelled")
	self.startPosition_ = nil
	self.prevPosition_ = nil
	self.midPosition_ = nil
	self.distance_ = nil
	self.startScale_ = nil

	TouchStatus.switch_none()
end

return ZoomLayer