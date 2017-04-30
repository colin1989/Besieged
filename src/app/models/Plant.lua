local Plant = class("Plant", game.Unit)

function Plant:ctor( id )
	self.type_ = U_PLANT
	self:init(id)

	self.operability_ = false  -- 不可操作
    self.render_ = display.newSprite(string.format("plant/%s.png", self.db_.path)):move(cc.p(0, 0))
    local logic_height = self.db_.occupy * game.g_mapTileSize.height  -- 逻辑高度，与纹理尺寸无关
    local anchorY = self.render_:getContentSize().height > logic_height and (logic_height / 2 / self.render_:getContentSize().height) or 0.5
    self.render_:setAnchorPoint(cc.p(0.5, anchorY))
    self.Node_:addChild(self.render_, 2)

    print("Plant anchor point y ", anchorY)
end


return Plant