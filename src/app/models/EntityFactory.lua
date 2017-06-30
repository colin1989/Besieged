--
-- Author: Your Name
-- Date: 2017-06-28 13:26:49
--
local EntityFactory = {}
local EntityManager = game.EntityManager:getInstance()
local ComponentFactory = game.ComponentFactory

function EntityFactory.createBuilding( id, vertex, state )
	local buildingAssetPath = "building"
	local entity = EntityManager:createEntity()
	local dbCom = ComponentFactory.createDB(id)
	EntityManager:addComponent(dbCom, entity)
	EntityManager:addComponent(ComponentFactory.createVertex(vertex.x, vertex.y), entity)
	EntityManager:addComponent(ComponentFactory.createPosition(0, 0, 0, 0), entity)
	EntityManager:addComponent(ComponentFactory.createBuildState(state), entity)

	local renderCom = ComponentFactory.createRender(game.MapManager.getMap())
	renderCom.assetName = string.format("%s/%s_lvl%s.png", buildingAssetPath, dbCom.db.path, dbCom.db.level)
	renderCom.isStatic = true
	EntityManager:addComponent(renderCom, entity)
	EntityManager:addComponent(ComponentFactory.createRenderSubstrate(vertex.x, vertex.y, dbCom.db.groundGID, dbCom.db.row), entity)
	return entity
end

function EntityFactory.createPlant( id, vertex )
	local plantAssetPath = "plant"
	local entity = EntityManager:createEntity()
	local dbCom = ComponentFactory.createDB(id)
	EntityManager:addComponent(dbCom, entity)
	EntityManager:addComponent(ComponentFactory.createVertex(vertex.x, vertex.y), entity)
	EntityManager:addComponent(ComponentFactory.createPosition(0, 0, 0, 0), entity)

	local renderCom = ComponentFactory.createRender(game.MapManager.getMap())
	renderCom.assetName = string.format("%s/%s.png", plantAssetPath, dbCom.db.path)
	renderCom.isStatic = true
	EntityManager:addComponent(renderCom, entity)
	EntityManager:addComponent(ComponentFactory.createRenderSubstrate(vertex.x, vertex.y, dbCom.db.groundGID, dbCom.db.row), entity)
	return entity
end

return EntityFactory