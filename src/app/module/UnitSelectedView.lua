local UnitSelectedView = class("UnitSelectedView", ccui.Layout)

function UnitSelectedView:ctor( unit )
	self:onNodeEvent("enter", function ( ... )
		game.NotificateDelegate.add(self, "UnitSelectedView")
	end)
	self:onNodeEvent("exit", function ( ... )
		game.NotificateDelegate.remove(self, "UnitSelectedView")
	end)

	local label = ccui.Text:create(unit.db_.name, "宋体", 28):move(display.cx, display.cy - 200):addTo(self)
	game.Layers.UILayer:addChild(self)
end

function UnitSelectedView:destrpy( ... )
	
end

function UnitSelectedView:notifications( ... )
	return {
		MSG_UNSELECTED_UNIT,
	}
end

function UnitSelectedView:MSG_UNSELECTED_UNIT( ... )
	print("UnitSelectedView MSG_UNSELECTED_UNIT")
	self:removeSelf()
end

return UnitSelectedView