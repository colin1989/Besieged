--
-- Author: Your Name
-- Date: 2017-07-06 16:43:09
--
local AIComponent = class("AIComponent", game.Component)
AIComponent.treeName = nil
AIComponent.root = nil
AIComponent.blackboard = nil

function AIComponent:destroy( ... )
	if self.root then
		self.root:clear()
		self.root = nil
	end
end

return AIComponent