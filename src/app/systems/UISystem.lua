--
-- Author: Your Name
-- Date: 2017-07-06 11:48:18
-- 处理跟entity有关的ui
--
local UISystem = class("UISystem", game.System)
local EntityManager = game.EntityManager:getInstance()

function UISystem:execute( ... )
	local singletonCurEntity = game.SingletonCurrentEntityComponent:getInstance()

	if singletonCurEntity.preEntity then
		local uiComponent = EntityManager:getComponent("UIComponent", singletonCurEntity.preEntity)
		if uiComponent and uiComponent.mainLayer then
			uiComponent:destroy()
		end
	end
	if singletonCurEntity.entity then
		local uiComponent = EntityManager:getComponent("UIComponent", singletonCurEntity.entity)
		if uiComponent and not uiComponent.mainLayer then
			uiComponent.mainLayer = game.EntitySelectedView:create(singletonCurEntity.entity)
		end
	end
end

return UISystem