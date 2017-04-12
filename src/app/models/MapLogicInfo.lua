local MapUtils = game.MapUtils

local MapLogicInfo = class("MapLogicInfo")
MapLogicInfo.maps_ = {}

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
end

function MapLogicInfo:isEmpty( tileCoordinate )
	return self.maps_[MapUtils.tile_2_unique(tileCoordinate)] == U_EMPTY
end

function MapLogicInfo:isCanUse( tileCoordinate, row )
	for i = tileCoordinate.x, tileCoordinate.x + row - 1 do
		for j = tileCoordinate.y, tileCoordinate.y + row - 1 do
			if not game.MapUtils.isIndexValid(cc.p(i, j)) or not self:isEmpty(cc.p(i, j)) then
				return false
			end
		end
	end
	return true
end

-- 是否点击到unit
function MapLogicInfo:isTouchedUnit( tileCoordinate )
	if not MapUtils.isIndexValid(tileCoordinate) then
		return nil
	end
	local unit = self.maps_[MapUtils.tile_2_unique(tileCoordinate)]
	if unit and unit ~= U_EMPTY and unit:operability() then
		return unit
	end
	return nil
end

return MapLogicInfo