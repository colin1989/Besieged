local db = {}
-- 		   id 		名字 	资源路径 		等级 		占地 	  边（弃用） 建造时间    花费      建造后的地面GID  是否可移动       是否可选中
db.keys = {id = 1, name = 2, path = 3, level = 4, occupy = 5, edge = 6, time = 7, cost = 8, groundGID = 9, isCanMove = 10, isCanSelect = 11}
db.values = {
	id_10001 = {10001, "主城1", "build_barracks", 1, 1, 2, 10, 100, 9, 1, 1},
	id_10002 = {10002, "主城2", "build_barracks", 2, 1, 2, 20, 200, 9, 1, 1},
	id_10003 = {10003, "主城3", "build_barracks", 3, 1, 2, 40, 400, 9, 1, 1},
	id_10004 = {10004, "主城4", "hall", 1, 4, 2, 10, 400, 9, 1, 1},
}

local mt = {}
mt.__index = function ( table, key )
	local i = db.keys[key]
	if i then
		return rawget(table, i)
	end
end

function db.getById( id )
	local data = db.values["id_"..tostring(id)]
	assert(data, tostring(id))
	if getmetatable(data) then return data end
	setmetatable(data, mt)
	return data
end

return db