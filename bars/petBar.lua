local addon, ns = ...

local config = ns.config
local bar = ns.bar

local style = Dark.core.style

bar:new({

	name = "Pet",
	bar = CreateFrame("Frame", "DarkPetActionBar", UIParent),
	anchor = { "BOTTOM", "Top", "TOP", 0, config.spacing },

	rows = 1,
	columns = NUM_PET_ACTION_SLOTS,

	init = function(self)

		for i = 1, NUM_PET_ACTION_SLOTS do
			table.insert(self.buttons, _G["PetActionButton" .. i])
		end

		--self.bar.showgrid = 1
	end,

	styleButton = function(self, button)

		button:SetSize(config.buttonSize, config.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style.petActionButton(button)

	end,

})
