--[[
	地图的总管理
]]

local MapManager = {}

local map_ = nil
local mapCache_ = nil

function MapManager.init( map )
	map_ = map

	local mapsize = map_:getMapSize()      
    game.g_mapSize = mapsize
    game.g_mapGridNum = mapsize.width * mapsize.height
    game.g_mapTileSize = map_:getTileSize()
end

function MapManager.getMap( ... )
	return map_
end

function MapManager.addUnitById( id, vertex, status )
	local createFunc
	if 10000 <= id and id < 20000 then
		createFunc = UnitFactory.newBuilding
	elseif 20000 <= id and id < 30000 then
		createFunc = UnitFactory.newSoldier
	elseif 30000 <= id and id < 40000 then
		createFunc = UnitFactory.newPlant
	end
	local unit = createFunc(id, vertex, map_)
	unit:setStatus(status)
	unit:render()
	MapManager.addUnit(unit)
	return unit
end

function MapManager.addUnit( unit )
	if unit.type_ == U_PEOPLE then
		mapCache_:addPeople(unit)
	else
		mapCache_:addUnit(unit.vertex_, unit, unit.row_)
	end
	
	unit.Node_:addTo(unit.map_, ZORDER_NORMAL)
	game.NotificationManager.post(MSG_ADD_UNIT, unit)
	return unit
end

function MapManager.removeUnit( unit )
	game.NotificationManager.post(MSG_REMOVE_UNIT, unit)
	mapCache_:removeUnit(unit.vertex_, unit.row_)
	unit:delete()
end

function MapManager.updateUnit( unit, vertex, row )
	mapCache_:removeUnit(unit.vertex_, unit.row_)  -- 清空旧位置
	mapCache_:addUnit(vertex, unit, row)  -- 更新新位置
	unit:setVertex(vertex)
	game.NotificationManager.post(MSG_UPDATE_UNIT, unit)
	return unit
end

-- 
function MapManager.tryUpdateUnit( unit, vertex, row )
	unit:setVertex(vertex)
	return unit
end


-- 是否点击到unit
function MapManager.isTouchedUnit( tileCoordinate )
	if not game.MapUtils.isIndexValid(tileCoordinate) then
		return nil
	end
	return mapCache_:isTouchedUnit(tileCoordinate)
end

-- 点是否在给定的范围
function MapManager.isInBound( tileCoordinate, vertex, row )
	return tileCoordinate.x >= vertex.x and tileCoordinate.y >= vertex.y and tileCoordinate.x <= vertex.x + row and tileCoordinate.y <= vertex.y + row
end

function MapManager.isUsable( vertex, row )
	if not game.MapUtils.isUnitValid(vertex, row) then
		return false
	end
	return mapCache_:isCanUse(vertex, row)
end

-- 判断给定区域是否可用，给定的unit不计算
function MapManager.isUsableExcept( vertex, row, unique )
	if not game.MapUtils.isUnitValid(vertex, row) then
		return false
	end
	return mapCache_:isCanUseExcept(vertex, row, unique)
end

function MapManager.isEmpty( tileCoordinate )
	return mapCache_:isEmpty(tileCoordinate)
end

-- 查找逻辑位置
function MapManager.logicVertex( unit )
	local unique = mapCache_:findVertexByUnit(unit)
	if unique then
		return game.MapUtils.unique_2_tile(unique)
	end
	return cc.p(0, 0)
end

function MapManager.findEmptyArea( row )
	local v = mapCache_:findEmptyArea(tonumber(row))
	return v
end

function MapManager.getBuildings( ... )
	return mapCache_.buildings_
end

return MapManager