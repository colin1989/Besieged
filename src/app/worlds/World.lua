--
-- Author: Your Name
-- Date: 2017-06-27 17:34:13
--
local World = class("World")

World.systems_ = {}
World.entityManager = nil

function World:enter( ... )
	self.systems_ = {}
	self.entityManager = game.EntityManager:create()
end

function World:exit( ... )
	if self.scheduleId_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId_)
		self.scheduleId_ = nil
	end
end

function World:execute( ... )
	self.scheduleId_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
		self:update(...)
	end, interval or (1 / 60), false)
end

function World:addSystem( system )
	table.insert(self.systems_, system)
end

function World:update( ... )
	for _, system in pairs(self.systems_) do
		system:execute()
	end
end

return World