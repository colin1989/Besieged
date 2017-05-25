local notification = {}
local observers_ = {}

function notification.add( name, flag, callback )
	local tb = observers_[name] or {}
	table.insert(tb, {
		name = name,
		flag = flag,
		callback = callback,
	})	
	observers_[name] = tb
end

function notification.erase( name, flag )
	if not observers_[name] then
		return nil
	end
	local tb = observers_[name]
	for i,v in ipairs(tb) do
		if (v.flag == flag) then
			return table.remove(tb, i)
		end
	end
	return nil
end

function notification.post( name, ... )
	print("NotificationManager post ", name)
	if not observers_[name] then
		return nil
	end
	local tb = observers_[name]
	local wait = {}
	for i,v in ipairs(tb) do
		if (v.callback) then
			table.insert(wait, {callback = v.callback, params = {...}})
		end
	end
	for i,v in ipairs(wait) do
		v.callback(unpack(v.params))
	end
end

return notification