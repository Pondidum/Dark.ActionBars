local addon, ns = ...

local events = ns.lib.events:new()
local config = ns.config
local bar = ns.bar

local style = Dark.core.style

local bank = bar:new({

	name = "Bank",
	container = CreateFrame("Frame", "DarkBankBagFrame", UIParent),
	anchor = { "TOPLEFT", "UIParent", "TOPLEFT", config.screenPadding, -config.screenPadding },

	rows = 1,
	columns = 7,

	init = function(self)

		for i = 1, self.columns do
			table.insert(self.frames, _G["BankFrameBag" .. i])
		end

		self.container:Hide()
	end,

	customiseFrame = function(self, button)

		button:SetParent(self.container)
		button:SetSize(config.buttonSize, config.buttonSize)
		button:Show()

		style.itemButton(button)

		local texture = GetInventoryItemTexture("player", button:GetInventorySlot())

		if texture then
			button.icon:SetTexture(texture)
		else
			--lifed from bankFrame.lua: BankFrameItemButton_Update
			local id, slotTextureName = GetInventorySlotInfo(strsub(button:GetName(), 10));
			button.icon:SetTexture(slotTextureName)
		end

	end,
})

events.register("BANKFRAME_OPENED", function()
	bank.container:Show()
	bank:layout()
end)

events.register("BANKFRAME_CLOSED", function()
	bank.container:Hide()
end)

