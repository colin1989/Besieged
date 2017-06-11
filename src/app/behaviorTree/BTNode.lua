BTStatus = {ST_RUNNING = "running", ST_TRUE = "true", ST_FALSE = "false"}

local BTNode = class("BTNode")

BTNode.id = nil
BTNode.name = nil
BTNode.status = BTStatus.ST_TRUE
BTNode.active = false
BTNode.children = {}
BTNode.preconditions = {}
BTNode.tree = nil
BTNode.agent = nil

function BTNode:ctor( agent )
	self:init(agent)
end

function BTNode:init( agent )
	self.id = nil
	self.name = nil
	self.status = BTStatus.ST_TRUE
	self.active = false
	self.children = {}
	self.preconditions = {}
	self.tree = nil
	self.agent = agent
end

function BTNode:load( tree, id )
	self.id = id
	self.name = tree[id].name
	self.tree = tree

	-- properties
	local data = tree[id]
	for k, v in pairs(data.properties or {}) do
		if k == "method" then
			self.method = {target = self.agent, method = v}
		end
	end
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
	print("BTNode execute")
	if self.method then
		local target = self.method.target
		local method = self.method.method
		local r = target[method](target)
		if r == true then
			print("r = true")
			self.status = BTStatus.ST_TRUE
		else
			print("r = false")
			self.status = BTStatus.ST_FALSE
		end
	end
	return self.status
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