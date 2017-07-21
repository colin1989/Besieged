local Blackboard = class("Blackboard")

Blackboard.attributes_ = {}

function Blackboard.Set( name, value )
	self.attributes[name] = value
end

function Blackboard.Get( name )
	return self.attributes[name]
end

return Blackboard