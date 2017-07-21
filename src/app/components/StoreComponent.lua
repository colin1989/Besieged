--
-- Author: Your Name
-- Date: 2017-07-05 13:57:32
--
local StoreComponent = class("StoreComponent", game.Component)
local EntityManager = game.EntityManager:getInstance()
StoreComponent.save = false  -- 需要保存
StoreComponent.remove = false  -- 需要移除
StoreComponent.update = false  -- 需要更新
StoreComponent.storeType = nil  -- 存储类型

function StoreComponent:destroy( entity )
	EntityManager:getGridManager():removeEntity(entity, self.storeType)
end

return StoreComponent