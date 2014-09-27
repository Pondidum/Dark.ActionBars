local addon, ns = ...

local config = ns.config
local bar = ns.bar

bar:new({

	name = "Left",
	container = MultiBarBottomLeft,
	anchor = { "BOTTOMRIGHT", "Main", "BOTTOMLEFT", -(config.spacing + config.spacing), 0 },

	rows = 2,
	columns = 6,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.frames, _G["MultiBarBottomLeftButton" .. i])
		end

	end,
})
