--
-- Author: Your Name
-- Date: 2017-06-27 17:55:21
--
local Component = class("Component")
Component.active = true

function Component:ctor( ... )
end

function Component:destroy( ... )
	
end

function Component:setEnabled( enabled )
	self.active = enabled
end

function Component:getName( ... )
	return self.__cname
end

return Component