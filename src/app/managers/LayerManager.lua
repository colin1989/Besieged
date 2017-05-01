--[[
	层管理器
	支持切换模块和弹出层
]]

local UILayer = game.Layers.UILayer

local LayerManager = {}
local currentModule_ = {
	name = "",
	layout = nil,
}
local layoutStack_ = {}

function LayerManager.changeModule( layout, name )
	-- 移除现存的层
	if currentModule_.layout then
		UILayer:removeChild(currentModule_.layout)
	end
	currentModule_.name = name
	currentModule_.layout = layout
	UILayer:addChild(layout)
end

-- layout 层
-- name 层名
-- action true|false 是否弹出效果
function LayerManager.addLayout( layout, name, action )
	table.insert(layoutStack_, {name = name, layout = layout})
	UILayer:addChild(layout)
	if action then
		local actions = {}
		actions[#actions + 1] = cc.ScaleTo:create(0.1, 1.2)
		actions[#actions + 1] = cc.ScaleTo:create(0.05, 0.9)
		actions[#actions + 1] = cc.ScaleTo:create(0.05, 1)
		layout:runAction(cc.Sequence:create(actions))
	end
end


-- name为空则默认删除最上层的layout
function LayerManager.removeLayout( name )
	if name then
		for k, v in pairs(layoutStack_ or {}) do
			if v.name == name then
				table.remove(layoutStack_, k)
				v.layout:removeFromParent()
				return
			end
		end
	else
		local layout = layoutStack_[#layoutStack_].layout
		layout:removeFromParent()
		table.remove(layoutStack_, #layoutStack_)
	end
end

return LayerManager