local super = game.BTNode
local BTParallelAnd = class("BTParallelAnd", super)


function BTParallelAnd:ctor( ... )
	self:init(...)
end

function BTParallelAnd:load( tree, id )
	super.load(self, tree, id)
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v, self.entity)
		table.insert(self.children, child)
	end
end

function BTParallelAnd:enter( ... )
end

function BTParallelAnd:exit( ... )
	
end

function BTParallelAnd:tick( ... )
	return super.tick(self)
end

function BTParallelAnd:execute( ... )
	self.status = BTStatus.ST_FALSE
	local childStatus = {}
	local runnings = {}
	local trues = {}
	local falses = {}
	for i = 1, #self.children do
		local child = self.children[i]
		local status = child:tick()
		if v == BTStatus.ST_FALSE then
			table.insert(falses, i)
		elseif v == BTStatus.ST_RUNNING then
			table.insert(runnings, i)
		else
			table.insert(trues, i)
		end
	end
	
	if #falses >= 0 then
		self.status = BTStatus.ST_FALSE
	elseif #runnings > 0 then
		self.status = BTStatus.ST_RUNNING
	else
		self.status = BTStatus.ST_TRUE
	end
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTParallelAnd:_evaluate( ... )
	return true
end

return BTParallelAnd