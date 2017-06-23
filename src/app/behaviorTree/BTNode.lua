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
BTNode.method = nil
BTNode.level = 0
BTNode.runningChildren = {}  -- save running children

function BTNode:ctor( agent )
	self:init(agent)
end

function BTNode:init( agent )
	self.id = nil
	self.name = nil
	self.status = BTStatus.ST_RUNNING
	self.active = false
	self.children = {}
	self.preconditions = {}
	self.tree = nil
	self.agent = agent
	self.method = nil
	self.level = 0
	self.runningChildren = {}
end

function BTNode:load( tree, id )
	self.id = id
	self.name = tree[id].name
	self.tree = tree

	-- properties
	local data = tree[id]
	self:load_property(data)
end

function BTNode:load_property( data )
	for k, v in pairs(data.properties or {}) do
		if k == "method" then
			assert(self.method == nil, "not allow multi method in properties!")
			self.method = {target = self.agent, method = v}
		elseif k == "precondition" then
			table.insert(self.preconditions, game.BTFactory.createNode(self.tree, v, self.agent))
		end
	end
end

function BTNode:enter( ... )
	
end

function BTNode:exit( ... )
	
end

function BTNode:tick( ... )
	-- print("BTNode tick")
	if self:evaluate() then
		local s = self:execute()
		if s == BTStatus.ST_RUNNING then
			table.insert(self.runningChildren, self)
		end
		return s
	end
	print(self:toString(), " evalute failed")
	return BTStatus.ST_FALSE
end

function BTNode:execute( ... )
	-- print("BTNode execute")
	if self.method then
		local target = self.method.target
		local method = self.method.method
		local r = target[method](target)
		print(self:toString(), " method ", method, " ", r)
		self.status = r
	end
	return self.status
end

-- 激活
function BTNode:activate( ... )
	-- print("BTNode activate")
	if self.active then
		return
	end
	for i,v in ipairs(self.preconditions) do
		v:activate()
		v:enter()
	end
	-- print("activate ", self:toString(), #self.children, self)
	for i,v in ipairs(self.children) do
		v:activate()
		v:enter()
	end
	self.active = true
	self:enter()
end

-- 评估是否可执行
function BTNode:evaluate( ... )
	-- print("BTNode evaluate")
	if not self.active then
		print(self:toString(), "evaluate not active")
		return false
	end
	for i,v in ipairs(self.preconditions) do
		-- print("precondition evaluate ", self:toString())
		if v:tick() ~= BTStatus.ST_TRUE then
			-- 失败后停止所有running子节点
			for _, child in ipairs(self.runningChildren) do
				child:clear()
			end
			return false
		end
	end

	return self:_evaluate()
end

-- 用于子节点的自定义评估
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
	self.status = BTStatus.ST_FALSE
	self.runningChildren = {}
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