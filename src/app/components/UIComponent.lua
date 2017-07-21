--
-- Author: Your Name
-- Date: 2017-07-06 11:49:55
--
local UIComponent = class("UIComponent", game.Component)
UIComponent.csbName = nil
UIComponent.mainLayer = nil
UIComponent.visible = false

function UIComponent:destroy( ... )
	if self.mainLayer then
		self.mainLayer:destroy()
	end
	self.mainLayer = nil
	self.visible = false
end

return UIComponent