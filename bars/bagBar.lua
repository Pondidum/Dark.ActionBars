local addon, ns = ...

local settings = ns.settings
local bar = ns.bar

local style = Dark.core.style

bar:new({

	name = "Bags",
	bar = CreateFrame("Frame", "DarkBagFrame", UIParent),
	anchor = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -settings.screenPadding, settings.screenPadding },

	rows = 1,
	columns = NUM_BAG_FRAMES + 1,

	init = function(self)

		table.insert(self.buttons, MainMenuBarBackpackButton)

		for i = 0, NUM_BAG_FRAMES do
			table.insert(self.buttons, _G["CharacterBag" .. i .. "Slot"])
		end

	end,

	styleButton = function(self, button)

		button:SetSize(settings.buttonSize, settings.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style.itemButton(button)

	end,
})
