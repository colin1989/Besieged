local super = game.BTAction
local BTWait = class("BTWait", super)
BTWait.delay = nil

function BTWait:ctor( ... )
	self:init()
end

function BTWait:load( tree, id )
	super.load(self, tree, id)
	self.delay = tree[id].properties.milliseconds
	print("BTWait load")
	
end

function BTWait:enter( ... )
	
end

function BTWait:exit( ... )
	
end

function BTWait:tick( ... )
	return super.tick(self)
end

function BTWait:execute( ... )
	print("BTWait execute")
	return BTStatus.ST_TRUE
end

function BTWait:_evaluate( ... )
	return true
end

return BTWait