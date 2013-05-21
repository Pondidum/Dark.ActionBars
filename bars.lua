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

local getStandardSize = function()

	local width = math.abs(ActionButton1:GetLeft() - ActionButton12:GetRight())
	local height = ActionButton1:GetHeight()
	local spacing = select(4, ActionButton12:GetPoint())

	return width, height, spacing
end

local makeHalfBar = function(bar, standardWidth, standardHeight, standardSpacing)
	
	local barWidth = (standardWidth - standardSpacing) / 2
	local barHeight = standardHeight + standardHeight + standardSpacing

	bar:SetSize(barWidth, barHeight)

	local name = bar:GetName()

	local topButton = _G[name.."Button1"]
	local baseButton = _G[name.."Button7"]

	topButton:ClearAllPoints()
	topButton:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)

	baseButton:ClearAllPoints()
	baseButton:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

end

local layoutMainBar = function(standardWidth, standardHeight, standardSpacing)
	
	local leftButton = ActionButton1
	local mainBar = MainMenuBar

	mainBar:SetSize(standardWidth, standardHeight)
	mainBar:SetPoint("BOTTOM", 0, 10)

	leftButton:SetPoint("BOTTOMLEFT", 0, 0)
end 

local layoutBottomLeftBar = function(standardWidth, standardHeight, standardSpacing)
	
	local bar = MultiBarBottomLeft

	makeHalfBar(bar, standardWidth, standardHeight, standardSpacing)

	bar:ClearAllPoints()
	bar:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -(standardSpacing + standardSpacing), 0)

	bar.SetPoint = function() end
	
end

local layoutBottomRightBar = function(standardWidth, standardHeight, standardSpacing)

	local bar = MultiBarBottomRight

	makeHalfBar(bar, standardWidth, standardHeight, standardSpacing)

	bar:ClearAllPoints()
	bar:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMRIGHT", (standardSpacing + standardSpacing), 0)

	bar.SetPoint = function() end
	
end

local layoutBars = function()
	
	local standardWidth, standardHeight, standardSpacing = getStandardSize()

	layoutMainBar(standardWidth, standardHeight, standardSpacing)

	layoutBottomLeftBar(standardWidth, standardHeight, standardSpacing)
	layoutBottomRightBar(standardWidth, standardHeight, standardSpacing)

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