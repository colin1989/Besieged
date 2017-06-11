local BTTree = class("BTTree")
BTTree.root = nil
BTTree.agent = nil

function BTTree:ctor( agent )
	self.agent = agent
end

function BTTree:load( name )
	print("BTTree load")
	local data = require("app.behaviorTree.Data."..name)
	local root_id = data.root
	self.root = game.BTFactory.createNode(data.nodes, root_id, self.agent)
end

function BTTree:activate( ... )
	if self.root then
		self.root:activate()
	end
end

function BTTree:tick( ... )
	if self.root then
		return self.root:tick()
	end
end

function BTTree:clear( ... )
	if self.root then
		self.root:clear()
	end
end

function BTTree:getAgent( ... )
	return self.agent
end

return BTTree