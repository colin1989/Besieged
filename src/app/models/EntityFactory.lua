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
	EntityManager:addComponent(ComponentFactory.createPosition(0, 0, 0.5, 0.5), entity)
	-- EntityManager:addComponent(ComponentFactory.createMovement(0, 0), entity)
	EntityManager:addComponent(ComponentFactory.createState(state), entity)

	EntityManager:addComponent(ComponentFactory.createRenderSubstrate(vertex.x, vertex.y, dbCom.db.row), entity)
	EntityManager:addComponent(ComponentFactory.createRenderArrow(), entity)
	EntityManager:addComponent(ComponentFactory.createRenderPlaceBtn(), entity)

	local isEmpty = EntityManager:getGridManager():isAreaEmpty(vertex.x, vertex.y, dbCom.db.row, entity)
	EntityManager:addComponent(ComponentFactory.createRenderColorBoard(isEmpty), entity)
	local renderCom = ComponentFactory.createRender(game.MapManager.getMap())
	renderCom.assetName = string.format("%s/%s_lvl%s.png", buildingAssetPath, dbCom.db.path, dbCom.db.level)
	renderCom.isStatic = true
	EntityManager:addComponent(renderCom, entity)
	
	EntityManager:addComponent(game.SingletonTouchComponent:getInstance(), entity)
	EntityManager:addComponent(game.SingletonCurrentEntityComponent:getInstance(), entity)
	-- 按位置存储
	EntityManager:addComponent(ComponentFactory.createStore(STORE_POSITION), entity)	
	-- 等待状态的禁用存储组件
	EntityManager:setComponentEnabled("StoreComponent", entity, state ~= U_ST_WAITING)
	EntityManager:setComponentMember("StoreComponent", "save", true, entity)
	EntityManager:addComponent(game.BreakableComponent:create(), entity)
	
	return entity
end

function EntityFactory.createPlant( id, vertex )
	local plantAssetPath = "plant"
	local entity = EntityManager:createEntity()
	local dbCom = ComponentFactory.createDB(id)
	EntityManager:addComponent(dbCom, entity)
	EntityManager:addComponent(ComponentFactory.createVertex(vertex.x, vertex.y), entity)
	EntityManager:addComponent(ComponentFactory.createPosition(0, 0, 0.5, 0.5), entity)
	EntityManager:addComponent(ComponentFactory.createState(), entity)
	EntityManager:addComponent(ComponentFactory.createRenderSubstrate(vertex.x, vertex.y, dbCom.db.row), entity)
	local renderCom = ComponentFactory.createRender(game.MapManager.getMap())
	renderCom.assetName = string.format("%s/%s.png", plantAssetPath, dbCom.db.path)
	renderCom.isStatic = true
	EntityManager:addComponent(renderCom, entity)

	EntityManager:addComponent(game.SingletonTouchComponent:getInstance(), entity)
	EntityManager:addComponent(game.SingletonCurrentEntityComponent:getInstance(), entity)
	-- 按位置存储
	EntityManager:addComponent(ComponentFactory.createStore(STORE_POSITION), entity)	
	EntityManager:setComponentMember("StoreComponent", "save", true, entity)

	return entity
end

function EntityFactory.createSoldier( id, vertex )
	local entity = EntityManager:createEntity()
	local dbCom = ComponentFactory.createDB(id)
	EntityManager:addComponent(dbCom, entity)
	local position = game.MapUtils.vertex_2_real(game.MapManager.getMap(), vertex, dbCom.db.row)
	print("soldier position", position.x, position.y)
	EntityManager:addComponent(ComponentFactory.createPosition(position.x, position.y, 0.5, 0.5), entity)
	EntityManager:addComponent(ComponentFactory.createState(), entity)
	local renderCom = ComponentFactory.createRender(game.MapManager.getMap())
	renderCom.assetName = string.format("character/arrower1/%s.png", "105.0")
	renderCom.isStatic = true
	EntityManager:addComponent(renderCom, entity)
	EntityManager:addComponent(game.SingletonTouchComponent:getInstance(), entity)
	EntityManager:addComponent(game.SingletonCurrentEntityComponent:getInstance(), entity)
	EntityManager:addComponent(ComponentFactory.createStore(STORE_LIST), entity)	
	EntityManager:setComponentMember("StoreComponent", "save", true, entity)
	-- AI
	EntityManager:addComponent(ComponentFactory.createAI("testBT", game.SoldierBlackboard:create()), entity)
end

return EntityFactory