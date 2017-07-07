--
-- Author: Your Name
-- Date: 2017-06-27 18:30:39
-- 绘制绿色、红色放置检测的板子
--
local RenderColorBoardComponent = class("RenderColorBoardComponent", game.Component)
RenderColorBoardComponent.container = nil
RenderColorBoardComponent.bool = true
function RenderColorBoardComponent:ctor( ... )
end

function RenderColorBoardComponent:destroy( ... )
	if self.container and self.container:getParent() then
		print("RenderColorBoardComponent:destroy")
		self.container:removeSelf()
	end
	self.container = nil
end
return RenderColorBoardComponent