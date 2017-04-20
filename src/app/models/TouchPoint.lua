local TouchPoint = {}
TouchPoint.points_ = {}
function TouchPoint.touchBegan( event )
	local p1, p2 = game.MapUtils.getPoints(event)
	table.insert(TouchPoint.points_, p1)
	if p2 then
		table.insert(TouchPoint.points_, p2)
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