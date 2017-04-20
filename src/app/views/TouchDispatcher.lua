-- if game.touchDispatcher then return end
local TouchDispatcher = class("TouchDispatcher", cc.Layer)
local zoom = game.Layers.ZoomLayer
local map = game.Layers.MapLayer
local TouchStatus = game.TouchStatus
local TouchPoint = game.TouchPoint


local function touchBegan( event )
	if TouchStatus.isStatus(OP_CCUI) then
		return false
	end
	print("touch began point ", table.nums(event.points))

	TouchPoint.touchBegan(event)
	map:touchBegan(event)
	zoom:touchBegan(event)
	-- local pos = map:convertToNodeSpace(cc.p(event.x, event.y))
	return true
end

local function touchMoved( event )
	print("touch move point ", table.nums(event.points))

	TouchPoint.touchMoved(event)
	map:touchMoved(event)
	zoom:touchMoved(event)
end

local function touchEnded( event )
	print("touch end point ", table.nums(event.points))

	TouchPoint.touchEnded(event)
	map:touchEnded(event)
	zoom:touchEnded(event)
end

local function touchCancelled( event )
	TouchPoint.touchCancelled(event)
	map:touchCancelled(event)
	zoom:touchCancelled(event)
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
