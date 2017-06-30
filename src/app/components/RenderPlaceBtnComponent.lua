--
-- Author: Your Name
-- Date: 2017-06-29 18:01:20
-- 不需主动添加，由BuildStateComponent组件的状态控制
--
local RenderPlaceBtnComponent = class("RenderPlaceBtnComponent", game.Component)
RenderPlaceBtnComponent.layout = nil
function RenderPlaceBtnComponent:ctor( ... )
end

function RenderPlaceBtnComponent:destroy( ... )
	if self.layout then
		print("RenderPlaceBtnComponent:destroy")
		self.layout:removeSelf()
		self.layout = nil
	end
end
return RenderPlaceBtnComponent