local addon, ns = ...

local config = ns.config
local bar = ns.bar

bar:new({

	name = "Right",
	container = MultiBarBottomRight,
	anchor = { "BOTTOMLEFT", "Main", "BOTTOMRIGHT", config.spacing + config.spacing, 0 },

	rows = 2,
	columns = 6,

	init = function(self)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			self:addChild(_G["MultiBarBottomRightButton" .. i])
		end

	end,
})
