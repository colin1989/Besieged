--
-- Author: Your Name
-- Date: 2017-07-06 14:16:03
-- entity的可操作属性
--
local AttributeComponent = class("AttributeComponent", game.Component)
AttributeComponent.upgrade = false
AttributeComponent.sale = false
AttributeComponent.make = nil

return AttributeComponent