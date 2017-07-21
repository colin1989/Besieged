--
-- Author: Your Name
-- Date: 2017-06-27 17:54:44
--
local TransformComponent = class("TransformComponent", game.Component)
TransformComponent.px = nil  -- 位置
TransformComponent.py = nil
TransformComponent.vx = nil
TransformComponent.vy = nil
TransformComponent.ax = nil  -- 锚点
TransformComponent.ay = nil
TransformComponent.rx = nil  -- 角度
TransformComponent.ry = nil
TransformComponent.sx = nil  -- 缩放
TransformComponent.sy = nil
function TransformComponent:ctor( ... )
	self.px = 0
	self.py = 0
	self.ax = 0.5
	self.ay = 0.5
	self.rx = 0
	self.ry = 0
	self.sx = 0
	self.sy = 0
end

function TransformComponent:setPosition( x, y )
	self.px = x
	self.py = y
end

function TransformComponent:setVertex( x, y, row )
	local position = game.MapUtils.vertex_2_real(game.MapManager.getMap(), cc.p(x, y), row)
	self.px = position.x
	self.py = position.y
	self.vx = x
	self.vy = y
end

function TransformComponent:setRotate( x, y )
	self.rx = x
	self.ry = y
end

function TransformComponent:setScale( x, y )
	self.sx = x
	self.sy = y
end
return TransformComponent