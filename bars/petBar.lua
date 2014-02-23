local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

local style = Dark.core.style

bar:new({

	name = "Pet",
	bar = CreateFrame("Frame", "DarkPetActionBar", UIParent),
	anchor = { "BOTTOM", "Top", "TOP", 0, settings.spacing },

	rows = 1,
	columns = NUM_PET_ACTION_SLOTS,

	init = function(self)

		for i = 1, NUM_PET_ACTION_SLOTS do
			table.insert(self.buttons, _G["PetActionButton" .. i])
		end

		--self.bar.showgrid = 1
	end,

	styleButton = function(self, button)

		button:SetSize(settings.buttonSize, settings.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style.petActionButton(button)

	end,

})
