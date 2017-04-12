-- 管理模块
local manager = {}
local game = game

function manager.load( name )
	game[name] = require(Mapping[name])
	return game[name]
end

local mt = {}
mt.__index = function ( _, key )
	print("ModuleManager ", key)
	local v = rawget(game, key)
	if v then
		return v
	end
	return manager.load(key)
end
setmetatable(game, mt)  -- 

return manager