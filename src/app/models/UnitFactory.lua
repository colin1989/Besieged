local Building = game.Building
local Plant = game.Plant
local Soldier = game.Soldier

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

function factory.newSoldier( id, vertex, map )
	local soldier = Soldier:create(id)
	soldier.map_ = map
	soldier:setVertex(vertex)
	-- local agent = game.SoldierAgent:create()
	soldier:load("testBT")
	soldier:activate()
	-- soldier:setAgent(agent)
	return soldier
end

return factory