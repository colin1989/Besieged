--
-- Author: Your Name
-- Date: 2017-06-30 10:54:19
--
local PlaceBtnView = class("PlaceBtnView")
PlaceBtnView.entity_ = nil

function PlaceBtnView.createLayout( entity )
	local instance = PlaceBtnView:create(entity)
	return instance.mainLayer
end

function PlaceBtnView:ctor( entity )
	self.entity_ = entity

	self.mainLayer = display.newNode():move(0, 0)
	-- 建造和取消按钮
	local BTN_OK = ccui.Button:create()
	BTN_OK:loadTextures("ui/ui_public_btn_ok.png", "ui/ui_public_btn_ok.png", nil)
	BTN_OK:setPosition(cc.p(BTN_OK:getContentSize().width/2, 0))
	self.mainLayer:addChild(BTN_OK, 2)
	BTN_OK:addClickEventListener(function ( ... )
		self:onBtnBuild(...)
	end)

	local BTN_CANCEL = ccui.Button:create()
	BTN_CANCEL:loadTextures("ui/ui_public_btn_closed.png", "ui/ui_public_btn_closed.png", nil)
	BTN_CANCEL:setPosition(cc.p(-BTN_CANCEL:getContentSize().width/2, 0))
	self.mainLayer:addChild(BTN_CANCEL, 3)
	BTN_CANCEL:addClickEventListener(function ( ... )
		self:onBtnCancel(...)
	end)
end

function PlaceBtnView:onBtnBuild( sender )
	print("onBtnBuild")
	local placeBtnComponent = game.EntityManager:getInstance():getComponent("RenderPlaceBtnComponent", self.entity_)
	assert(placeBtnComponent, "build OK need RenderPlaceBtnComponent!")
	local buildStateComponent = game.EntityManager:getInstance():getComponent("BuildStateComponent", self.entity_)
	assert(buildStateComponent, "build OK need BuildStateComponent!")
	buildStateComponent.state = U_ST_BUILDED
end

function PlaceBtnView:onBtnCancel( sender )
	local placeBtnComponent = game.EntityManager:getInstance():getComponent("RenderPlaceBtnComponent", self.entity_)
	assert(placeBtnComponent, "build cancel need RenderPlaceBtnComponent!")
	game.EntityManager:getInstance():removeEntity(self.entity_)
end

function PlaceBtnView:destroy( ... )
	
end

return PlaceBtnView