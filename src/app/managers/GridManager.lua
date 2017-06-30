--
-- Author: Your Name
-- Date: 2017-06-30 20:35:27
--
local GridManager = class("GridManager")
-- 存储地图中格子的状态
-- 一个entity会占据多个格子
-- 结构 ：{
-- 	grid1 = {
-- 		entity1,
-- 	},
-- 	grid2 = {
-- 		entity1,
-- 	},
-- 	grid3 = {
-- 		nil,
-- 	},
-- 	...
-- }
GridManager.gridData = {}

-- 添加实体到数据中，实体必须具有DBComponent、VertexComponent组件
function GridManager:addEntity( entity )
	local dbComponent = game.EntityManager:getInstance():getDBComponent(entity)
	local vertexComponent = game.EntityManager:getInstance():getComponent("VertexComponent", entity)
	assert(dbComponent and vertexComponent, "Entity add to grid data need DBComponent and VertexComponent!")
	for i = vertexComponent.x - 1, vertexComponent.x + dbComponent.db.row - 1 do
		for j = vertexComponent.y - 1, vertexComponent.y + dbComponent.db.row - 1 do
			local gridId = game.g_mapSize.width * i + j
			assert(not self.gridData[gridId], string.format("Grid %d not empty!", gridId))
			self.gridData[gridId] = entity
		end
	end
end

function GridManager:removeEntity( entity )
	local dbComponent = game.EntityManager:getInstance():getDBComponent(entity)
	local vertexComponent = game.EntityManager:getInstance():getComponent("VertexComponent", entity)
	assert(dbComponent and vertexComponent, "Entity remove from grid data need DBComponent and VertexComponent!")
	for i = vertexComponent.x - 1, vertexComponent.x + dbComponent.db.row - 1 do
		for j = vertexComponent.y - 1, vertexComponent.y + dbComponent.db.row - 1 do
			local gridId = game.g_mapSize.width * i + j
			assert(self.gridData[gridId] == entity, string.format("Grid %d have %s, remove %s", gridId, self.gridData[gridId], entity))
			self.gridData[gridId] = nil
		end
	end
end

return GridManager