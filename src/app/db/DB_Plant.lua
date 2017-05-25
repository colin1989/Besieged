local db = {}

db.keys = {id = 1, name = 2, path = 3, occupy = 4, edge = 5, gain = 6, groundGID = 7, isCanMove = 10, isCanSelect = 11}
db.values = {
	id_30001 = {30001, "花", "obstacle_flower_1", 2, 0, 1000, 9, 0, 1},
	id_30002 = {30002, "石头1", "obstacle_flower_2", 2, 0, 1000, 9, 0, 1},
	id_30003 = {30003, "石头2", "obstacle_flower_3", 2, 0, 2000, 9, 0, 1},
	id_30004 = {30004, "石头3", "obstacle_flower_4", 2, 0, 3000, 9, 0, 1},
	id_30005 = {30005, "树1", "obstacle_flower_5", 2, 0, 8000, 9, 0, 1},
	id_30006 = {30006, "树2", "obstacle_flower_6", 2, 0, 10000, 9, 0, 1},
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