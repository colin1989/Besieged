--
-- Author: Your Name
-- Date: 2017-06-27 18:28:44
-- 绘制基底
--
local RenderSubstrateComponent = class("RenderSubstrateComponent", game.Component)
RenderSubstrateComponent.grids = nil
RenderSubstrateComponent.vx = nil
RenderSubstrateComponent.vy = nil
RenderSubstrateComponent.GID = nil
function RenderSubstrateComponent:ctor( ... )
	self.vx = 0
	self.vy = 0
end

function RenderSubstrateComponent:destroy( ... )
	for _,v in pairs(self.grids) do
		game.MapManager.getMap():getLayer("ground"):setTileGID(25, v)
	end
end
return RenderSubstrateComponent