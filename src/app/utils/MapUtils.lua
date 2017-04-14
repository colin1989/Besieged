local MapUtils = {}

-- 所以是否在地图内
function MapUtils.isIndexValid( mapIndex )
	return mapIndex.x >= 0 and mapIndex.y >=0 and mapIndex.x < game.g_mapSize.width and mapIndex.y < game.g_mapSize.height
end

-- 单元的所有点都有效
function MapUtils.isUnitValid( vertex, row )
	local t = {vertex, cc.p(vertex.x + row, vertex.y), cc.p(vertex.x, vertex.y + row), cc.p(vertex.x + row, vertex.y + row)}
	for _, p in pairs(t) do
		if not MapUtils.isIndexValid(p) then
			return false
		end
	end
	return true
end

-- 是否点击到unit
function MapUtils:isTouchedUnit( tileCoordinate )
	if not MapUtils.isIndexValid(tileCoordinate) then
		return nil
	end
	return game.MapLogicInfo:isTouchedUnit(tileCoordinate)
end

function MapUtils.isUsable( vertex, row )
	if not MapUtils.isUnitValid(vertex, row) then
		return false
	end
	return game.MapLogicInfo:isCanUse(vertex, row)
end

-- 查找逻辑位置
function MapUtils.logicVertex( unit )
	local unique = game.MapLogicInfo:findVertexByUnit(unit)
	if unique then
		return MapUtils.unique_2_tile(unique)
	end
	return cc.p(0, 0)
end

function MapUtils.map_2_tile( map, pos )
    local result = {}
    local newpos = {}
    newpos.x = pos.x * map:getScale()
    newpos.y = pos.y * map:getScale()
    local tileWidth = map:getBoundingBox().width / map:getMapSize().width
    local tileHeight = map:getBoundingBox().height / map:getMapSize().height
    local mapsizeWidth = map:getMapSize().width
    local mapsizeHeight = map:getMapSize().height
    result.x = mapsizeHeight - newpos.y / tileHeight + newpos.x / tileWidth - mapsizeWidth / 2
    result.y = mapsizeHeight - newpos.y / tileHeight - newpos.x / tileWidth + mapsizeWidth / 2
    -- if(result.x<0) then result.x=0 end
    -- if(result.y<0) then result.y=0 end
    -- if(result.x>map:getMapSize().width-1) then 
    --     result.x=map:getMapSize().width-1 
    -- end
    -- if(result.y>map:getMapSize().height-1) then
    --     result.y=map:getMapSize().height-1 
    -- end
    result.x = math.floor(result.x)
    result.y = math.floor(result.y)

    return result, MapUtils.isIndexValid(result)
end

function MapUtils.screen_2_tile( map, pos )
	return MapUtils.map_2_tile(map, MapUtils.screen_2_map(map, pos))
end

function MapUtils.screen_2_map( map, pos )
	return map:convertToNodeSpace(pos)
end

function MapUtils.map_2_screen( map, pos )
	return map:convertToWorldSpace(pos)
end

-- 瓦片坐标转换成唯一值
function MapUtils.tile_2_unique( pos )
    return pos.x * 100 + pos.y
end

function MapUtils.unique_2_tile( uni )
    return cc.p(math.floor(uni/100), uni%100)
end

-- 将基准位置转换成实际摆放的位置
function MapUtils.vertex_2_real( map, vertex, row )
    local mapPoint = map:getLayer("ground"):getPositionAt(vertex)
    local tilesize = game.g_mapTileSize
    return cc.p(mapPoint.x + tilesize.width / 2, mapPoint.y + tilesize.height - (row / 2 * tilesize.height))
end

-- 创建变红变绿的基座
function MapUtils.createXXX( num, b )
	local file = b and "map/build_1_1__.png" or "map/build_1_1____.png"
	local batchnode = cc.SpriteBatchNode:create(file)
	local tilesize = game.g_mapTileSize
	for i = 0, num - 1 do
		for j = 0, num - 1 do
			local sprite = display.newSprite(file)
			sprite:setPosition(cc.p((j - i) * tilesize.width/2,
									-(i + j) * tilesize.height/2 + math.floor(num / 2) * tilesize.height))
			batchnode:addChild(sprite)
		end
	end
	return batchnode
end

return MapUtils