--
-- Author: Your Name
-- Date: 2017-06-28 13:36:04
--
local VertexComponent = class("VertexComponent", game.Component)
VertexComponent.x = nil
VertexComponent.y = nil
function VertexComponent:ctor( ... )
	self.x = 0
	self.y = 0
end
return VertexComponent