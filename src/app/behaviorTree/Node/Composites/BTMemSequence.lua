--[[
]]

local BTMemSequence = class("BTMemSequence", game.BTNode)
BTMemSequence.activeIndex = nil

function BTMemSequence:ctor( ... )
	
end

function BTMemSequence:enter( ... )
	self.activeIndex = 1
end

function BTMemSequence:exit( ... )
	
end

function BTMemSequence:tick( ... )
	
end

function BTMemSequence:execute( ... )
	for i = self.activeIndex, #self.children do
		local child = self.children[i]
		local status = child:execute()
		if status ~= BTStatus.ST_TRUE then
			self.status = status
			self.activeIndex = i
			return status
		end
	end
	self.status = BTStatus.ST_TRUE
	return self.status
end

return BTMemSequence