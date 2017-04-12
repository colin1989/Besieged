-- if game.touchDispatcher then return end
local TouchDispatcher = class("TouchDispatcher", cc.Layer)
local zoom = game.Layers.ZoomLayer
local map = game.Layers.MapLayer

local startPosition_ = nil
local prevPosition_ = nil

local function touchBegan( event )
	startPosition_ = event.points
	prevPosition_ = event.points
	event.start_points = event.points
	event.prev_points = event.points
	if table.nums(event.points) == 1 then
		map:touchBegan(event)
	end
	-- zoom:touchBegan(event)
	-- local pos = map:convertToNodeSpace(cc.p(event.x, event.y))
	return true
end

local function touchMoved( event )
	event.start_points = startPosition_
	event.prev_points = prevPosition_
	event.moved = true  -- 标记移动过
	if table.nums(event.points) == 1 then
		map:touchMoved(event)
	end
	-- zoom:touchMoved(event)
	prevPosition_ = event.points
end

local function touchEnded( event )
	if table.nums(event.points) == 1 then
		map:touchEnded(event)
	end
	zoom:touchEnded(event)
	startPosition_ = nil
	prevPosition_ = nil 
end

local function touchCancelled( event )
	map:touchCancelled(event)
	zoom:touchCancelled(event)
	startPosition_ = nil
	prevPosition_ = nil
end

function TouchDispatcher:ctor( ... )
	local events = {
		began = touchBegan,
		moved = touchMoved,
		ended = touchEnded,
		cancelled = touchCancelled,
	}
	self:move(cc.p(0, 0))
    	:onTouch(function ( event )
            if events[event.name] then
            	events[event.name](event)
            end
	    end, true)
end

return TouchDispatcher
