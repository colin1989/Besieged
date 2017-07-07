--
-- Author: Your Name
-- Date: 2017-06-29 18:01:20
--
local RenderPlaceBtnComponent = class("RenderPlaceBtnComponent", game.Component)
RenderPlaceBtnComponent.container = nil
function RenderPlaceBtnComponent:ctor( ... )
end

function RenderPlaceBtnComponent:destroy( ... )
	if self.container and self.container:getParent() then
		print("RenderPlaceBtnComponent:destroy")
		self.container:removeSelf()
	end
	self.container = nil
end
return RenderPlaceBtnComponent