
local MapUtils = game.MapUtils
local director = cc.Director:getInstance()

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- local layersize = layer:getLayerSize()
    -- local tilesize = layer:getMapTileSize()

    -- local pos = layer:getPositionAt(cc.p(15,24))-- 1152-1728 1152-0
    -- printInfo("%d %d", pos.x, pos.y)
    -- printInfo("size %d %d", layersize.width, layersize.height)
    -- printInfo("size %d %d", tilesize.width, tilesize.height)

    -- -- layer:getTileAt(cc.p(0, 0)):move(cc.p(layersize.width * tilesize.width, 0))
    -- local wpos = map:convertToWorldSpace(pos)
    -- printInfo("%d %d", wpos.x, wpos.y)
    -- wpos = map:convertToNodeSpace(wpos)
    -- printInfo("%d %d", wpos.x, wpos.y)

    -- local id = MapUtils.map_2_tile(map, pos)
    -- printInfo("%d %d", id.x, id.y)

    -- local grid = map:getLayer("块层1"):getTileAt(cc.p(1, 0))
    -- map:getLayer("ground"):setTileGID(33, cc.p(16, 16))
    
    -- local p = map:getLayer("块层1"):getPositionAt(cc.p(5, 5))
    -- game.factory.create():align(cc.p(0, 0), p):addTo(map)

    -- local group = map:getObjectGroup("对象层1")
    -- print(group:getGroupName())
    -- local obj = group:getObject("主建筑")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("map/Beijing-hd.plist", "map/Beijing-hd.png")

    game.Layers.ZoomLayer = game.ZoomLayer:create()
    game.Layers.MapLayer = game.MapLayer:create()
    game.Layers.TouchDispatcher = game.TouchDispatcher:create()

    self:addChild(game.Layers.TouchDispatcher)
    self:addChild(game.Layers.ZoomLayer)
    game.Layers.ZoomLayer:addChild(game.Layers.MapLayer)

    performWithDelay(self, function ( ... )
        game.NotificationManager.post("THIS_IS_COMPONENT_TEST")
    end, 5)

    -- touch   1122.0850830078 522.66546630859
    -- [LUA-print] maptouch    1194.0850830078 682.66546630859
    -- [LUA-print] tileCoordinate  28  0

 --    local jsonfile = "ui/home_menu.json"
 --    local widget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonfile)
	-- assert(widget, "load UI Error: " .. jsonfile)
	-- widget:setSize(cc.Director:getInstance():getVisibleSize())
	-- -- GUIReader:purge() -- 加载完释放Reader
	-- widget:addTo(self)
end

return MainScene
