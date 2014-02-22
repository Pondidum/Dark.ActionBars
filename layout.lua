local addon, ns = ...
local settings = ns.settings

local sizeBar = function(bar, cols, rows, buttonFormat)

	local barWidth = ((settings.buttonSize + settings.spacing) * cols) - settings.spacing
	local barHeight = ((settings.buttonSize + settings.spacing) * rows) - settings.spacing

	bar:SetSize(barWidth, barHeight)

	local name = bar:GetName()

	local topButton = _G[string.format(buttonFormat, "1")]

	topButton:ClearAllPoints()
	topButton:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)

	local prev = topButton

	for i = 1, rows - 1 do

		local index = (i * cols) + 1
		local button = _G[string.format(buttonFormat, index)]

		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -settings.spacing)

		prev = button

	end

end

local locateBar = function(bar, ...)

	bar:ClearAllPoints()
	bar:SetPoint(...)

	UIPARENT_MANAGED_FRAME_POSITIONS[bar:GetName()] = nil

end

local layoutBottomLeftBar = function()

	local bar = MultiBarBottomLeft

	sizeBar(bar, 6, 2, "MultiBarBottomLeftButton%s")
	locateBar(bar, "BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -(settings.spacing + settings.spacing), 0)

end

local layoutBottomRightBar = function()

	local bar = MultiBarBottomRight

	sizeBar(bar, 6, 2, "MultiBarBottomRightButton%s")
	locateBar(bar, "BOTTOMLEFT", MainMenuBar, "BOTTOMRIGHT", (settings.spacing + settings.spacing), 0)

end

local layoutMainBar = function()

	local bar = MainMenuBar

	sizeBar(bar, NUM_ACTIONBAR_BUTTONS, 1, "ActionButton%s")
	locateBar(bar, "BOTTOM", 0, settings.screenPadding)

end

local layoutLeftBar = function()

	local bar = MultiBarLeft

	sizeBar(bar, NUM_ACTIONBAR_BUTTONS, 1, "MultiBarLeftButton%s")
	locateBar(bar, "BOTTOM", MainMenuBar, "TOP", 0, settings.spacing)

	for i = 2, NUM_ACTIONBAR_BUTTONS do

		local button = _G["MultiBarLeftButton"..i]
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:ClearAllPoints()
		button:SetPoint("LEFT", target, "RIGHT", settings.spacing, 0)

	end

end

local layoutRightBar = function()

	local bar = MultiBarRight

	sizeBar(bar, 1, NUM_ACTIONBAR_BUTTONS, "MultiBarRightButton%s")
	locateBar(bar, "RIGHT", UIParent, "RIGHT", -settings.screenPadding, 0)

end

local layoutStanceBar = function()

	local bar = StanceBarFrame

	sizeBar(bar, NUM_STANCE_SLOTS, 1, "StanceButton%s")
	locateBar(bar, "BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, settings.spacing + settings.spacing)

	for i = 2, NUM_STANCE_SLOTS do

		local button = _G["StanceButton"..i]
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:SetPoint("LEFT", target, "RIGHT", settings.spacing, 0)

	end

end

local layoutPetBar = function()

	local bar = PetActionBarFrame

	-- sizeBar(bar, NUM_PET_ACTION_SLOTS, 1, "PetActionButton%s")
	-- locateBar(bar, "BOTTOM", MultiBarLeft, "TOP", 0, settings.spacing + settings.spacing)

	PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarLeft, "TOPLEFT", 0, settings.spacing + settings.spacing)
	for i = 2, NUM_PET_ACTION_SLOTS do

		local button = _G["PetActionButton"..i]
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:ClearAllPoints()
		button:SetPoint("LEFT", target, "RIGHT", settings.spacing, 0)

	end

end

local layoutBagBar = function()

	local bar = CreateFrame("Frame", "DarkBagBar", UIParent)
	sizeBar(bar, NUM_BAG_FRAMES+1, 1, "MainMenuBarBackpackButton")
	locateBar(bar, "BOTTOMRIGHT", UIParent, -settings.screenPadding, settings.screenPadding)

	local prev = _G["MainMenuBarBackpackButton"]
	prev:SetParent(bar)

	for i = 0, NUM_BAG_FRAMES - 1 do

		local b = _G["CharacterBag"..i.."Slot"]
		b:SetParent(bar)

		b:ClearAllPoints()
		b:SetPoint("LEFT", prev, "RIGHT", settings.spacing, 0)
		prev = b
	end

end

local layoutBars = function()

	layoutMainBar()
	layoutLeftBar()
	layoutRightBar()

	layoutBottomLeftBar()
	layoutBottomRightBar()

	layoutStanceBar()
	layoutPetBar()

	layoutBagBar()

end

ns.layoutBars = layoutBars
