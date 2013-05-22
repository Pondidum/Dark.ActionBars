local addon, ns = ...
local settings = ns.settings

local sizeBar = function(bar, cols, rows, buttonName)
	
	local barWidth = ((settings.buttonSize + settings.spacing) * cols) - settings.spacing
	local barHeight = ((settings.buttonSize + settings.spacing) * rows) - settings.spacing

	bar:SetSize(barWidth, barHeight)

	local name = bar:GetName()

	local topButton = _G[buttonName.."1"]

	topButton:ClearAllPoints()
	topButton:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
	
	local prev = topButton

	for i = 1, rows - 1 do

		local index = (i * cols) + 1
		local button = _G[buttonName..index]

		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -settings.spacing)

		prev = button

	end

end

local locateBar = function(bar, ...)
	
	bar:ClearAllPoints()
	bar:SetPoint(...)

	bar.SetPoint = function() end

end

local layoutBottomLeftBar = function()
	
	local bar = MultiBarBottomLeft

	sizeBar(bar, 6, 2, "MultiBarBottomLeftButton")
	locateBar(bar, "BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -(settings.spacing + settings.spacing), 0)

end

local layoutBottomRightBar = function()

	local bar = MultiBarBottomRight

	sizeBar(bar, 6, 2, "MultiBarBottomRightButton")
	locateBar(bar, "BOTTOMLEFT", MainMenuBar, "BOTTOMRIGHT", (settings.spacing + settings.spacing), 0)

end

local layoutMainBar = function()
	
	local bar = MainMenuBar

	sizeBar(bar, 12, 1, "ActionButton")
	locateBar(bar, "BOTTOM", 0, 10)

end 

local layoutLeftBar = function()
	
	local bar = MultiBarLeft

	sizeBar(bar, 12, 1, "MultiBarLeftButton")
	locateBar(bar, "BOTTOM", MainMenuBar, "TOP", 0, settings.spacing)
	
	for i = 2, 12 do

		local button = _G["MultiBarLeftButton"..i] 
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:ClearAllPoints()
		button:SetPoint("LEFT", target, "RIGHT", -y, 0)

	end

end

local layoutStanceBar = function()

	local bar = StanceBarFrame

	sizeBar(bar, 10, 1, "StanceButton")
	locateBar(bar, "BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, settings.spacing + settings.spacing)

	for i = 2, 10 do
		
		local button = _G["StanceButton"..i]
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:SetPoint("LEFT", target, "RIGHT", settings.spacing, 0)

	end

end

local layoutPetBar = function()
	
	local bar = PetActionBarFrame

	sizeBar(bar, 10, 1, "PetActionButton")
	locateBar(bar, "BOTTOM", MultiBarLeft, "TOP", 0, settings.spacing + settings.spacing)
	
	for i = 2, 10 do

		local button = _G["PetActionButton"..i] 
		local anchor, target, targetAnchor, x, y = button:GetPoint()

		button:ClearAllPoints()
		button:SetPoint("LEFT", target, "RIGHT", settings.spacing, 0)

	end

end

local layoutBars = function()

	layoutMainBar()
	layoutLeftBar()

	layoutBottomLeftBar()
	layoutBottomRightBar()

	layoutStanceBar()
	layoutPetBar()

end

ns.layoutBars = layoutBars