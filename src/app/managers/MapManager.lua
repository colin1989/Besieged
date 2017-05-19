--[[
	地图的总管理
]]

local MapCache = game.MapCache
local Building = game.Building

local MapManager = {}

local mapCache_ = nil

function MapManager.init( ... )
	mapCache_ = game.MapCache:create(game.g_mapSize.width, game.g_mapSize.height)
end

function MapManager.addUnit( unit )
	mapCache_:addUnit(unit.vertex_, unit, unit.row_)
	unit.Node_:addTo(unit.map_, ZORDER_NORMAL)
	-- unit:refresh(U_ST_BUILDED)
end

function MapManager.removeUnit( unit )
	mapCache_:clearUnit(unit.vertex_, unit.row_)
	unit:delete()
end

function MapManager.updateUnit( unit, vertex, row )
	mapCache_:clearUnit(unit.vertex_, unit.row_)  -- 清空旧位置
	mapCache_:addUnit(vertex, unit, row)  -- 更新新位置
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

return MapManager