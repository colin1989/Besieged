--
-- Author: Your Name
-- Date: 2017-06-27 18:32:36
-- 选中时的箭头
--
local RenderArrowComponent = class("RenderArrowComponent", game.Component)
RenderArrowComponent.container = nil
function RenderArrowComponent:destroy( ... )
	if self.container and not tolua.isnull(self.container) and self.container:getParent() then
		print("RenderArrowComponent:destroy")
		self.container:removeSelf()
	end
	self.container = nil
end
return RenderArrowComponent