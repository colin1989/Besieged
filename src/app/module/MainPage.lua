local MainPage = class("MainPage", game.BaseView)

function MainPage:ctor( ... )
	self:init("mainpage")
	self:binding(self._mainLayer.BTN_SHOP, "onBtnShop")
end

function MainPage:notifications( ... )
	return {
	}
end

function MainPage:onBtnShop( ... )
	local vertex = game.MapManager.findEmptyArea(8)
	if vertex then
		-- game.MapManager.addUnitById(10004, vertex, U_ST_WAITING)	
		game.EntityFactory.createBuilding(10001, vertex, U_ST_WAITING)
	end
end

return MainPage