--
-- Author: Your Name
-- Date: 2017-06-29 16:19:54
-- 用于创建组件并初始化基础信息
--
local ComponentFactory = {}

function ComponentFactory.create( componentName )
	return game[componentName]:create()
end

function ComponentFactory.createPosition( x, y, ax, ay )
	local component = ComponentFactory.create("PositionComponent")
	component.x = x
	component.y = y
	component.ax = ax
	component.ay = ay
	return component
end

function ComponentFactory.createVertex( x, y )
	local component = ComponentFactory.create("VertexComponent")
	component.x = x
	component.y = y
	return component
end

function ComponentFactory.createMovement( mx, my )
	local component = ComponentFactory.create("MovementComponent")
	component.mx = mx
	component.my = my
	return component
end

function ComponentFactory.createDB( id )
	local component = ComponentFactory.create("DBComponent")
	if 10000 <= id and id < 20000 then
		component.db = game.DB_Building.getById(id)
	elseif 20000 <= id and id < 30000 then
		component.db = game.DB_Soldier.getById(id)
	elseif 30000 <= id and id < 40000 then
		component.db = game.DB_Plant.getById(id)
	else
		assert(false, string.format("invalid db id %d", id))
	end
	component.db.row = component.db.occupy + 2 * component.db.edge
	return component
end

function ComponentFactory.createRender( parent )
	local component = ComponentFactory.create("RenderComponent")
	component.parent = parent
	component.container = display.newNode()
	component.container:addTo(parent)
	return component
end

function ComponentFactory.createRenderSubstrate( vx, vy, row )
	local component = ComponentFactory.create("RenderSubstrateComponent")
	component.vx = vx
	component.vy = vy
	component.grids = {}
	for i = component.vx, component.vx + row - 1 do
		for j = component.vy, component.vy + row - 1 do
			table.insert(component.grids, cc.p(i, j))
		end
	end
	return component
end

function ComponentFactory.createRenderPlaceBtn( ... )
	local component = ComponentFactory.create("RenderPlaceBtnComponent")
	return component
end

function ComponentFactory.createRenderColorBoard( bool )
	local component = ComponentFactory.create("RenderColorBoardComponent")
	component.bool = bool
	return component
end

function ComponentFactory.createRenderArrow( ... )
	local component = ComponentFactory.create("RenderArrowComponent")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("map/UI_Building.plist", "map/UI_Building.pvr.ccz")
	return component
end

function ComponentFactory.createState( state )
	local component = ComponentFactory.create("StateComponent")
	component.buildState = state or U_ST_BUILDED
	component.selected = false
	component.pressed = false
	return component
end

function ComponentFactory.createStore( type )
	local component = ComponentFactory.create("StoreComponent")
	component.storeType = type
	component.save = false
	component.update = false
	component.remove = false
	return component
end

function ComponentFactory.createAI( treeName, blackboard )
	local component = ComponentFactory.create("AIComponent")
	component.treeName = treeName
	component.root = nil
	component.blackboard = blackboard
	return component
end

return ComponentFactory