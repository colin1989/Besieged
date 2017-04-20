--[[
	触摸状态
]]

local TouchStatus = {}

local status_ = OP_NONE

function TouchStatus.isStatus( status )
	return status_ == status
end

function TouchStatus.switch_ccui( ... )
	status_ = OP_CCUI
end

function TouchStatus.switch_none( ... )
	status_ = OP_NONE
end

function TouchStatus.switch_press_unit( ... )
	status_ = OP_PRESS_UNIT
end

function TouchStatus.switch_move_unit( ... )
	status_ = OP_MOVE_UNIT
end

function TouchStatus.switch_unselect( ... )
	status_ = OP_UNSELECT
end

function TouchStatus.switch_move_map( ... )
	status_ = OP_MOVE_MAP
end

function TouchStatus.switch_zoom_map( ... )
	status_ = OP_ZOOM_MAP
end

return TouchStatus