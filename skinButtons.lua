local addon, ns = ...

local settings = ns.settings

local core = Dark.core
local style = core.style

local skinButton = function(buttonName)

	local button = _G[buttonName]

	style.actionButton(button)

	button:SetSize(settings.buttonSize, settings.buttonSize)
	button:SetAttribute("showgrid", 1)
	button:Show()

end

local skinAllButtons = function()
	
	for i = 1, 12 do

		skinButton("ActionButton" ..i)
		skinButton("MultiBarBottomLeftButton"..i)
		skinButton("MultiBarBottomRightButton"..i)
		skinButton("MultiBarRightButton"..i)
		skinButton("MultiBarLeftButton"..i)

	end

	for i = 1, 10 do

		skinButton("PetActionButton"..i)
		skinButton("StanceButton"..i)

	end

end

ns.skinButtons = skinAllButtons
