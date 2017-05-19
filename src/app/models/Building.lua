local Unit = game.Unit
local Building = class("Building", Unit)

function Building:ctor( id )
	self.type_ = U_BUILDING
	self:init(id)
	self.operability_ = true
    self.render_ = display.newSprite(string.format("building/%s_lvl%s.png", self.db_.path, self.level_)):move(cc.p(0, 0))
    local logic_height = self.db_.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
    self.render_:setAnchorPoint(cc.p(0.5, logic_height / 2 / self.render_:getContentSize().height))
    self.Node_:addChild(self.render_, 2)

    -- 红绿检测底板
    self.background_ = game.MapUtils.createXXX(self.row_, 1):move(cc.p(0, 0))
    self.background_:setVisible(false)
    self.background_.flag = true
    self.Node_:addChild(self.background_, 0)

    -- 箭头
    cc.SpriteFrameCache:getInstance():addSpriteFrames("map/UI_Building.plist", "map/UI_Building.pvr.ccz")
	self.BATCH_ARROWS_ = cc.SpriteBatchNode:create("map/UI_Building.pvr.ccz"):addTo(self.Node_, 1)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou1.png")
		:align(cc.p(0,0), game.g_mapTileSize.width/4 * self.row_, game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou2.png")
		:align(cc.p(1,1), -game.g_mapTileSize.width/4 * self.row_, -game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou3.png")
		:align(cc.p(1,0), -game.g_mapTileSize.width/4 * self.row_, game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	cc.Sprite:createWithSpriteFrameName("ui_map_btn_jiantou4.png")
		:align(cc.p(0,1), game.g_mapTileSize.width/4 * self.row_, -game.g_mapTileSize.height/4 * self.row_)
		:addTo(self.BATCH_ARROWS_)
	self.BATCH_ARROWS_:setVisible(false)

	-- 建造和取消按钮
	self.BTN_OK_ = ccui.Button:create()
	self.BTN_OK_:loadTextures("ui/ui_public_btn_ok.png", "ui/ui_public_btn_ok.png", nil)
	self.BTN_OK_:setPosition(cc.p(self.BTN_OK_:getContentSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
	self.Node_:addChild(self.BTN_OK_, 2)
	self.BTN_OK_:addClickEventListener(function ( ... )
		-- game.TouchStatus.switch_ccui()
		self:onBtnBuild(...)
	end)

	self.BTN_CANCEL_ = ccui.Button:create()
	self.BTN_CANCEL_:loadTextures("ui/ui_public_btn_closed.png", "ui/ui_public_btn_closed.png", nil)
	self.BTN_CANCEL_:setPosition(cc.p(-self.BTN_CANCEL_:getContentSize().width/2, self.row_ / 2 * game.g_mapTileSize.height))
	self.Node_:addChild(self.BTN_CANCEL_, 3)
	self.BTN_CANCEL_:addClickEventListener(function ( ... )
		-- game.TouchStatus.switch_ccui()
		self:onBtnRemove(...)
	end)
end


return Building