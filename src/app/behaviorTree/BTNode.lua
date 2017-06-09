BTStatus = {ST_RUNNING = "running", ST_TRUE = "true", ST_FALSE = "false"}

local BTNode = class("BTNode")

BTNode.id = nil
BTNode.name = nil
BTNode.status = BTStatus.ST_TRUE
BTNode.active = false
BTNode.children = {}
BTNode.preconditions = {}
BTNode.tree = nil

function BTNode:ctor( ... )
	self:init()
end

function BTNode:init( ... )
	self.id = nil
	self.name = nil
	self.status = BTStatus.ST_TRUE
	self.active = false
	self.children = {}
	self.preconditions = {}
	self.tree = nil
end

function BTNode:load( tree, id )
	self.id = id
	self.name = tree[id].name
	self.tree = tree
end

function BTNode:enter( ... )
	
end

function BTNode:exit( ... )
	
end

function BTNode:tick( ... )
	if self:evaluate() then
		return self:execute()
	end
	print(self:toString(), " evalute failed")
	return BTStatus.ST_FALSE
end

function BTNode:execute( ... )
	
end

function BTNode:activate( ... )
	if self.active then
		return
	end
	for i,v in ipairs(self.preconditions) do
		v:activate()
		v:enter()
	end
	print("activate ", self:toString(), #self.children, self)
	for i,v in ipairs(self.children) do
		v:activate()
		v:enter()
	end
	self.active = true
	self:enter()
end

function BTNode:evaluate( ... )
	if not self.active then
		return false
	end
	for i,v in ipairs(self.preconditions) do
		local preCondition = v
		if preCondition.execute() ~= BTStatus.ST_TRUE then
			return false
		end
	end

	return self:_evaluate()
end

function BTNode:_evaluate( ... )
	return true
end

function BTNode:clear( ... )
	for i,v in ipairs(self.preconditions) do
		v:clear()
		v:exit()
	end
	for i,v in ipairs(self.children) do
		v:clear()
		v:exit()
	end
	self.active = false
end

function BTNode:toString( ... )
	return self.name
end


function BTNode:setStatus(value)
	self.status = value
end

function BTNode:getStatus()
	return self.status
end

function BTNode:setChildren(value)
	self.children = value
end

function BTNode:getChildren()
	return self.children
end

return BTNode