local super = game.BTNode
local BTSequence = class("BTSequence", super)

BTSequence.activeIndex = nil

function BTSequence:ctor( ... )
	self:init(...)
end

function BTSequence:load( tree, id )
	super.load(self, tree, id)
	print("BTSequence load ")
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v, self.agent)
		table.insert(self.children, child)
	end
end

function BTSequence:enter( ... )
	self.activeIndex = 1
end

function BTSequence:exit( ... )
	
end

function BTSequence:tick( ... )
	return super.tick(self)
end

function BTSequence:execute( ... )
	print("BTSequence execute")
	for i = self.activeIndex, #self.children do
		local child = self.children[i]
		local status = child:tick()
		if status ~= BTStatus.ST_TRUE then
			self.status = status
			self.activeIndex = i
			return status
		end
	end
	self.status = BTStatus.ST_TRUE
	print("BTSequence status ", self.status)
	return self.status
end

function BTSequence:_evaluate( ... )
	return true
end

return BTSequence