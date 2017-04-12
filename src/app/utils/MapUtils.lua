local MapUtils = {}

-- 所以是否在地图内
function MapUtils.isIndexValid( mapIndex )
	return mapIndex.x >= 0 and mapIndex.y >=0 and mapIndex.x < game.g_mapSize.width and mapIndex.y < game.g_mapSize.height
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

    -- 4
    -- result.x = (newpos.x - layersize.width * tilesize.width/2) / tilesize.height - (newpos.y - layersize.height * tilesize.height) / tilesize.width;
    -- result.y = -(newpos.x - layersize.width * tilesize.width/2) / tilesize.height - (newpos.y - layersize.height * tilesize.height) / tilesize.width;
    -- printInfo("newpos x:%d y:%d index x:%s y:%s", newpos.x, newpos.y, result.x, result.y)
    -- result.x = round(result.x)
    -- result.y = round(result.y)

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

-- 将基准位置转换成实际拜访的位置
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