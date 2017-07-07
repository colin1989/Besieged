local EntitySelectedView = class("EntitySelectedView", game.BaseView)
EntitySelectedView.mapping_ = {
	"LAY_BUILDING",
	"LAY_SOLDIER",
	"LAY_PLANT",
}
EntitySelectedView.entity_ = nil

function EntitySelectedView:ctor( entity )
	self.entity_ = entity
	local dbCom = EntityManager:getInstance():getDBComponent(entity)
	self:init("unit_select.csb")

	for _, v in pairs(self.mapping_) do
		self._mainLayer[v]:setVisible(false)
	end
	local layout = self._mainLayer["LAY_BUILDING"]
	layout:setVisible(true)

	layout.TXT_NAME:setString(dbCom.db.name)

	self:binding(layout.BTN_MAKE, "onBtnMake")
	self:binding(layout.BTN_SALE, "onBtnSale")
	self:binding(layout.BTN_UPGRADE, "onBtnUpgrade")

	game.LayerManager.addLayout(self._mainLayer, self.__cname)
	return self._mainLayer
end

function EntitySelectedView:onBtnMake( ... )
	print("EntitySelectedView BTN_MAKE click")
end

function EntitySelectedView:onBtnSale( ... )
	print("EntitySelectedView BTN_SALE click")
	self:destroy()
end

function EntitySelectedView:onBtnUpgrade( ... )
	print("EntitySelectedView BTN_UPGRADE click")
end

-- notification delegate
function EntitySelectedView:notifications( ... )
	return {
	}
end


return EntitySelectedView