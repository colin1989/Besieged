--
-- Author: Your Name
-- Date: 2017-06-30 17:00:38
-- 存储当前触摸点
--
local super = game.SingletonComponent
local SingletonTouchComponent = class("SingletonTouchComponent", super)
-- 存储当前停留在屏幕上的触摸点集合
-- 结构：{
-- 	touchid = {x = 0, y = 0},
-- 	...
-- }
SingletonTouchComponent.touches = nil 

-- 存储当前事件的触摸点集合
SingletonTouchComponent.current = nil

-- 当前屏幕上的点的数量
SingletonTouchComponent.nums = 0

-- 触摸状态
-- began moved ended cancelled
SingletonTouchComponent.touchstate = nil

-- 上次触摸的瓦片
SingletonTouchComponent.preTile = nil

-- 是否移动过
SingletonTouchComponent.isMoved = false

-- 上次的单点坐标
SingletonTouchComponent.prePosition = nil

-- 上次的两点坐标
SingletonTouchComponent.prePositions = nil

return SingletonTouchComponent