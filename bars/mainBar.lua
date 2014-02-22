local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

local mainBar = bar:new({

	name = "Main",
	bar = MainMenuBar,
	anchor = { "BOTTOM", "UIParent", "BOTTOM", 0, settings.screenPadding },

	rows = 1,
	columns = 12,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.buttons, _G["ActionButton" .. i])
		end

	end,

})
