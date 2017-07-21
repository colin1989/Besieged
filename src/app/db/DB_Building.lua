local db = {}
-- {
-- 	id 
-- 	name 
-- 	path 
-- 	level 
--  hp
-- 	occupy 		建筑占地
-- 	edge 		边宽
-- 	build_time 	建造需要时间
-- 	cost 		建造花费
-- 	groundGID 	占地的地面id
-- 	moveable  	是否可移动
-- 	selectable  是否可选中
-- 	next_lv  	升级到的id，不可升级则为nil
-- 	saleable 	是否可出售
-- 	salemoney 	出售获得
--  make 		可建造的id序列，不可建造为nil
-- }
db.values = {
	id_10001 = {id = 10001, name = "主城1", path = "build_barracks", level = 1, hp = 100, occupy = 1, edge = 2, build_time = 10, cost = 100, groundGID = 9, moveable = 1, selectable = 1, next_lv = 10002, saleable = 1, salemoney = 100, make = nil},
	id_10002 = {id = 10002, name = "主城2", path = "build_barracks", level = 2, hp = 100, occupy = 1, edge = 2, build_time = 20, cost = 200, groundGID = 9, moveable = 1, selectable = 1, next_lv = 10003, saleable = 1, salemoney = 200, make = nil},
	id_10003 = {id = 10003, name = "主城3", path = "build_barracks", level = 3, hp = 100, occupy = 1, edge = 2, build_time = 40, cost = 400, groundGID = 9, moveable = 1, selectable = 1, next_lv = 10004, saleable = 1, salemoney = 400, make = nil},
	id_10004 = {id = 10004, name = "主城4", path = "hall", level = 1, hp = 100, occupy = 4, edge = 2, build_time = 10, cost = 400, groundGID = 9, moveable = 1, selectable = 1, next_lv = nil, saleable = 1, salemoney = 400, make = nil},
}

-- local mt = {}
-- mt.__index = function ( table, key )
-- 	local i = db.keys[key]
-- 	if i then
-- 		return rawget(table, i)
-- 	end
-- end

function db.getById( id )
	-- local data = db.values["id_"..tostring(id)]
	-- assert(data, tostring(id))
	-- if getmetatable(data) then return data end
	-- setmetatable(data, mt)
	return assert(db.values["id_"..tostring(id)], tostring(id))
end

return db