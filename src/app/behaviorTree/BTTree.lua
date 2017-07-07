local BTTree = class("BTTree")
BTTree.root = nil
BTTree.entity = nil
BTTree.active = false

function BTTree:ctor( entity )
	self.entity = entity
end

function BTTree:load( name )
	print("BTTree load")
	local data = require("app.behaviorTree.Data."..name)
	local root_id = data.root
	self.root = game.BTFactory.createNode(data.nodes, root_id, self.entity)
end

function BTTree:activate( ... )
	if self.root then
		self.active = true
		self.root:activate()
	end
end

function BTTree:tick( ... )
	if self.root then
		if not active then
			self:activate()
		end
		local status = self.root:tick()
		if status == BTStatus.ST_TRUE then
			-- 执行结束
			self:clear()
		end
	end
end

function BTTree:clear( ... )
	if self.root then
		self.active = false
		self.root:clear()
	end
end

function BTTree:getAgent( ... )
	return self.entity
end

return BTTree