local BaseAgent = class("BaseAgent")
BaseAgent.tree = nil
BaseAgent.scheduleId = nil

function BaseAgent:ctor( ... )
	self.tree = nil
	self.scheduleId = nil
	self:schedule()
end

function BaseAgent:load( treename )
	assert(treename)
	self.tree = game.BTFactory.createTree(self, treename)
end

function BaseAgent:activate( ... )
	if self.tree then
		self.tree:activate()

	end
end

function BaseAgent:clear( ... )
	if self.tree then
		self.tree:clear()
	end
end

function BaseAgent:schedule( interval )
	self.scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
		self:update(...)
	end, interval or 2 / 60, false)
end

function BaseAgent:unschedule( ... )
	if self.scheduleId then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId)
		self.scheduleId = nil
	end
end

function BaseAgent:update( dt )
	if self.tree then
		local r = self.tree:tick()
		-- if r == BTStatus.ST_TRUE then
			self.tree:clear()
			self:unschedule()
		-- end
	end
end

return BaseAgent