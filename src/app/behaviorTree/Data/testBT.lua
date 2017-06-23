return 
{
	["description"] = "",
	["title"] = "A behavior tree",
	["properties"] = 
	{
	},
	["display"] = 
	{
		["camera_x"] = 512,
		["camera_y"] = 301.5,
		["camera_z"] = 1,
		["y"] = 0,
		["x"] = -156
	},
	["custom_nodes"] = {
		
		{
			["category"] = "composite",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTSequence",
			["title"] = nil
		},
		{
			["category"] = "composite",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTSelector",
			["title"] = nil
		},
		{
			["category"] = "composite",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTParallelOr",
			["title"] = nil
		},
		{
			["category"] = "composite",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTParallelAnd",
			["title"] = nil
		},
		{
			["category"] = "action",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTAction",
			["title"] = nil
		},
		{
			["category"] = "condition",
			["description"] = nil,
			["properties"] = 
			{
			},
			["name"] = "BTCondition",
			["title"] = nil
		},
		{
			["category"] = "condition",
			["description"] = nil,
			["properties"] = 
			{
				["method"] = "isHaveEnemy"
			},
			["name"] = "BTConditionIsHaveEnemy",
			["title"] = nil
		}
	},
	["nodes"] = 
	{
		["c27692f5-8a0b-4e36-9e98-c39d766d8464"] = 
		{
			["description"] = "",
			["title"] = "BTAction",
			["properties"] = 
			{
				["method"] = "idle"
			},
			["id"] = "c27692f5-8a0b-4e36-9e98-c39d766d8464",
			["display"] = 
			{
				["y"] = 60,
				["x"] = 144
			},
			["name"] = "BTAction"
		},
		["024dc464-ef21-4c65-835a-2b7269865c1d"] = 
		{
			["description"] = "",
			["title"] = "BTSequence",
			["children"] = {
				"3fb80c03-eb64-44c2-8ff4-17b17db5e5a0","432cc96b-aa68-4208-86ac-759728e7f2a0"
			},
			["properties"] = 
			{
			},
			["id"] = "024dc464-ef21-4c65-835a-2b7269865c1d",
			["display"] = 
			{
				["y"] = -48,
				["x"] = 132
			},
			["name"] = "BTSequence"
		},
		["3fb80c03-eb64-44c2-8ff4-17b17db5e5a0"] = 
		{
			["description"] = "",
			["title"] = "BTConditionIsHaveEnemy",
			["properties"] = 
			{
				["method"] = "isHaveEnemy"
			},
			["id"] = "3fb80c03-eb64-44c2-8ff4-17b17db5e5a0",
			["display"] = 
			{
				["y"] = -120,
				["x"] = 360
			},
			["name"] = "BTConditionIsHaveEnemy"
		},
		["432cc96b-aa68-4208-86ac-759728e7f2a0"] = 
		{
			["description"] = "",
			["title"] = "BTAction",
			["properties"] = 
			{
				["precondition"] = "3fb80c03-eb64-44c2-8ff4-17b17db5e5a0",
				["method"] = "move"
			},
			["id"] = "432cc96b-aa68-4208-86ac-759728e7f2a0",
			["display"] = 
			{
				["y"] = -24,
				["x"] = 324
			},
			["name"] = "BTAction"
		},
		["59514d47-6d6d-49f0-8888-aeebc2077c77"] = 
		{
			["description"] = "",
			["title"] = "BTSelector",
			["children"] = {
				"024dc464-ef21-4c65-835a-2b7269865c1d","c27692f5-8a0b-4e36-9e98-c39d766d8464"
			},
			["properties"] = 
			{
			},
			["id"] = "59514d47-6d6d-49f0-8888-aeebc2077c77",
			["display"] = 
			{
				["y"] = 0,
				["x"] = -36
			},
			["name"] = "BTSelector"
		}
	},
	["root"] = "59514d47-6d6d-49f0-8888-aeebc2077c77",
	["id"] = "37512958-61aa-4e55-883c-64af11a39310"
}