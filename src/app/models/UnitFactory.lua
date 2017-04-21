local Building = game.Building
local Plant = game.Plant

local factory = {}

function factory.newBuilding( id, vertex, map )
	local building = Building:create(id)
	building.map_ = map
	building:setVertex(vertex)
	return building
end

function factory.newPlant( id, vertex, map )
	local plant = Plant:create(id)
	plant.map_ = map
	plant:setVertex(vertex)
	return plant
end

return factory