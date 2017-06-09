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
		["x"] = 0
	},
	["custom_nodes"] = {
		
	},
	["nodes"] = 
	{
		["edeef1b6-485f-4532-847f-bd9be1e53cb8"] = 
		{
			["description"] = "",
			["title"] = "Succeeder",
			["properties"] = 
			{
			},
			["id"] = "edeef1b6-485f-4532-847f-bd9be1e53cb8",
			["display"] = 
			{
				["y"] = 60,
				["x"] = 240
			},
			["name"] = "BTSucceeder"
		},
		["fed6ba43-db53-4f63-833f-1c0d3c360b40"] = 
		{
			["description"] = "",
			["title"] = "Sequence",
			["children"] = {
				"edeef1b6-485f-4532-847f-bd9be1e53cb8",
				"8a90208d-c362-42fd-8b56-3510a5f69bb6",
			},
			["properties"] = 
			{
			},
			["id"] = "fed6ba43-db53-4f63-833f-1c0d3c360b40",
			["display"] = 
			{
				["y"] = 0,
				["x"] = 84
			},
			["name"] = "BTSelector"
		},
		["8a90208d-c362-42fd-8b56-3510a5f69bb6"] = 
		{
			["description"] = "",
			["title"] = "Wait <milliseconds>ms",
			["properties"] = 
			{
				["milliseconds"] = 3
			},
			["id"] = "8a90208d-c362-42fd-8b56-3510a5f69bb6",
			["display"] = 
			{
				["y"] = -36,
				["x"] = 252
			},
			["name"] = "BTWaitMS"
		}
	},
	["root"] = "fed6ba43-db53-4f63-833f-1c0d3c360b40",
	["id"] = "37512958-61aa-4e55-883c-64af11a39310"
}