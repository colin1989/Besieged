--[[
	一些地图常用的工具
]]

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

function MapUtils.tile_2_map( map, vertex )
	return map:getLayer("ground"):getPositionAt(vertex)
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
    local mapPoint = MapUtils.tile_2_map(map, vertex)
    local tilesize = game.g_mapTileSize
    return cc.p(mapPoint.x + tilesize.width / 2, mapPoint.y + tilesize.height - (row / 2 * tilesize.height))
end

-- 创建变红变绿的基座
function MapUtils.createColorBoard( num, b )
	local file = b and "tile_green.png" or "tile_red.png"
	cc.SpriteFrameCache:getInstance():addSpriteFrames("map/UI_Building.plist")
	local batchnode = cc.SpriteBatchNode:create("map/UI_Building.pvr.ccz")
	local tilesize = game.g_mapTileSize
	for i = 0, num - 1 do
		for j = 0, num - 1 do
			local sprite = cc.Sprite:createWithSpriteFrameName(file)
			sprite:setPosition(cc.p((j - i) * tilesize.width/2,
									(num - 1) / 2 * tilesize.height - (i + j) * tilesize.height/2))
			batchnode:addChild(sprite)
		end
	end
	return batchnode
end

function MapUtils.getPoints( event )
	local result = {}
	for k, v in pairs(event.points) do
		v.touchid = k
		table.insert(result, v)
	end
	return unpack(result)
end

function MapUtils.isEqual( p1, p2 )
	return p1.x == p2.x and p1.y == p2.y
end

function MapUtils.getEntityPoints( vertex, row )
	local points = {}
	for i = vertex.x, vertex.x + row - 1 do
		for j = vertex.y, vertex.y + row - 1 do
			table.insert(points, cc.p(i, j))
		end
	end
	return points
end

function MapUtils.isInBound( tileCoordinate, vertex, row )
	return tileCoordinate.x >= vertex.x and tileCoordinate.y >= vertex.y and tileCoordinate.x <= vertex.x + row and tileCoordinate.y <= vertex.y + row
end

function MapUtils.createInfluenceGraph( vertex, row )
	local t = {}
    for i = 0, game.g_mapSize.height - 1 do
        for j = 0, game.g_mapSize.width - 1 do
            local x = vertex.x
            local y = vertex.y
            if j > x + row - 1 then                 x = x + row - 1
            elseif j >= x and j <= x + row -1 then  x = j
            end
            if i > y + row - 1 then                 y = y + row - 1
            elseif i >= y and i <= y + row -1 then  y = i
            end
            t[game.g_mapSize.width * i + j] = math.max(math.abs(x - j), math.abs(y - i))
        end
    end
    return t
end

return MapUtils