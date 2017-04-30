
local UILayer = class("UILayer", cc.Layer)

function UILayer:ctor( ... )
	-- local jsonfile = "ui/unit_des.json"
 --    local widget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonfile)
	-- assert(widget, "load UI Error: " .. jsonfile)
	-- widget:setSize(cc.Director:getInstance():getVisibleSize())
	-- -- GUIReader:purge() -- 加载完释放Reader
	-- widget:addTo(self)
end

return UILayer