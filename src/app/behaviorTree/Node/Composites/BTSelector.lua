local super = game.BTNode
local BTSelector = class("BTSelector", super)

BTSelector.activeIndex = nil

function BTSelector:ctor( ... )
	self:init()
end

function BTSelector:load( tree, id )
	super.load(self, tree, id)
	print("BTSelector load ")
	local data = tree[id]
	for i,v in ipairs(data.children or {}) do
		local child = game.BTFactory.createNode(tree, v)
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
	print("BTSelector execute")
	for i = self.activeIndex, #self.children do
		local child = self.children[i]
		local status = child:execute()
		if status == BTStatus.ST_RUNNING then
			self.status = status
			self.activeIndex = i
			return status
		elseif status == BTStatus.ST_TRUE then
			self.status = status
			return status
		end
	end
	self.status = BTStatus.ST_FALSE
	print("BTSelector status ", self.status)
	return self.status
end

function BTSelector:_evaluate( ... )
	return true
end

return BTSelector