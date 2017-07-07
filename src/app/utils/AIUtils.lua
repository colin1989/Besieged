--
-- Author: Your Name
-- Date: 2017-07-06 17:50:18
--
local AIUtils = {}
local EntityManager = game.EntityManager:getInstance()

function AIUtils.findEnemy( self, blackboard )
	local enemy = nil
	local weight = nil
	local graphes = EntityManager:getGridManager():getAllGraph()
	for entity, graph in pairs(graphes) do
		local selfposition = EntityManager:getComponent("PositionComponent", self)
		local vertex = game.MapUtils.map_2_tile(game.MapManager.getMap(), selfposition)
		local gridId = game.g_mapSize.width * vertex.y + vertex.x
		if not weight or weight > graph[gridId] then
			weight = graph[gridId]
			enemy = entity
		end
	end
	blackboard.target = enemy
	return enemy and BTStatus.ST_TRUE or BTStatus.ST_FALSE
end

function AIUtils.idle( self, blackboard )
	print("Idle")
	return BTStatus.ST_TRUE
end

function AIUtils.move( self, blackboard )
	--- 待优化
	--- 将enemy的位置、speed添加到MovementComponent中
	--- 问题是怎么获取回调?
	--- Movement 每帧修改位置，并保存状态为running；当位置到达，状态修改为true；
	print("Move")
	local enemy = blackboard.target
	if not enemy then
		return BTStatus.ST_FALSE
	end
	blackboard.target = nil

	local selfposition = EntityManager:getComponent("PositionComponent", self)
	local enemyposition = EntityManager:getComponent("PositionComponent", enemy)

	local selfPos = cc.p(selfposition.x, selfposition.y)
	local targetPos = cc.p(enemyposition.x, enemyposition.y)
	-- print("selfPos ", selfPos.x, selfPos.y)
	-- print("targetPos ", targetPos.x, targetPos.y)
	local normalize = cc.pNormalize(cc.pSub(targetPos, selfPos))
	local speed = 5
	normalize = cc.pMul(normalize, speed)
	if math.abs(targetPos.x - selfPos.x) < math.abs(normalize.x) then
		normalize.x = math.abs(targetPos.x - selfPos.x) * (math.abs(normalize.x) / normalize.x)
	elseif math.abs(targetPos.y - selfPos.y) < math.abs(normalize.y) then
		normalize.y = math.abs(targetPos.y - selfPos.y) * (math.abs(normalize.y) / normalize.y)
	end
	if normalize.x == 0 and normalize.y == 0 then
		return BTStatus.ST_TRUE
	end
	-- print("normalize ", normalize.x, normalize.y)

	selfposition.x = selfPos.x + normalize.x
	selfposition.y = selfPos.y + normalize.y

	return BTStatus.ST_RUNNING
end

return AIUtils