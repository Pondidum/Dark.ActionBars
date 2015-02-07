local addon, ns = ...

local config = ns.config
local bar = ns.bar

bar:new({

	name = "Main",
	container = MainMenuBar,
	anchor = { "BOTTOM", "UIParent", "BOTTOM", 0, config.screenPadding },

	rows = 1,
	columns = 12,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.children, _G["ActionButton" .. i])
		end

	end,
})
