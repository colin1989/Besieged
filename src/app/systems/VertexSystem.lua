--
-- Author: Your Name
-- Date: 2017-06-28 13:55:22
-- 用于将vertex转换成实际摆放的position
--
local VertexSystem = class("VertexSystem", game.System)
local EntityManager = game.EntityManager:getInstance()
function VertexSystem:execute( ... )
	-- print("VertexSystem")
	local position_entities = EntityManager:getEntities("PositionComponent")
	local vertex_entities = EntityManager:getEntities("VertexComponent")
	local db_entities = EntityManager:getEntities("DBComponent")
	local entities = table.intersection({position_entities, vertex_entities, db_entities})
	for _, entity in pairs(entities) do
		local positionComponent = EntityManager:getComponents(entity)["PositionComponent"]
		local vertexComponent = EntityManager:getComponents(entity)["VertexComponent"]
		local dbComponent = EntityManager:getComponents(entity)["DBComponent"]
		local position = game.MapUtils.vertex_2_real(game.MapManager.getMap(), cc.p(vertexComponent.x, vertexComponent.y), dbComponent.db.row)
		positionComponent.x = position.x
		positionComponent.y = position.y
	end
end

return VertexSystem