--[[
	触摸事件分发
]]

-- if game.touchDispatcher then return end
local TouchDispatcher = class("TouchDispatcher", cc.Layer)
local zoom = game.Layers.ZoomLayer
local map = game.Layers.MapLayer

local function touchBegan( event )
	local touchCom = game.SingletonTouchComponent:getInstance()
	if not touchCom.state then
		touchCom.touches = {}
		touchCom.preTile = nil
		touchCom.isMoved = false
	end
	touchCom.state = "began"
	touchCom.nums = touchCom.nums + table.nums(event.points)
	
	local ps = {game.MapUtils.getPoints(event)}
	for _, p in pairs(ps or {}) do
		touchCom.touches[p.touchid] = p
	end
	-- print("234", table.nums(touchCom.touches))
	if touchCom.nums == 1 then
		touchCom.prePosition = ps[1]
	else
		touchCom.prePositions = table.values(touchCom.touches)
	end
	-- print("456", table.nums(touchCom.prePositions or {}))
	if not game.HandleTouchUtil.handleEntity(touchCom) then
		game.HandleTouchUtil.handleZoomLayer(touchCom)
	end
	
	return true
end

local function touchMoved( event )
	-- print("touch move point ", table.nums(event.points))
	local touchCom = game.SingletonTouchComponent:getInstance()
	touchCom.state = "moved"
	touchCom.isMoved = true
	local ps = {game.MapUtils.getPoints(event)}
	for _, p in pairs(ps or {}) do
		touchCom.touches[p.touchid] = p
	end
	if not game.HandleTouchUtil.handleEntity(touchCom) then
		game.HandleTouchUtil.handleZoomLayer(touchCom)
	end
	if touchCom.nums == 1 then
		touchCom.prePosition = ps[1]
	else
		touchCom.prePositions = table.values(touchCom.touches)
	end
end

local function touchEnded( event )
	-- print("touch end point ", table.nums(event.points))
	local touchCom = game.SingletonTouchComponent:getInstance()
	touchCom.state = "ended"
	touchCom.nums = touchCom.nums - table.nums(event.points)
	local ps = {game.MapUtils.getPoints(event)}
	for _, p in pairs(ps or {}) do
		touchCom.touches[p.touchid] = p
	end
	
	if not game.HandleTouchUtil.handleEntity(touchCom) then
		game.HandleTouchUtil.handleZoomLayer(touchCom)
	end
	if touchCom.nums == 1 then
		touchCom.prePosition = table.values(touchCom.touches)[1]
	else
		touchCom.prePositions = table.values(touchCom.touches)
	end
	touchCom.state = nil
end

-- local function touchCancelled( event )
-- 	local touchCom = game.SingletonTouchComponent:getInstance()
-- 	touchCom.state = "cancelled"
-- 	touchCom.nums = touchCom.nums - table.nums(event.points)
-- 	local ps = {game.MapUtils.getPoints(event)}
-- 	for _, p in pairs(ps or {}) do
-- 		touchCom.touches[p.touchid] = p
-- 	end
	
-- 	if not game.HandleTouchUtil.handleEntity(touchCom) then
-- 		game.HandleTouchUtil.handleZoomLayer(touchCom)
-- 	end
-- 	if touchCom.nums == 1 then
-- 		touchCom.prePosition = table.values(touchCom.touches)[1]
-- 	else
-- 		touchCom.prePositions = table.values(touchCom.touches)
-- 	end
-- 	touchCom.state = nil
-- end

function TouchDispatcher:ctor( ... )
	local events = {
		began = touchBegan,
		moved = touchMoved,
		ended = touchEnded,
		cancelled = touchEnded,
	}
	self:move(cc.p(0, 0))
    	:onTouch(function ( event )
            if events[event.name] then
            	events[event.name](event)
            end
	    end, true)
end

return TouchDispatcher
