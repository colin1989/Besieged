local MapLogicInfo = game.MapLogicInfo
local Building = game.Building

local MapManager = {}

local mapInfo_ = nil

function MapManager.init( ... )
	mapInfo_ = game.MapLogicInfo:create(game.g_mapSize.width, game.g_mapSize.height)
end

function MapManager.addUnit( unit )
	mapInfo_:addUnit(unit.vertex_, unit, unit.row_)
	unit.Node_:addTo(unit.map_, ZORDER_NORMAL)
	-- unit:refresh(U_ST_BUILDED)
end

function MapManager.removeUnit( unit )
	mapInfo_:clearUnit(unit.vertex_, unit.row_)
	unit:delete()
end

function MapManager.updateUnit( unit, vertex, row )
	mapInfo_:clearUnit(unit.vertex_, unit.row_)  -- 清空旧位置
	mapInfo_:addUnit(vertex, unit, row)  -- 更新新位置
	unit:setVertex(vertex)
end

-- 
function MapManager.tryUpdateUnit( unit, vertex, row )
	unit:setVertex(vertex)
end


-- 是否点击到unit
function MapManager.isTouchedUnit( tileCoordinate )
	if not game.MapUtils.isIndexValid(tileCoordinate) then
		return nil
	end
	return mapInfo_:isTouchedUnit(tileCoordinate)
end

-- 点是否在给定的范围
function MapManager.isInBound( tileCoordinate, vertex, row )
	return tileCoordinate.x >= vertex.x and tileCoordinate.y >= vertex.y and tileCoordinate.x <= vertex.x + row and tileCoordinate.y <= vertex.y + row
end

function MapManager.isUsable( vertex, row )
	if not game.MapUtils.isUnitValid(vertex, row) then
		return false
	end
	return mapInfo_:isCanUse(vertex, row)
end

function MapManager.isUsableExcept( vertex, row, unique )
	if not game.MapUtils.isUnitValid(vertex, row) then
		return false
	end
	return mapInfo_:isCanUseExcept(vertex, row, unique)
end

function MapManager.isEmpty( tileCoordinate )
	return mapInfo_:isEmpty(tileCoordinate)
end

-- 查找逻辑位置
function MapManager.logicVertex( unit )
	local unique = mapInfo_:findVertexByUnit(unit)
	if unique then
		return game.MapUtils.unique_2_tile(unique)
	end
	return cc.p(0, 0)
end

return MapManager