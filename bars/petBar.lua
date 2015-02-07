local addon, ns = ...

local config = ns.config
local bar = ns.bar

local style = ns.lib.style

bar:new({

	name = "Pet",
	container = CreateFrame("Frame", "DarkPetActionBar", UIParent),
	anchor = { "BOTTOM", "Top", "TOP", 0, config.spacing },

	rows = 1,
	columns = NUM_PET_ACTION_SLOTS,

	init = function(self)

		for i = 1, NUM_PET_ACTION_SLOTS do
			self:addChild(_G["PetActionButton" .. i])
		end

		--self.container.showgrid = 1
	end,

	customiseFrame = function(self, button)

		button:SetSize(config.buttonSize, config.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style:petActionButton(button)

	end,

})
