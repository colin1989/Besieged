local super = game.BTNode
local BTParallelOr = class("BTParallelOr", super)


function BTParallelOr:ctor( ... )
	self:init(...)
end

function BTParallelOr:load( tree, id )
	super.load(self, tree, id)
	print("BTParallelOr load ")
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v, self.agent)
		table.insert(self.children, child)
	end
end

function BTParallelOr:enter( ... )
end

function BTParallelOr:exit( ... )
	
end

function BTParallelOr:tick( ... )
	return super.tick(self)
end

function BTParallelOr:execute( ... )
	print("BTParallelOr execute")
	self.status = BTStatus.ST_FALSE
	local childStatus = {}
	for i = 1, #self.children do
		local child = self.children[i]
		local status = child:tick()
		table.insert(childStatus, status)
	end
	for k,v in pairs(childStatus) do
		if v == BTStatus.ST_TRUE then
			self.status = v
			break
		elseif v == BTStatus.ST_RUNNING then
			self.status = v
		end
	end
	print("BTParallelOr status ", self.status)
	return self.status
end

function BTParallelOr:_evaluate( ... )
	return true
end

return BTParallelOr