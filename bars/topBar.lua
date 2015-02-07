local addon, ns = ...

local config = ns.config
local bar = ns.bar

bar:new({

	name = "Top",
	container = MultiBarLeft,
	anchor = { "BOTTOM", "Main", "TOP", 0, config.spacing },

	rows = 1,
	columns = 12,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.children, _G["MultiBarLeftButton" .. i])
		end

	end,
})
