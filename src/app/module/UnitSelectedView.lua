local LayerManager = game.LayerManager
local UIManager = game.UIManager
local NotificateDelegate = game.NotificateDelegate

local UnitSelectedView = class("UnitSelectedView")

function UnitSelectedView:ctor( unit )
	self._mainLayer = UIManager.loadCSB("ui/unit_select.csb")
	self._mainLayer:onNodeEvent("enter", function ( ... )
		NotificateDelegate.add(self, "UnitSelectedView")
	end)
	self._mainLayer:onNodeEvent("exit", function ( ... )
		NotificateDelegate.remove(self, "UnitSelectedView")
	end)

	local layout = self._mainLayer:getChildByName("LAY_BUILDING")

	local tfd = layout.TXT_NAME
	tfd:setString(unit.db_.name)

	layout.BTN_OK:addClickEventListener(function ( ... )
		local soldier = game.UnitFactory.newSoldier(20001, cc.p(unit.vertex_.x - 1, unit.vertex_.y - 1), unit.map_)
		game.MapManager.addUnit(soldier)
		print("UnitSelectedView BTN_OK click")
	end)
	layout.BTN_CANCEL:addClickEventListener(function ( ... )
		print("UnitSelectedView BTN_CANCEL click")
	end)

    LayerManager.addLayout(self._mainLayer, "UnitSelectedView")
end

function UnitSelectedView:destroy( ... )
	
end

-- notification delegate
function UnitSelectedView:notifications( ... )
	return {
		MSG_UNSELECTED_UNIT,
	}
end

function UnitSelectedView:MSG_UNSELECTED_UNIT( ... )
	LayerManager.removeLayout("UnitSelectedView")
end

return UnitSelectedView