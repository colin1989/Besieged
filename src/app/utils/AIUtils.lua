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
		local selfposition = EntityManager:getComponent("TransformComponent", self)
		local vertex = cc.p(selfposition.vx, selfposition.vy)
		local gridId = game.g_mapSize.width * vertex.y + vertex.x
		if not weight or weight > graph[gridId] then
			weight = graph[gridId]
			enemy = entity
		end
	end
	blackboard:Set("target", enemy)
	return enemy and BTStatus.ST_TRUE or BTStatus.ST_FALSE
end

function AIUtils.idle( self, blackboard )
	print("Idle")
	return BTStatus.ST_TRUE
end

function AIUtils.move( self, blackboard )
	print("Move")
	local enemy = blackboard:Get("target")
	if not enemy then
		return BTStatus.ST_FALSE
	end

	local selfposition = EntityManager:getComponent("TransformComponent", self)
	local enemyposition = EntityManager:getComponent("TransformComponent", enemy)

	local selfPos = cc.p(selfposition.px, selfposition.py)
	local targetPos = cc.p(enemyposition.px, enemyposition.py)
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

	selfposition.px = selfPos.x + normalize.x
	selfposition.py = selfPos.y + normalize.y

	return BTStatus.ST_RUNNING
end

function AIUtils.attack( self, blackboard )
	-- 自动攻击
	local skill = EntityManager:getComponent("SkillComponent", self)
	if skill and skill.skillInstance then
		skill.skillInstance:attack(blackboard:Get("target"))
	end
end

return AIUtils