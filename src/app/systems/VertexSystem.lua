--
-- Author: Your Name
-- Date: 2017-06-28 13:55:22
-- 用于将vertex转换成实际摆放的position
--
local VertexSystem = class("VertexSystem", game.System)
local EntityManager = game.EntityManager:getInstance()
function VertexSystem:execute( ... )
	-- print("VertexSystem")
	local entities = EntityManager:getEntitiesIntersection("PositionComponent", "VertexComponent", "DBComponent")
	for _, entity in pairs(entities) do
		local positionComponent = EntityManager:getComponent("PositionComponent", entity)
		local vertexComponent = EntityManager:getComponent("VertexComponent", entity)
		local dbComponent = EntityManager:getComponent("DBComponent", entity)
		local position = game.MapUtils.vertex_2_real(game.MapManager.getMap(), cc.p(vertexComponent.x, vertexComponent.y), dbComponent.db.row)
		positionComponent.x = position.x
		positionComponent.y = position.y
	end
end

return VertexSystem