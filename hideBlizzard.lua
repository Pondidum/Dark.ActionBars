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
	MainMenuExpBar.Show  = fake
	MainMenuBarMaxLevelBar:Hide()
	MainMenuBarMaxLevelBar:UnregisterAllEvents()
	MainMenuBarMaxLevelBar.Show = fake
	ExhaustionTick:UnregisterAllEvents()
	ExhaustionTick:SetScript("OnEvent", nil)

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

		button:SetSize(0,0)
		button:UnregisterAllEvents()
		button:Hide()

		button:SetNormalTexture("")

	end

end

ns.hideBlizzard = hideBlizzardParts
