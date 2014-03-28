local addon, ns = ...

local settings = ns.config
local bar = ns.bar

bar:new({

	name = "Right",
	bar = MultiBarBottomRight,
	anchor = { "BOTTOMLEFT", "Main", "BOTTOMRIGHT", settings.spacing + settings.spacing, 0 },

	rows = 2,
	columns = 6,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.buttons, _G["MultiBarBottomRightButton" .. i])
		end

	end,
})
