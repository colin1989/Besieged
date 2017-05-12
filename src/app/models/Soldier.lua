local Unit = game.Unit
local Soldier = class("Soldier", Unit)

function Soldier:ctor( id )
	self.type_ = U_PEOPLE
	self:init(id)

	self.operability_ = true
    self.render_ = display.newSprite(string.format("soldier/%s_lvl%s.png", self.db_.path, self.level_)):move(cc.p(0, 0))
    -- 取纹理实际大小与网格大小的比例计算锚点
    self.render_:setAnchorPoint(cc.p(0.5, math.min(game.g_mapTileSize.height / self.render_:setContentSize().height, 0.5)))
    self.Node_:addChild(self.render_, 2)

    self:schedule()
end

function Soldier:update( dt )
	
end

return Soldier