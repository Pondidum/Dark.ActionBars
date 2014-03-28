local addon, ns = ...

local settings = ns.config
local bar = ns.bar

bar:new({

	name = "Stance",
	bar = StanceBarFrame,
	anchor = { "BOTTOMLEFT", "Left", "TOPLEFT", 0, settings.spacing },

	rows = 1,
	columns = NUM_STANCE_SLOTS,

	init = function(self)

		for i = 1, NUM_STANCE_SLOTS do
			table.insert(self.buttons, _G["StanceButton" .. i])
		end

	end,
})
