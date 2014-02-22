local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

bar:new({

	name = "Floating",
	bar = MultiBarRight,
	anchor = { "RIGHT", "UIParent", "RIGHT", -settings.screenPadding, 0 },

	rows = 12,
	columns = 1,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			table.insert(self.buttons, _G["MultiBarRightButton" .. i])
		end

	end,

})
