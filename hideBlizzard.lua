local addon, ns = ...

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

	ReputationWatchBar:Hide()

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

ns.hideBlizzard = hideBlizzardParts