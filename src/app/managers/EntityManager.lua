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
		component:destroy(entity)
		coms[componentName] = nil
		self.entityHashComponent[entity] = coms
	end

	local entities = self.componentHashEntity[componentName] or {}
	entities[entity] = nil
end

function EntityManager:removeEntity( entity )
	local singletonCurEntity = game.SingletonCurrentEntityComponent:getInstance()
	singletonCurEntity:remove(entity)

	local coms = self.entityHashComponent[entity] or {}
	for _, com in pairs(coms) do
		local entities = self.componentHashEntity[com:getName()] or {}
		entities[entity] = nil
		com:destroy(entity)
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
-- 不可用的组件获取不到
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

-- 设置组件的可用性
function EntityManager:setComponentEnabled( componentName, entity, enable )
	local component = self:getComponent(componentName, entity)
	if component then
		component.active = enable
		if not enable then
			component:destroy(entity)
		end
	end
end

function EntityManager:isComponentEnabled( componentName, entity )
	local component = self:getComponent(componentName, entity)
	if component then
		return component.active
	end
	return false
end

function EntityManager:setComponentMember( componentName, memberName, value, entity )
	local component = self:getComponent(componentName, entity)
	if component and component.active then
		component[memberName] = value
	end
end

function EntityManager:getComponentMember( componentName, memberName, entity )
	local component = self:getComponent(componentName, entity)
	if component then
		return component[memberName]
	end
	return nil
end

function EntityManager:getSingletonComponent( componentName )
	local component = game[componentName]:create()
	if component and component.super and component.super.__cname == "SingletonComponent" then
		return component
	end
	return nil
end

function EntityManager:getAllEntities( ... )
	return table.keys(self.entityHashComponent or {})
end

return EntityManager