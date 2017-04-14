local MapLogicInfo = game.MapLogicInfo
local Building = game.Building

local MapManager = {}

function MapManager.addUnit( unit )
	game.MapLogicInfo:addUnit(unit.vertex_, unit, unit.row_)
	unit.Node_:addTo(unit.map_)
	-- unit:refresh(U_ST_BUILDED)
end

function MapManager.removeUnit( unit )
	game.MapLogicInfo:clearUnit(unit.vertex_, unit.row_)
	unit:delete()
end

function MapManager.updateUnit( unit, vertex, row )
	game.MapLogicInfo:clearUnit(unit.vertex_, unit.row_)  -- 清空旧位置
	game.MapLogicInfo:addUnit(vertex, unit, row)  -- 更新新位置
	unit:setVertex(vertex)
end

function MapManager.tryUpdateUnit( unit, vertex, row )
	unit:setVertex(vertex)
end

function MapManager.newBuilding( id, vertex, map )
	local building = Building:create(id)
	building.map_ = map
	building:setVertex(vertex)
	return building
end

return MapManager