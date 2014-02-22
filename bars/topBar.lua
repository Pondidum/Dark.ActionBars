local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

bar:new({

	name = "Top",
	bar = MultiBarLeft,
	anchor = { "BOTTOM", "Main", "TOP", 0, settings.spacing },

	rows = 1,
	columns = 12,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.buttons, _G["MultiBarLeftButton" .. i])
		end

	end,
})
