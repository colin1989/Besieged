--[[
	存储一次触摸流程中的触摸点
]]

local TouchPoint = {}
TouchPoint.points_ = {}
function TouchPoint.touchBegan( event )
	local ps = {game.MapUtils.getPoints(event)}
	for _, p in pairs(ps or {}) do
		table.insert(TouchPoint.points_, p)
	end
end
function TouchPoint.touchMoved( event )
	local points = {game.MapUtils.getPoints(event)}
	for _, v in pairs(points or {}) do
		for k, p in pairs(TouchPoint.points_) do
			if v.touchid == p.touchid then
				p.x = v.x
				p.y = v.y
			end
		end
	end
end

function TouchPoint.touchEnded( event )
	local points = {game.MapUtils.getPoints(event)}
	for _, v in pairs(points or {}) do
		for k, p in pairs(TouchPoint.points_) do
			if v.touchid == p.touchid then
				table.remove(TouchPoint.points_, k)
			end
		end
	end
end

function TouchPoint.touchCancelled( event )
	local points = {game.MapUtils.getPoints(event)}
	for _, v in pairs(points or {}) do
		for k, p in pairs(TouchPoint.points_) do
			if v.touchid == p.touchid then
				table.remove(TouchPoint.points_, k)
			end
		end
	end
end

return TouchPoint