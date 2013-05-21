local addon, ns = ...
local core = Dark.core
local events = core.events.new()
local style = core.style

local hideTextures = function(frame)

	local count = frame:GetNumRegions()

	for i = 1, count do 

		local region = select(i, frame:GetRegions())
		region:Hide()

	end

end

local hideBlizzardParts = function()

	
	hideTextures(MainMenuBarArtFrame)

	MainMenuExpBar:Hide()
	MainMenuBarMaxLevelBar:Hide()
	ActionBarUpButton:Hide()
	ActionBarDownButton:Hide()

	for i , v in ipairs(MICRO_BUTTONS) do
	  _G[v]:Hide()
	end

	for i = 0, 3 do
	  _G["CharacterBag"..i.."Slot"]:Hide()
	end

	MainMenuBarBackpackButton:Hide()

end

local layoutBars = function()

	local leftButton = ActionButton1
	local rightButton = ActionButton12
	local mainBar = MainMenuBar
	
	local width = math.abs(leftButton:GetLeft() - rightButton:GetRight())
	local height = leftButton:GetHeight()

	mainBar:SetSize(width, height)
	mainBar:SetPoint("BOTTOM", 0, 10)

	leftButton:SetPoint("BOTTOMLEFT", 0, 0)

end

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

	-- for i = 1, 10 do
	-- 	local petButton = _G["PetActionButton" ..i]
	-- 	style.actionButton(petButton)
	-- end

end

	
events.register("PLAYER_ENTERING_WORLD", function()
	hideBlizzardParts()
	skinButtons()
	layoutBars()
end)