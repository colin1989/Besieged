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
GridManager.gridInfo = {}

-- 存储所有根据位置存储的entity的顶点
GridManager.vertexInfo = {}

GridManager.listInfo = {}

-- 势力图
GridManager.influenceGraph = {}

-- 添加实体到数据中，实体必须具有DBComponent、VertexComponent组件
function GridManager:addEntity( entity, storetype )
	if storetype == STORE_POSITION then
		local dbComponent = game.EntityManager:getInstance():getDBComponent(entity)
		local vertexComponent = game.EntityManager:getInstance():getComponent("VertexComponent", entity)
		assert(dbComponent and vertexComponent, "Entity add to grid data need DBComponent and VertexComponent!")
		for i = vertexComponent.x, vertexComponent.x + dbComponent.db.row - 1 do
			for j = vertexComponent.y, vertexComponent.y + dbComponent.db.row - 1 do
				local gridId = game.g_mapSize.width * i + j
				assert(not self.gridInfo[gridId], string.format("Grid %d not empty!", gridId))
				self.gridInfo[gridId] = entity
			end
		end
		self.vertexInfo[entity] = vertexComponent.x * 100 + vertexComponent.y

		self.influenceGraph[entity] = game.MapUtils.createInfluenceGraph(cc.p(vertexComponent.x, vertexComponent.y), dbComponent.db.row)
	elseif storetype == STORE_LIST then
		for _, v in pairs(self.listInfo) do
			assert(v ~= entity, "list info already have entity "..entity)
		end
		table.insert(self.listInfo, entity)
	end

	print("addEntity grid data", table.nums(self.gridInfo))
	return entity
end

function GridManager:updateEntity( entity, storetype )
	self:removeEntity(entity, storetype)
	self:addEntity(entity, storetype)
	return entity
end

function GridManager:removeEntity( entity, storetype )
	if storetype == STORE_POSITION then
		for i = 0, game.g_mapSize.width - 1 do
			for j = 0, game.g_mapSize.height - 1 do
				local gridId = game.g_mapSize.width * i + j
				if self.gridInfo[gridId] == entity then
					self.gridInfo[gridId] = nil
				end
			end
		end
		self.vertexInfo[entity] = nil
		self.influenceGraph[entity] = nil
	elseif storetype == STORE_LIST then
		for k, v in pairs(self.listInfo) do
			table.remove(self.listInfo, k)
			break
		end
	end

	print("removeEntity grid data", table.nums(self.gridInfo))
	return entity
end

function GridManager:getVertex( entity )
	local v = self.vertexInfo[entity]
	return cc.p(math.floor(v/100), v%100)
end

function GridManager:isTouchEntity( tileX, tileY )
	local gridId = game.g_mapSize.width * tileX + tileY
	return self.gridInfo[gridId]
end

-- 格子是否为空
function GridManager:isEmpty( tileX, tileY )
	return self:isTouchEntity(tileX, tileY) == nil
end

-- 区域是否为空
function GridManager:isAreaEmpty( vertexX, vertexY, row, exceptEntity )
	for i = vertexX, vertexX + row - 1 do
		for j = vertexY, vertexY + row - 1 do
			local gridId = game.g_mapSize.width * i + j
			if self.gridInfo[gridId] then
				if not exceptEntity or self.gridInfo[gridId] ~= exceptEntity then
					return false
				end
			end
		end
	end
	return true
end

function GridManager:findEmptyArea( row )
	for i = 0, game.g_mapSize.width - 1 - row do
		for j = 0, game.g_mapSize.height - 1 - row do
			local vertex = cc.p(i, j)
			if self:isAreaEmpty(i, j, row) then
				return vertex
			end
		end
	end
	return nil
end

function GridManager:getAllGraph( ... )
	return self.influenceGraph
end

function GridManager:getGraph( entity )
	return self.influenceGraph[entity]
end

function GridManager:dumpGraph( entity )
	local graph = self:getGraph(entity)
	if graph then
		for i = 0, game.g_mapSize.height - 1 do
	        -- print(table.concat(graph, " ", i * game.g_mapSize.width + 1, i * game.g_mapSize.width + game.g_mapSize.width))
	    end
	end
end

return GridManager