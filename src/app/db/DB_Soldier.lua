local db = {}
db.values = {
	id_20001 = {id =20001, name ="角色1", path ="arrower1", level =1, occupy =1, edge =2, build_time =10, cost =100, groundGID =9, moveable =0, selectable =0},
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