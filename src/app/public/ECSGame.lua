--
-- Author: Your Name
-- Date: 2017-06-27 17:38:43
--
local ECSGame = class("ECSGame")

ECSGame.world_ = nil

function ECSGame:ctor( world )
	self.world_ = world
	if self.world_ then
		self.world_:enter()
	end
end

function ECSGame:runWorld( world )
	if self.world_ then
		self.world_:exit()
	end
	self.world_ = world
	self.world_:enter()
end

return ECSGame