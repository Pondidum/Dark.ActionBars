local addon, ns = ...
local core = Dark.core
local style = core.style

local skinButtons = function()
	
	for i = 1, 12 do


		local button = _G["ActionButton" ..i]
		local bottomLeftButton = _G["MultiBarBottomLeftButton"..i]
		local bottomRightButton = _G["MultiBarBottomRightButton"..i]
		local rightButton = _G["MultiBarRightButton"..i]
		local leftButton = _G["MultiBarLeftButton"..i]
		
		style.actionButton(button)
		style.actionButton(bottomLeftButton)
		style.actionButton(bottomRightButton)
		style.actionButton(rightButton)
		style.actionButton(leftButton)

		button:SetSize(25, 25)
		bottomLeftButton:SetSize(25, 25)
		bottomRightButton:SetSize(25, 25)
		rightButton:SetSize(25, 25)
		leftButton:SetSize(25, 25)

		--prevent this set of buttons from autohiding
		button:SetAttribute("showgrid", 1)
		button:Show()

	end

	for i = 1, 10 do

		local petButton = _G["PetActionButton"..i]
		local stanceButton = _G["StanceButton"..i]

		style.actionButton(petButton)
		style.actionButton(stanceButton)
		
		petButton:SetSize(25, 25)
		stanceButton:SetSize(25, 25)

	end

end

ns.skinButtons = skinButtons