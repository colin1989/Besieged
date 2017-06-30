--
-- Author: Your Name
-- Date: 2017-06-27 17:54:44
--
local PositionComponent = class("PositionComponent", game.Component)
PositionComponent.x = nil
PositionComponent.y = nil
PositionComponent.ax = nil  -- 锚点
PositionComponent.ay = nil
function PositionComponent:ctor( ... )
	self.x = 0
	self.y = 0
	self.ax = 0
	self.ay = 0
end
return PositionComponent