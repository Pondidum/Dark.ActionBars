local addon, ns = ...

local config = ns.config
local bar = ns.bar

local style = ns.lib.style

bar:new({

	name = "Bags",
	container = CreateFrame("Frame", "DarkBagFrame", UIParent),
	anchor = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -config.screenPadding, config.screenPadding },

	rows = 1,
	columns = NUM_BAG_FRAMES + 1,

	init = function(self)

		self:addChild(MainMenuBarBackpackButton)

		for i = 0, NUM_BAG_FRAMES do
			self:addChild(_G["CharacterBag" .. i .. "Slot"])
		end

	end,

	customiseFrame = function(self, button)

		button:SetSize(config.buttonSize, config.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style:itemButton(button)

	end,
})
