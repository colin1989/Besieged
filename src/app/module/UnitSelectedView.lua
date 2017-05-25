local LayerManager = game.LayerManager
local UIManager = game.UIManager
local NotificateDelegate = game.NotificateDelegate

local UnitSelectedView = class("UnitSelectedView")
UnitSelectedView.mapping_ = {
	"LAY_BUILDING",
	"LAY_SOLDIER",
	"LAY_PLANT",
}
UnitSelectedView.unit_ = nil

function UnitSelectedView:ctor( unit )
	self.unit_ = unit
	self._mainLayer = UIManager.loadCSB("ui/unit_select.csb")
	self._mainLayer:onNodeEvent("enter", function ( ... )
		NotificateDelegate.add(self, "UnitSelectedView")
	end)
	self._mainLayer:onNodeEvent("exit", function ( ... )
		NotificateDelegate.remove(self, "UnitSelectedView")
	end)

	for _, v in pairs(self.mapping_) do
		self._mainLayer[v]:setVisible(false)
	end
	local layout = self._mainLayer[self.mapping_[unit.type_]]
	layout:setVisible(true)

	layout.TXT_NAME:setString(unit.db_.name)

	if layout.BTN_MAKE then
		layout.BTN_MAKE:addClickEventListener(function ( ... ) self:onBtnMake(...) end)
	end
	if layout.BTN_SALE then
		layout.BTN_SALE:addClickEventListener(function ( ... ) self:onBtnSale(...) end)
	end
	if layout.BTN_UPGRADE then
		layout.BTN_UPGRADE:addClickEventListener(function ( ... ) self:onBtnUpgrade(...) end)
	end

    LayerManager.addLayout(self._mainLayer, "UnitSelectedView")
end

function UnitSelectedView:onBtnMake( ... )
	print("UnitSelectedView BTN_MAKE click")
	local soldier = game.UnitFactory.newSoldier(20001, cc.p(self.unit_.vertex_.x - 1, self.unit_.vertex_.y - 1), self.unit_.map_)
	game.MapManager.addUnit(soldier)
end

function UnitSelectedView:onBtnSale( ... )
	print("UnitSelectedView BTN_SALE click")
	game.MapManager.removeUnit(self.unit_)
	self:destroy()
end

function UnitSelectedView:onBtnUpgrade( ... )
	print("UnitSelectedView BTN_UPGRADE click")
end

function UnitSelectedView:destroy( ... )
	LayerManager.removeLayout("UnitSelectedView")
end

-- notification delegate
function UnitSelectedView:notifications( ... )
	return {
		MSG_UNIT_UNSELECTED,
	}
end

function UnitSelectedView:MSG_UNIT_UNSELECTED( ... )
	self:destroy()
end

return UnitSelectedView