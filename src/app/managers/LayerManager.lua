--[[
	层管理器
	支持切换模块和弹出层
]]

-- local UILayer = game.Layers.UILayer

local LayerManager = {}
local currentModule_ = {
	name = "",
	layout = nil,
}
local layoutStack_ = {}

function LayerManager.replaceLayout( layout, name )
	-- 移除现存的层
	if currentModule_.layout then
		game.Layers.UILayer:removeChild(currentModule_.layout)
	end
	currentModule_.name = name
	currentModule_.layout = layout
	game.Layers.UILayer:addChild(layout)
end

-- layout 层
-- name 层名
-- action true|false 是否弹出效果
function LayerManager.addLayout( layout, name, action )
	table.insert(layoutStack_, {name = name, layout = layout})
	game.Layers.UILayer:addChild(layout)
	if action then
		local actions = {}
		actions[#actions + 1] = cc.ScaleTo:create(0.1, 1.2)
		actions[#actions + 1] = cc.ScaleTo:create(0.05, 0.9)
		actions[#actions + 1] = cc.ScaleTo:create(0.05, 1)
		layout:runAction(cc.Sequence:create(actions))
	end
	return #layoutStack_
end


function LayerManager.removeLayout( id )
	local layout = table.remove(layoutStack_, id)
	layout:removeSelf()
end

-- name为空则默认删除最上层的layout
function LayerManager.removeLayoutByName( name )
	if name then
		for k, v in pairs(layoutStack_ or {}) do
			if v.name == name then
				table.remove(layoutStack_, k)
				v.layout:removeFromParent()
				return
			end
		end
	else
		local module = table.remove(layoutStack_, #layoutStack_)
		module.layout:removeFromParent()
	end
end

return LayerManager