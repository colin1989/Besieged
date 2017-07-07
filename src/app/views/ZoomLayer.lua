--[[
	控制地图缩放和移动的层
]]

-- 控制移动和放大缩小的的基础层
-- 地图层的根节点
local ZoomLayer = class("ZoomLayer", cc.Layer)
ZoomLayer.background_ = nil

function ZoomLayer:ctor( ... )
	self:move(cc.p(0, 0))
	self.background_ = cc.Sprite:createWithSpriteFrameName("beijing.png")
								:move(display.cx, display.cy)
								:addTo(self)
end

function ZoomLayer:getBackgroudSize( ... )
	return self.background_:getContentSize()
end

return ZoomLayer