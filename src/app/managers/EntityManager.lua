--
-- Author: Your Name
-- Date: 2017-06-27 18:35:44
--
local EntityManager = class("EntityManager")
-- 用entity索引与这个entity绑定的components
-- 结构：{
-- 	entity = {
-- 		componentName = component,
-- 		componentName = component,
-- 		...
-- 	}
-- }
EntityManager.entityHashComponent = {}

-- 用componentName索引所有相关的entity
-- 结构：{
-- 	componentName = {
-- 		entity = entity,
-- 		entity = entity,
-- 		...
-- 	}
-- }
EntityManager.componentHashEntity = {}



local instance = nil
function EntityManager.getInstance( ... )
	if not instance then
		print("create EntityManager instance")
		instance = EntityManager:create()
	end
	return instance
end

function EntityManager:ctor( ... )
	self.gridManager = game.GridManager:create()
end

function EntityManager:getGridManager( ... )
	return self.gridManager
end

function EntityManager:createEntity( ... )
	return os.time() + os.clock() + math.random()%100
end

function EntityManager:addComponent( component, entity )
	local coms = self.entityHashComponent[entity] or {}
	coms[component:getName()] = component
	self.entityHashComponent[entity] = coms

	local entities = self.componentHashEntity[component:getName()] or {}
	entities[entity] = entity
	self.componentHashEntity[component:getName()] = entities
end

function EntityManager:removeComponent( componentName, entity )
	local coms = self.entityHashComponent[entity] or {}
	local component = coms[componentName]
	if component then
		component:destroy()
		coms[componentName] = nil
		self.entityHashComponent[entity] = coms
	end

	local entities = self.componentHashEntity[componentName] or {}
	entities[entity] = nil
end

function EntityManager:removeEntity( entity )
	local coms = self.entityHashComponent[entity] or {}
	for _, com in pairs(coms) do
		local entities = self.componentHashEntity[com:getName()] or {}
		entities[entity] = nil
		com:destroy()
	end
	self.entityHashComponent[entity] = nil
end

-- 所有实体都会对应db信息，所以单独抽离出此方法
function EntityManager:getDBComponent( entity )
	return self:getComponent("DBComponent", entity)
end

-- 获取与指定组件名相关的所有实体
function EntityManager:getEntities( componentName )
	return self.componentHashEntity[componentName] or {}
end

-- 获取指定实体的所有组件实例
function EntityManager:getComponents( entity )
	return self.entityHashComponent[entity] or {}
end

-- 获取指定实体的某个组件
function EntityManager:getComponent( componentName, entity )
	return self:getComponents(entity)[componentName]
end

function EntityManager:getEntitiesIntersection( componentNames, ... )
	local args = {componentNames, ...}
	local components = {}
	for k, name in pairs(args) do
		table.insert(components, EntityManager:getEntities(name))
	end
	return table.intersection(components)
end

return EntityManager