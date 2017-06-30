--
-- Author: Your Name
-- Date: 2017-06-27 19:23:30
--
local DBComponent = class("DBComponent", game.Component)
DBComponent.db = nil
function DBComponent:ctor( ... )
	self.db = {}
end
return DBComponent