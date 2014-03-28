local addon, ns = ...

local settings = ns.config
local bar = ns.bar

bar:new({

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
