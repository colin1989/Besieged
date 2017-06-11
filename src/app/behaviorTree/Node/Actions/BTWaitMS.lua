local super = game.BTWait
local BTWaitMS = class("BTWaitMS", super)

function BTWaitMS:ctor( ... )
	self:init(...)
end

function BTWaitMS:load( tree, id )
	super.load(self, tree, id)
	print("BTWaitMS load")
end

function BTWaitMS:enter( ... )
end

function BTWaitMS:exit( ... )
	
end

function BTWaitMS:tick( ... )
	return super.tick(self)
end

function BTWaitMS:execute( ... )
	print("BTWaitMS execute")
	if self.delay > 0 then
		self.delay = self.delay - 1
		return BTStatus.ST_RUNNING
	end
	return BTStatus.ST_TRUE
end

function BTWaitMS:_evaluate( ... )
	return true
end

return BTWaitMS