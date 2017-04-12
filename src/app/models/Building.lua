local Building = class("Building", game.Unit)

function Building:ctor( id, lv )
	self:init()
	self.type_ = U_BUILDING
	self.operability_ = true
	self.db_ = game.DB_Building.getById(tonumber(id))
	self.row_ = self.db_.occupy + 2 * self.db_.edge
    self.render_ = display.newSprite("building/build_barracks_lvl1.png"):move(cc.p(0, 0))
    self.Node_:addChild(self.render_, 1)

    self.background_ = game.MapUtils.createXXX(self.row_, 1)
    self.background_:setVisible(false)
    self.Node_:addChild(self.background_, 0)
end

function Building:delete( ... )
end

-- function Building:refresh( ... )
	
-- end
return Building