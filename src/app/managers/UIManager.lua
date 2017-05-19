-- local Widget = ccui.Widget

local UIManager = {}

local tbWidgetType = {
	["WID"] = "ccui.Widget", --UI中不使用 设置UI快速访问使用  liweidong
	["BTN"] = "ccui.Button", -- 按钮（Button）
	["IMG"] = "ccui.ImageView", -- 图片（ImageView）
	["TXT"] = "ccui.Text", -- 文本框（多行）
	["LAY"] = "ccui.Layout", -- 层容器
}

local function setWidgetQuickAccess()
	local function getWidget(table,key)
		local node = ccui.Helper:seekWidgetByName(table, key)--table:getChildByName(key)
		table[key] = node --缓存
		return node
	end
	for _,val in pairs(tbWidgetType) do
		local widget = cc.Node:create()
		tolua.cast(widget, val)
		local originalMetaTable = getmetatable(widget)
		local originalIndex = originalMetaTable.__index
		local function newIndexFun(table, key)
			if (type(originalIndex) == "function") then
				return originalIndex(table,key) or getWidget(table,key)
			elseif (type(originalIndex) == "table") then
				return originalIndex[key] or getWidget(table,key)
			else
				return getWidget(table,key)
			end
		end
		originalMetaTable.__index = newIndexFun
	end
end
setWidgetQuickAccess()

function UIManager.loadCSB( fileName )
	local layout = cc.CSLoader:createNode(fileName)
    assert(layout , string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    -- layout:setPosition(cc.p(-display.cx, -display.cy))
    layout:setPosition(cc.p(0, 0))
    layout:setScale(display.width / 960)
    return layout
end

return UIManager