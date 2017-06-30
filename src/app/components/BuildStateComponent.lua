--
-- Author: Your Name
-- Date: 2017-06-27 18:25:52
-- 建造状态
--
local BuildStateComponent = class("BuildStateComponent", game.Component)
BuildStateComponent.state = nil 	-- 状态
BuildStateComponent.endtime = nil 	-- 建造结束时间
function BuildStateComponent:ctor( ... )
	self.state = 0
	self.endtime = 0
end
return BuildStateComponent