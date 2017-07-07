--
-- Author: Your Name
-- Date: 2017-07-03 10:43:31
-- 单例组件
--
local SingletonComponent = class("SingletonComponent", game.Component)
SingletonComponent.instance_ = nil

function SingletonComponent:getInstance( ... )
	if not self.instance_ then
		self.instance_ = self:create()
	end
	return self.instance_
end

return SingletonComponent