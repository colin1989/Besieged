local db = {}

db.keys = {id = 1, name = 2, path = 3, occupy = 4, edge = 5, gain = 6, groundGID = 7, isCanMove = 10, isCanSelect = 11}
db.values = {
	id_11001 = {11001, "花", "obstacle_flower_1", 2, 0, 1000, 9, 0, 1},
	id_11002 = {11002, "石头1", "obstacle_flower_2", 2, 0, 1000, 9, 0, 1},
	id_11003 = {11003, "石头2", "obstacle_flower_3", 2, 0, 2000, 9, 0, 1},
	id_11004 = {11004, "石头3", "obstacle_flower_4", 2, 0, 3000, 9, 0, 1},
	id_11005 = {11005, "树1", "obstacle_flower_5", 2, 0, 8000, 9, 0, 1},
	id_11006 = {11006, "树2", "obstacle_flower_6", 2, 0, 10000, 9, 0, 1},
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