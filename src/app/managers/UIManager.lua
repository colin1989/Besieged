local UIManager = {}


function UIManager.loadCSB( fileName )
	local layout = cc.CSLoader:createNode(fileName)
    assert(layout , string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    -- layout:setPosition(cc.p(-display.cx, -display.cy))
    layout:setPosition(cc.p(0, 0))
    layout:setScale(display.width / 960)
    return layout
end

return UIManager