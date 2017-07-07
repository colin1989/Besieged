--
-- Author: Your Name
-- Date: 2017-06-27 18:14:12
-- entity的状态
--
local StateComponent = class("StateComponent", game.Component)
StateComponent.selected = false  -- 被选中
StateComponent.pressed = false  -- 被按下
StateComponent.buildState = U_ST_BUILDED  -- 建造状态
StateComponent.invalidPosition = false  -- 非法的位置
return StateComponent