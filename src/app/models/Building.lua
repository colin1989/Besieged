local Building = class("Building", game.Unit)

function Building:ctor( id )
	self:init(id)
	self.type_ = U_BUILDING
	self.operability_ = true
    self.render_ = display.newSprite(string.format("building/%s_lvl%s.png", self.db_.path, self.level_)):move(cc.p(0, 0))
    local logic_height = self.db_.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
    self.render_:setAnchorPoint(cc.p(0.5, logic_height / 2 / self.render_:getContentSize().height))
    self.Node_:addChild(self.render_, 2)

    self.background_ = game.MapUtils.createXXX(self.row_, 1):move(cc.p(0, 0))
    self.background_:setVisible(false)
    self.background_.flag = true
    self.Node_:addChild(self.background_, 0)
end

function Building:init_db( id )
	print("building init_db")
	self.db_ = game.DB_Building.getById(tonumber(id))
	self.row_ = self.db_.occupy + 2 * self.db_.edge
	self.level_ = self.db_.level
end

-- function Building:delete( ... )
-- end

-- function Building:refresh( ... )
	
-- end

return Building