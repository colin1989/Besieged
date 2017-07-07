local super = game.BTNode
local BTSelector = class("BTSelector", super)

BTSelector.activeIndex = nil

function BTSelector:ctor( ... )
	self:init(...)
end

function BTSelector:load( tree, id )
	super.load(self, tree, id)
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v, self.entity)
		table.insert(self.children, child)
	end
end

function BTSelector:enter( ... )
	self.activeIndex = 1
end

function BTSelector:exit( ... )
	
end

function BTSelector:tick( ... )
	return super.tick(self)
end

function BTSelector:execute( ... )
	for i = self.activeIndex, #self.children do
		local child = self.children[i]
		local status = child:tick()
		if status == BTStatus.ST_RUNNING then
			self.status = status
			self.activeIndex = i
			print(self:toString(), " execute ", self.status)
			return status
		elseif status == BTStatus.ST_TRUE then
			self.status = status
			print(self:toString(), " execute ", self.status)
			return status
		end
	end
	self.status = BTStatus.ST_FALSE
	print(self:toString(), " execute ", self.status)
	return self.status
end

function BTSelector:_evaluate( ... )
	return true
end

return BTSelector