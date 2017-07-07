local db = {}

db.values = {
	id_30001 = {id = 30001, name = "花", path = "obstacle_flower_1", occupy = 2, edge = 0, gain = 1000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
	id_30002 = {id = 30002, name = "石头1", path = "obstacle_flower_2", occupy = 2, edge = 0, gain = 1000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
	id_30003 = {id = 30003, name = "石头2", path = "obstacle_flower_3", occupy = 2, edge = 0, gain = 2000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
	id_30004 = {id = 30004, name = "石头3", path = "obstacle_flower_4", occupy = 2, edge = 0, gain = 3000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
	id_30005 = {id = 30005, name = "树1", path = "obstacle_flower_5", occupy = 2, edge = 0, gain = 8000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
	id_30006 = {id = 30006, name = "树2", path = "obstacle_flower_6", occupy = 2, edge = 0, gain = 10000, groundGID = 9, isCanMove = 0, isCanSelect = 1},
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