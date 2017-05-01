local LayerManager = game.LayerManager
local UIManager = game.UIManager
local NotificateDelegate = game.NotificateDelegate

local UnitSelectedView = class("UnitSelectedView")

function UnitSelectedView:ctor( unit )
	self._mainLayer = UIManager.loadCSB("ui/MainScene.csb")
	self._mainLayer:onNodeEvent("enter", function ( ... )
		NotificateDelegate.add(self, "UnitSelectedView")
	end)
	self._mainLayer:onNodeEvent("exit", function ( ... )
		NotificateDelegate.remove(self, "UnitSelectedView")
	end)
	local tfd = self._mainLayer:getChildByName("TXT_DES")
	self:align(cc.p(0.5, 0.5), display.cx, display.cy)

	-- local label = ccui.Text:create(unit.db_.name, "宋体", 28):move(display.cx, display.cy - 200):addTo(self)
	-- game.LayerManager.addLayout(self, "UnitSelectedView")

    LayerManager.addLayout(self._mainLayer, "UnitSelectedView")
end

function UnitSelectedView:destrpy( ... )
	
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