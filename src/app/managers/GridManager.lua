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
	for i = vertexComponent.x, vertexComponent.x + dbComponent.db.row - 1 do
		for j = vertexComponent.y, vertexComponent.y + dbComponent.db.row - 1 do
			local gridId = game.g_mapSize.width * i + j
			assert(not self.gridData[gridId], string.format("Grid %d not empty!", gridId))
			self.gridData[gridId] = entity
		end
	end

	print("grid data", table.nums(self.gridData))
end

function GridManager:removeEntity( entity )
	for i = 0, game.g_mapSize.width - 1 do
		for j = 0, game.g_mapSize.height - 1 do
			local gridId = game.g_mapSize.width * i + j
			if self.gridData[gridId] == entity then
				self.gridData[gridId] = nil
			end
		end
	end
	print("grid data", table.nums(self.gridData))
end

return GridManager