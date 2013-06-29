local addon, ns = ...

local hideTextures = function(frame)

	local count = frame:GetNumRegions()

	for i = 1, count do 

		local region = select(i, frame:GetRegions())
		region:Hide()

	end

end

local hideBlizzardParts = function()
	
	--silly blizzard call this sometimes, even though it doesn't exist.
	if not AchievementMicroButton_Update then
		AchievementMicroButton_Update = function() end
	end

	hideTextures(MainMenuBarArtFrame)

	MainMenuExpBar:Hide()
	MainMenuBarMaxLevelBar:Hide()
	MainMenuBarMaxLevelBar:UnregisterAllEvents()
	MainMenuBarMaxLevelBar.Show = function() end

	ReputationWatchBar:Hide()
	ReputationWatchStatusBar:Hide()

	ActionBarUpButton:Hide()
	ActionBarDownButton:Hide()

	

	for i , v in ipairs(MICRO_BUTTONS) do

		local button = _G[v]

		button:UnregisterAllEvents()
	  	button:Hide()
	  	
	end

	for i = 0, 3 do
	  _G["CharacterBag"..i.."Slot"]:Hide()
	end

	MainMenuBarBackpackButton:Hide()

end

ns.hideBlizzard = hideBlizzardParts
