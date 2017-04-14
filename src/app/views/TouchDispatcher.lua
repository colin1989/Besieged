-- if game.touchDispatcher then return end
local TouchDispatcher = class("TouchDispatcher", cc.Layer)
local zoom = game.Layers.ZoomLayer
local map = game.Layers.MapLayer
local TouchStatus = game.TouchStatus

local startPosition_ = nil
local prevPosition_ = nil
local isMoved_ = false

local function touchBegan( event )
	if TouchStatus.isStatus(OP_CCUI) then
		return false
	end
	startPosition_ = event.points
	prevPosition_ = event.points
	isMoved_ = false
	event.start_points = event.points
	event.prev_points = event.points

	map:touchBegan(event)
	zoom:touchBegan(event)
	-- local pos = map:convertToNodeSpace(cc.p(event.x, event.y))
	return true
end

local function touchMoved( event )
	isMoved_ = true
	event.start_points = startPosition_
	event.prev_points = prevPosition_
	event.moved = isMoved_  -- 标记移动过

	map:touchMoved(event)
	zoom:touchMoved(event)
	prevPosition_ = event.points
end

local function touchEnded( event )
	event.moved = isMoved_

	map:touchEnded(event)
	zoom:touchEnded(event)
	startPosition_ = nil
	prevPosition_ = nil 
	isMoved_ = false
end

local function touchCancelled( event )
	map:touchCancelled(event)
	zoom:touchCancelled(event)
	startPosition_ = nil
	prevPosition_ = nil
	isMoved_ = false
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
