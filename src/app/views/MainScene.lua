
local MapUtils = game.MapUtils
local director = cc.Director:getInstance()

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- local grid = map:getLayer("块层1"):getTileAt(cc.p(1, 0))
    -- local p = map:getLayer("块层1"):getPositionAt(cc.p(5, 5))

    -- local group = map:getObjectGroup("对象层1")
    -- print(group:getGroupName())
    -- local obj = group:getObject("主建筑")
    cc.Texture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
    cc.Image:setPVRImagesHavePremultipliedAlpha(true)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("map/Beijing-hd.plist", "map/Beijing-hd.png")

    game.Layers.ZoomLayer = game.ZoomLayer:create()
    game.Layers.MapLayer = game.MapLayer:create()
    game.Layers.TouchDispatcher = game.TouchDispatcher:create()

    self:addChild(game.Layers.TouchDispatcher)
    self:addChild(game.Layers.ZoomLayer)
    game.Layers.ZoomLayer:addChild(game.Layers.MapLayer)

    -- init tmx
    local map = cc.TMXTiledMap:create("map/mymap.tmx")
        :align(cc.p(0.5, 0.5), display.center)
        :addTo(game.Layers.MapLayer)
        :setMapOrientation(3)
        :setScale(0.5)
    game.Layers.MapLayer:setMap(map)

    local mapsize = map:getMapSize()      
    game.g_mapSize = mapsize
    game.g_mapGridNum = mapsize.width * mapsize.height
    game.g_mapTileSize = map:getTileSize()

    game.MapManager.init()

    performWithDelay(self, function ( ... )
        game.NotificationManager.post("TEST")
    end, 1/60)

 --    local jsonfile = "ui/home_menu.json"
 --    local widget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonfile)
	-- assert(widget, "load UI Error: " .. jsonfile)
	-- widget:setSize(cc.Director:getInstance():getVisibleSize())
	-- -- GUIReader:purge() -- 加载完释放Reader
	-- widget:addTo(self)
end

return MainScene
