local MapLogicInfo = game.MapLogicInfo
local Building = game.Building

local MapManager = {}

function MapManager.addBuilding( building )
	game.MapLogicInfo:addUnit(building.vertex_, building, building.row_)
end

function MapManager.newBuilding( id, vertex, map )
	local building = Building:create(id)
	building.map_ = map
	building:setVertex(vertex)
	return building
end

return MapManager