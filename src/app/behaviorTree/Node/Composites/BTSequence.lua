local super = game.BTNode
local BTSequence = class("BTSequence", super)

BTSequence.activeIndex = nil

function BTSequence:ctor( ... )
	self:init(...)
end

function BTSequence:load( tree, id )
	super.load(self, tree, id)
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v, self.entity)
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
	for i = self.activeIndex, #self.children do
		local child = self.children[i]
		local status = child:tick()
		if status ~= BTStatus.ST_TRUE then
			self.status = status
			self.activeIndex = i
			print(self:toString(), " execute ", self.status)
			return status
		end
	end
	self.status = BTStatus.ST_TRUE
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTSequence:_evaluate( ... )
	return true
end

return BTSequence