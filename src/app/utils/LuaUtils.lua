--
-- Author: Your Name
-- Date: 2017-06-28 11:41:05
--
local table = table

function table.intersection( tables )
	local t = {}
	for _,v in pairs(tables) do
		for _,e in pairs(v) do
			t[e] = (t[e] or 0) + 1
		end
	end
	local result = {}
	local n = #tables
	for k,v in pairs(t) do
		if v >= n then
			table.insert(result, k)
		end
	end
	return result
end