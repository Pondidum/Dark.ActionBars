local addon, ns = ...

local config = ns.config
local bar = ns.bar

bar:new({

	name = "Stance",
	container = StanceBarFrame,
	anchor = { "BOTTOMLEFT", "Left", "TOPLEFT", 0, config.spacing },

	rows = 1,
	columns = NUM_STANCE_SLOTS,

	init = function(self)

		for i = 1, NUM_STANCE_SLOTS do
			self:addChild(_G["StanceButton" .. i])
		end

	end,
})
