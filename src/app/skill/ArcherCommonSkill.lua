--
-- Author: Your Name
-- Date: 2017-07-19 17:05:35
--
local ArcherCommonSkill = class("ArcherCommonSkill", game.BaseSkill)

function ArcherCommonSkill:ctor( ... )
	self.targetType = 0
end

function ArcherCommonSkill:attack( target )
	local hpCom = EntityManager:getInstance():getComponent("HPComponent", target)	
end

return ArcherCommonSkill