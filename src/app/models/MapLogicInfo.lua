local MapUtils = game.MapUtils

local MapLogicInfo = class("MapLogicInfo")
MapLogicInfo.maps_ = {}  -- 存储地形上的数据
MapLogicInfo.vertexs_ = {}  -- 根据vertex保存unit

function MapLogicInfo:ctor( mapwidth, mapheight )
	for i = 0, mapwidth - 1 do
		for j = 0, mapheight - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY  -- 初始化地图数据
		end
	end
end

function MapLogicInfo:addUnit( tileCoordinate, unit, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = unit
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = unit
end

function MapLogicInfo:clearUnit( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			self.maps_[MapUtils.tile_2_unique(cc.p(i, j))] = U_EMPTY
		end
	end
	self.vertexs_[MapUtils.tile_2_unique(tileCoordinate)] = nil
end

function MapLogicInfo:isEmpty( tileCoordinate )
	return self.maps_[MapUtils.tile_2_unique(tileCoordinate)] == U_EMPTY
end

function MapLogicInfo:isCanUse( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			if not self:isEmpty(cc.p(i, j)) then
				return false
			end
		end
	end
	return true
end

-- 是否点击到unit
function MapLogicInfo:isTouchedUnit( tileCoordinate )
	local unit = self.maps_[MapUtils.tile_2_unique(tileCoordinate)]
	if unit and unit ~= U_EMPTY and unit:operability() then
		return unit
	end
	return nil
end

function MapLogicInfo:findVertexByUnit( unit )
	for k,v in pairs(self.vertexs_) do
		if v.unique_ == unit.unique_ then
			return k
		end
	end
	return nil
end

return MapLogicInfo