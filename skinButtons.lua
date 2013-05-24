local addon, ns = ...

local settings = ns.settings

local core = Dark.core
local style = core.style
local colors = core.colors

local skinActionButton = function(buttonName)

	local button = _G[buttonName]

	style.actionButton(button)

	button:SetSize(settings.buttonSize, settings.buttonSize)
	button:SetAttribute("showgrid", 1)
	button:Show()

end

local skinPetButton = function(buttonName)
	
	local button = _G[buttonName]

	style.petActionButton(button)

	button:SetSize(settings.buttonSize, settings.buttonSize)
	button:Show()

end

local skinAllButtons = function()
	
	for i = 1, NUM_ACTIONBAR_BUTTONS do

		skinActionButton("ActionButton" ..i)
		skinActionButton("MultiBarBottomLeftButton"..i)
		skinActionButton("MultiBarBottomRightButton"..i)
		skinActionButton("MultiBarRightButton"..i)
		skinActionButton("MultiBarLeftButton"..i)

	end

	for i = 1, NUM_PET_ACTION_SLOTS do

		skinPetButton("PetActionButton"..i)
		skinActionButton("StanceButton"..i)

	end

	local onPetBarUpdate = function()

		for i = 1, NUM_PET_ACTION_SLOTS  do

			local button = _G["PetActionButton"..i]
			local name, subtext, texture, isToken, isActive, autoCastable, autoCastEnabled = GetPetActionInfo(i)

			if autoCastable then
				button.shadow:SetBackdropBorderColor(unpack(colors.reaction[4]))  --use neutral color
			else
				button.shadow:SetBackdropBorderColor(unpack(colors.shadow))
			end

		end

	end

	hooksecurefunc("PetActionBar_Update", onPetBarUpdate)
end

ns.skinButtons = skinAllButtons
