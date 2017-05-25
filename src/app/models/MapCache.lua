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
MapCache.maps_ = {}  -- 存储地形上的数据
MapCache.vertexs_ = {}  -- 根据vertex保存unit

function MapCache:ctor( mapwidth, mapheight )
	for i = 0, mapwidth - 1 do
		for j = 0, mapheight - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY  -- 初始化地图数据
		end
	end
end

function MapCache:addUnit( tileCoordinate, unit, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = unit
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = unit
end

function MapCache:clearUnit( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = nil
end

function MapCache:isEmpty( tileCoordinate, unique )
	return self.maps_[MapUtils.tile_2_unique(tileCoordinate)] == U_EMPTY
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
			local value = self.maps_[MapUtils.tile_2_unique(cc.p(i, j))]
			if value ~= U_EMPTY and value.unique_ ~= unique then
				return false
			end
		end
	end
	return true
end

-- 是否点击到unit
function MapCache:isTouchedUnit( tileCoordinate )
	local unit = self.maps_[MapUtils.tile_2_unique(tileCoordinate)]
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

return MapCache