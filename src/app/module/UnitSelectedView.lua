local UnitSelectedView = class("UnitSelectedView", game.BaseView)
UnitSelectedView.mapping_ = {
	"LAY_BUILDING",
	"LAY_SOLDIER",
	"LAY_PLANT",
}
UnitSelectedView.unit_ = nil

function UnitSelectedView:ctor( unit )
	self.unit_ = unit
	self:init("unit_select")

	for _, v in pairs(self.mapping_) do
		self._mainLayer[v]:setVisible(false)
	end
	local layout = self._mainLayer[self.mapping_[unit.type_]]
	layout:setVisible(true)

	layout.TXT_NAME:setString(unit.db_.name)

	self:binding(layout.BTN_MAKE, "onBtnMake")
	self:binding(layout.BTN_SALE, "onBtnSale")
	self:binding(layout.BTN_UPGRADE, "onBtnUpgrade")
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