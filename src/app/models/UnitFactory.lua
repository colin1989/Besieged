local factory = {}

function factory.newBuilding( id, vertex, map )
	local building = Building:create(id)
	building.map_ = map
	building:setVertex(vertex)
	return building
end

return factory