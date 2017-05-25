local Unit = game.Unit
local Soldier = class("Soldier", Unit)
Soldier.behavior_ = nil

function Soldier:ctor( id )
	self:init(id, U_PEOPLE)

	self.operability_ = true
	self.behavior_ = 1
    self.render_ = display.newSprite(string.format("character/%s/run/105.0.png", self.db_.path)):move(cc.p(0, 0))
    -- 取纹理实际大小与网格大小的比例计算锚点
    self.render_:setAnchorPoint(cc.p(0.5, math.min(game.g_mapTileSize.height / self.render_:getContentSize().height, 0.5)))
    self.Node_:addChild(self.render_, 2)

    self:schedule()
end

function Soldier:update( dt )
	
end

return Soldier