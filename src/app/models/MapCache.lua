--[[
	存储地图的数据
]]

local MapUtils = game.MapUtils

local MapCache = class("MapCache")

--  --   /\ ______ 基准点
--  --  /\/\
--  -- /\/\/\
--  -- \/\/\/
--  --  \/\/
--  --   \/
--  -- 保存矩形 只需要保存基准点的位置，以及宽高
-- -- 假定点击放置建筑，点击的点是建筑以为底板的左上角
MapCache.buildings_ = {}  -- 存储地形上的数据
MapCache.peoples_ = {}
MapCache.vertexs_ = {}  -- 根据vertex保存unit

function MapCache:ctor( mapwidth, mapheight )
	for i = 0, mapwidth - 1 do
		for j = 0, mapheight - 1 do
			self.buildings_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY  -- 初始化地图数据
		end
	end
end

function MapCache:addUnit( tileCoordinate, unit, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.buildings_[MapUtils.tile_2_unique(cc.p(i, j))] = unit
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = unit
end

function MapCache:addPeople( unit )
	table.insert(self.peoples_, unit)
end

function MapCache:removeUnit( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.buildings_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = nil
end

function MapCache:removePeople( unit )
	for i,v in ipairs(self.peoples_) do
		if v.unique_ == unit.unique_ then
			table.remove(self.peoples_, i)
			break
		end
	end
end

function MapCache:isEmpty( tileCoordinate )
	return self.buildings_[MapUtils.tile_2_unique(tileCoordinate)] == U_EMPTY
end

-- 查看指定范围是否可用
function MapCache:isCanUse( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			if not self:isEmpty(cc.p(i, j)) then
				return false
			end
		end
	end
	return true
end

-- 查看指定范围是否可用，排除掉给定unit的位置
function MapCache:isCanUseExcept( tileCoordinate, row, unique )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			local value = self.buildings_[MapUtils.tile_2_unique(cc.p(i, j))]
			if value ~= U_EMPTY and value.unique_ ~= unique then
				return false
			end
		end
	end
	return true
end

-- 是否点击到unit
function MapCache:isTouchedUnit( tileCoordinate )
	local unit = self.buildings_[MapUtils.tile_2_unique(tileCoordinate)]
	if unit and unit ~= U_EMPTY --[[ and unit:operability()]] then
		return unit
	end
	return nil
end

function MapCache:findVertexByUnit( unit )
	for k,v in pairs(self.vertexs_) do
		if v.unique_ == unit.unique_ then
			return k
		end
	end
	return nil
end

function MapCache:findEmptyArea( row )
	for i = 0, game.g_mapSize.width - 1 - row do
		for j = 0, game.g_mapSize.height - 1 - row do
			local vertex = cc.p(i, j)
			if self:isCanUse(vertex, row) then
				return vertex
			end
		end
	end
	return nil
end

return MapCache