local addon, ns = ...

local hideTextures = function(frame)

	local count = frame:GetNumRegions()

	for i = 1, count do

		local region = select(i, frame:GetRegions())
		region:Hide()

	end

end

local hideBlizzardParts = function()

	local fake = function() end
	--silly blizzard call this sometimes, even though it doesn't exist.
	if not AchievementMicroButton_Update then
		AchievementMicroButton_Update = fake
	end

	hideTextures(MainMenuBarArtFrame)
	hideTextures(OverrideActionBar)

	MainMenuExpBar:Hide()
	MainMenuBarMaxLevelBar:Hide()
	MainMenuBarMaxLevelBar:UnregisterAllEvents()
	MainMenuBarMaxLevelBar.Show = fake

	ReputationWatchBar:Hide()
	ReputationWatchStatusBar:Hide()

	ActionBarUpButton:Hide()
	ActionBarDownButton:Hide()

	OverrideActionBarHealthBar:Hide()
	OverrideActionBarExpBar:Hide()
	OverrideActionBarPowerBar:Hide()
	OverrideActionBarLeaveFrameDivider3:Hide()

	for i , v in ipairs(MICRO_BUTTONS) do

		local button = _G[v]

		button:UnregisterAllEvents()
	  	button:Hide()

	end

	--UpdateMicroButtons = fake


	for i = 0, 3 do
	  _G["CharacterBag"..i.."Slot"]:Hide()
	end

	MainMenuBarBackpackButton:Hide()

end

ns.hideBlizzard = hideBlizzardParts
