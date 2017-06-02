BTStatus = {ST_RUNNING, ST_TRUE, ST_FALSE}

local BTNode = class("BTNode")

BTNode.status = BTStatus.ST_TRUE
BTNode.children = {}
BTNode.precondition = nil

function BTNode:ctor( ... )
	
end

function BTNode:enter( ... )
	
end

function BTNode:exit( ... )
	
end

function BTNode:tick( ... )
	return BTStatus.ST_TRUE
end

function BTNode:execute( ... )
	
end

function BTNode:toString( ... )
	return "BTNode"
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