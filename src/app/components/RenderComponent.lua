--
-- Author: Your Name
-- Date: 2017-06-27 18:18:50
--
local RenderComponent = class("RenderComponent", game.Component)
RenderComponent.parent = nil
RenderComponent.container = nil  -- 基础容器
RenderComponent.sprite = nil 	  -- 静态图
RenderComponent.animate = nil    -- 特效
RenderComponent.isStatic = false 
RenderComponent.assetName = nil  -- 资源名
function RenderComponent:ctor( ... )
end

function RenderComponent:destroy( ... )
	if self.container and self.container:getParent() then
		self.container:removeSelf()
		self.container = nil
	end
end
return RenderComponent