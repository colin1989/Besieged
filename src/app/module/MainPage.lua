local MainPage = class("MainPage", game.BaseView)

function MainPage:ctor( ... )
	self:init("mainpage.csb")
	self:binding(self._mainLayer.BTN_SHOP, "onBtnShop")
	game.LayerManager.addLayout(self._mainLayer, self.__cname)
end

function MainPage:notifications( ... )
	return {
	}
end

function MainPage:onBtnShop( ... )
	local vertex = game.MapManager.findEmptyArea(8)
	if vertex then
		-- game.MapManager.addUnitById(10004, vertex, U_ST_WAITING)	
		local entity = game.EntityFactory.createBuilding(10004, vertex, U_ST_WAITING)
		-- 切换当前操作的entity
		local singletonCurEntity = game.SingletonCurrentEntityComponent:getInstance()
		singletonCurEntity:switch(entity)
    	-- game.EntityManager:getInstance():getGridManager():addEntity(entity)
	end
end

return MainPage