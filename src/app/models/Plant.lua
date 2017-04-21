local Plant = class("Plant", game.Unit)

function Plant:ctor( id )
	self:init(id)
	self.type_ = U_PLANT

	self.operability_ = false  -- 不可操作
    self.render_ = display.newSprite(string.format("plant/%s.png", self.db_.path)):move(cc.p(0, 0))
    local logic_height = self.db_.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
    self.render_:setAnchorPoint(cc.p(0.5, logic_height / 2 / self.render_:getContentSize().height))
    self.Node_:addChild(self.render_, 2)
end

function Plant:init_db( id )
	print("Plant init_db")
	self.db_ = game.DB_Plant.getById(tonumber(id))
	self.row_ = self.db_.occupy + 2 * self.db_.edge
end

return Plant