local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

bar:new({

	name = "Left",
	bar = MultiBarBottomLeft,
	anchor = { "BOTTOMRIGHT", "Main", "BOTTOMLEFT", -(settings.spacing + settings.spacing), 0 },

	rows = 2,
	columns = 6,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.buttons, _G["MultiBarBottomLeftButton" .. i])
		end

	end,
})
