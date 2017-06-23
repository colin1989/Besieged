
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

    -- print(cc.pGetAngle(cc.p(0, 0), cc.p(2, 2)))
    -- print(cc.pGetAngle(cc.p(0, 0), cc.p(0, 2)))
    -- print(cc.pGetAngle(cc.p(0, 0), cc.p(2, 0)))
    -- print(cc.pGetAngle(cc.p(0, 0), cc.p(1.3, 2)))
    -- local p1 = cc.pNormalize(cc.pSub(cc.p(2, 2), cc.p(0, 0)))
    -- local p2 = cc.pNormalize(cc.pSub(cc.p(0, 2), cc.p(0, 0)))
    -- local p3 = cc.pNormalize(cc.pSub(cc.p(2, 0), cc.p(0, 0)))
    -- local p4 = cc.pNormalize(cc.pSub(cc.p(1.3, 2), cc.p(0, 0)))
    -- local p5 = cc.pNormalize(cc.pSub(cc.p(1, 10), cc.p(10, 1)))
    -- print(p1.x,p1.y)
    -- print(p2.x,p2.y)
    -- print(p3.x,p3.y)
    -- print(p4.x,p4.y)
    -- print(p5.x,p5.y)

    -- local tree = game.BTFactory.createTree("testBT")
    -- tree:activate()
    -- local status = "running"
    -- while status == "running" do
    --     status = tree:tick()
    --     print("tick ", status)
    -- end
    -- local agent = game.SoldierAgent:create()
    -- agent:load("testBT")
    -- agent:activate()

    -- init tmx
    local map = cc.TMXTiledMap:create("map/mymap.tmx")
        :align(cc.p(0.5, 0.5), display.center)
        :setMapOrientation(3)
        :setScale(0.5)

    game.MapManager.init(map)

    game.Layers.ZoomLayer = game.ZoomLayer:create()
    game.Layers.MapLayer = game.MapLayer:create()
    game.Layers.TouchDispatcher = game.TouchDispatcher:create()
    game.Layers.UILayer = cc.Layer:create() -- game.UILayer:create()

    map:addTo(game.Layers.MapLayer)
    self:addChild(game.Layers.TouchDispatcher)
    self:addChild(game.Layers.ZoomLayer)
    self:addChild(game.Layers.UILayer)
    game.Layers.ZoomLayer:addChild(game.Layers.MapLayer)
    game.Layers.ZoomLayer:setVisible(false)
    game.Layers.UILayer:setVisible(false)

    game.MainPage:create()

    performWithDelay(self, function ( ... )
        game.NotificationManager.post(MSG_ADD_TEST_UNIT)

        -- game.MapManager.findEmptyArea(8)
        -- game.MapManager.findEmptyArea(16)
        -- game.MapManager.findEmptyArea(32)
    end, 1/60)

    -- local p1 = game.MapUtils.tile_2_map(map, cc.p(34,1))
    -- local p2 = game.MapUtils.map_2_tile(map, cc.p(2304,1032))
    -- print(p1.x,p1.y)
    -- print(p2.x,p2.y)
end

return MainScene
