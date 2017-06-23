local BaseAgent = class("BaseAgent")
BaseAgent.tree = nil
BaseAgent.blackboard = nil

function BaseAgent:ctor( ... )
	print("BaseAgent:ctor")
	self.tree = nil
end

function BaseAgent:load( treename, blackboard )
	print("BaseAgent:load ", self)
	assert(treename)
	self.tree = game.BTFactory.createTree(self, treename)
	self.blackboard = blackboard
end

function BaseAgent:activate( ... )
	if self.tree then
		self.tree:activate()
		print("BaseAgent activate over ", self.tree, self)
	end
end

function BaseAgent:clear( ... )
	if self.tree then
		self.tree:clear()
	end
end


function BaseAgent:tick( dt )
	if self.tree then
		local r = self.tree:tick()
		-- if r == BTStatus.ST_TRUE then
			-- self.tree:clear()
			-- self:unschedule()
		-- end
	end
end

return BaseAgent