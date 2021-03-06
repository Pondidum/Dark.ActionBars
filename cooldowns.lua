local addon, ns = ...

local fonts = ns.lib.fonts

local config = ns.config.cooldowns
--[[
	cc.lua
		Displays text for cooldowns on widgets

	cases when font size should be updated:
		frame is resized
		font is changed

	cases when text should be hidden:
		scale * fontSize < MIN_FONT_SIE
--]]

--globals!

local Classy = {}
local OmniCC = {}

function Classy:New(frameType, parentClass)
	local class = CreateFrame(frameType)
	class.mt = {__index = class}

	if parentClass then
		class = setmetatable(class, {__index = parentClass})

		class.super = function(self, method, ...)
			parentClass[method](self, ...)
		end
	end

	class.Bind = function(self, obj)
		return setmetatable(obj, self.mt)
	end

	return class
end





----------------------------------------------------------------------------------------------
local ClassicUpdater = Classy:New('Frame');
OmniCC.ClassicUpdater = ClassicUpdater

local updaters = setmetatable({}, {__index = function(self, frame)
	local updater = ClassicUpdater:New(frame)
	self[frame] = updater

	return updater
end})


--[[ Updater Retrieval ]]--

function ClassicUpdater:Get(frame)
	-- print('ClassicUpdater:Get', frame)

	return updaters[frame]
end

function ClassicUpdater:GetActive(frame)
	-- print('ClassicUpdater:GetActive', frame)

	return rawget(updaters, frame)
end

function ClassicUpdater:New(frame)
	-- print('ClassicUpdater:New', count, frame)

	local updater = self:Bind(CreateFrame('Frame', nil)); updater:Hide()
	updater:SetScript('OnUpdate', updater.OnUpdate)
	updater.frame = frame

	return updater
end


--[[ Updater Events ]]--

function ClassicUpdater:OnUpdate(elapsed)
	-- print('ClassicUpdater:OnUpdate', elapsed)

	local delay = self.delay - elapsed
	if delay > 0 then
		self.delay = delay
	else
		self:OnFinished()
	end
end

function ClassicUpdater:OnFinished()
	-- print('ClassicUpdater:OnFinished')

	self:Cleanup()
	self.frame:OnScheduledUpdate()
end


--[[ Updater Updating ]]--

function ClassicUpdater:ScheduleUpdate(delay)
	-- print('ClassicUpdater:ScheduleUpdate', delay)

	if delay > 0 then
		self.delay = delay
		self:Show()
	else
		self:OnFinished()
	end
end

function ClassicUpdater:CancelUpdate()
	-- print('ClassicUpdater:CancelUpdate')

	self:Cleanup()
end

function ClassicUpdater:Cleanup()
	-- print('ClassicUpdater:Cleanup')

	self:Hide()
	self.delay = nil
end
------------------------------------------------------------------------------------------------------


function OmniCC:ScheduleUpdate(frame, delay)
	local engine = OmniCC.ClassicUpdater
	local updater = engine:Get(frame)

	updater:ScheduleUpdate(delay)
end

function OmniCC:CancelUpdate(frame)
	local engine = OmniCC.ClassicUpdater
	local updater = engine:GetActive(frame)

	if updater then
		updater:CancelUpdate()
	end
end



--constants!
local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH, SOONISH = 3600 * 23.5, 60 * 59.5, 59.5, 5.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times
local PADDING = 0 --amount of spacing between the timer text and the rest of the cooldown

--local bindings!
local floor, min, type = floor, min, type
local round = function(x) return floor(x + 0.5) end
local GetTime = GetTime

--[[
	the cooldown timer object:
		displays time remaining for the given cooldown
--]]

local Timer = Classy:New('Frame'); Timer:Hide();
OmniCC.Timer = Timer
local timers = {}


--[[ Constructorish ]]--

function Timer:New(cooldown)
	local timer = Timer:Bind(CreateFrame('Frame', nil, cooldown:GetParent())); timer.cooldown = cooldown
	timer:SetFrameLevel(cooldown:GetFrameLevel() + 5)
	timer:Hide()

	timer.text = timer:CreateFontString(nil, 'OVERLAY')

	--we set the timer to the center of the cooldown and manually set size information in order to allow me to scale text
	--if we do set all points instead, then timer text tends to move around when the timer itself is scale)
	timer:SetPoint('CENTER', cooldown)
	timer:Size(cooldown:GetSize())

	timers[cooldown] = timer
	return timer
end

function Timer:Get(cooldown)
	return timers[cooldown]
end

function Timer:OnScheduledUpdate()
	--print('Timer:OnScheduledUpdate')

	self:UpdateText()
end


--[[ Updaters ]]--

--starts the timer for the given cooldown
function Timer:Start(start, duration)
	self.start = start
	self.visible = self.cooldown:IsVisible()
	self.duration = duration
	self.textStyle = nil
	self.enabled = true

	self:UpdateShown()
end

--stops the timer
function Timer:Stop()
	self.start, self.duration, self.enabled, self.visible, self.textStyle = nil
	self:CancelUpdate()
	self:Hide()
end

--adjust font size whenever the timer's parent size changes
--hide if it gets too tiny
function Timer:Size(width, height)
	self.abRatio = round(width) / ICON_SIZE

	self:SetSize(width, height)
	self:UpdateTextPosition()

	if self.enabled and self.visible then
		self:UpdateText(true)
	end
end

function Timer:UpdateText(forceStyleUpdate)
	--print('Timer:UpdateText', forceStyleUpdate)

	--handle deathknight runes, which have timers that start in the future
	if self.start > GetTime() then
		self:ScheduleUpdate(self.start - GetTime())
		return
	end

	--if there's time left on the clock, then update the timer text
	--otherwise stop the timer
	local remain = self:GetRemain()
	if remain > 0 then
		local overallScale = self.abRatio * (self:GetEffectiveScale()/UIParent:GetScale()) --used to determine text visibility

		--hide text if it's too small to display
		--check again in one second
		if overallScale < config.minSize then
			self.text:Hide()
			self:ScheduleUpdate(1)
		else
			--update text style based on time remaining
			local styleId = self:GetTextStyleId(remain)
			if (styleId ~= self.textStyle) or forceStyleUpdate then
				self.textStyle = styleId
				self:UpdateTextStyle()
			end

			--make sure that we have text, and then set text
			if self.text:GetFont() then
				self.text:SetFormattedText(self:GetTimeText(remain))
				self.text:Show()
			end
			self:ScheduleUpdate(self:GetNextUpdate(remain))
		end
	else
		self:Stop()
	end
end

function Timer:UpdateTextStyle()
	--print('Timer:UpdateTextStyle')

	local font, size, outline =  fonts[config.fontFace], config.fontSize, config.fontOutline
	local color = config.fontcolors[self.textStyle]

	--fallback to the standard font if the font we tried to set happens to be invalid
	if size > 0 then
		local fontSet = self.text:SetFont(font, size * self.abRatio, outline)
		if not fontSet then
			self.text:SetFont(STANDARD_TEXT_FONT, size * self.abRatio, outline)
		end
	end
	self.text:SetTextColor(unpack(color))
end

function Timer:UpdateTextPosition()
	local abRatio = self.abRatio or 1

	local text = self.text
	text:ClearAllPoints()
	text:SetPoint(config.anchor, 0, 0)
end

function Timer:UpdateShown()
	if self:ShouldShow() then
		self:Show()
		self:UpdateText()
	else
		self:Hide()
	end
end


--[[ Update Scheduling ]]--

function Timer:ScheduleUpdate(delay)
	--print('Timer:ScheduleUpdate', delay)
	OmniCC:ScheduleUpdate(self, delay)
end

function Timer:CancelUpdate()
	--print('Timer:CancelUpdate')
	OmniCC:CancelUpdate(self)
end


--[[ Accessors ]]--

function Timer:GetRemain()
	return self.duration - (GetTime() - self.start)
end

--retrieves the period style id associated with the given time frame
--necessary to retrieve text coloring information from omnicc
function Timer:GetTextStyleId(s)
	if s < SOONISH then
		return 'soon'
	elseif s < MINUTEISH then
		return 'seconds'
	elseif s <  HOURISH then
		return 'minutes'
	else
		return 'hours'
	end
end

--return the time until the next text update
function Timer:GetNextUpdate(remain)

	if remain < (config.tenthsDuration + 0.5) then
		return 0.1
	elseif remain < MINUTEISH then
		return remain - (round(remain) - 0.51)
	elseif remain < config.mmSSDuration then
		return remain - (round(remain) - 0.51)
	elseif remain < HOURISH then
		local minutes = round(remain/MINUTE)
		if minutes > 1 then
			return remain - (minutes*MINUTE - HALFMINUTEISH)
		end
		return remain - (MINUTEISH - 0.01)
	elseif remain < DAYISH then
		local hours = round(remain/HOUR)
		if hours > 1 then
			return remain - (hours*HOUR - HALFHOURISH)
		end
		return remain - (HOURISH - 0.01)
	else
		local days = round(remain/DAY)
		if days > 1 then
			return remain - (days*DAY - HALFDAYISH)
		end
		return remain - (DAYISH - 0.01)
	end
end

--returns a format string, as well as any args for text to display
function Timer:GetTimeText(remain)

	--show tenths of seconds below tenths threshold
	if remain < config.tenthsDuration then
		return '%.1f', remain
	--format text as seconds when at 90 seconds or below
	elseif remain < MINUTEISH then
		--prevent 0 seconds from displaying
		local seconds = round(remain)
		return seconds ~= 0 and seconds or ''
	--format text as MM:SS when below the MM:SS threshold
	elseif remain < config.mmSSDuration then
		local seconds = round(remain)
		return '%d:%02d', seconds/MINUTE, seconds%MINUTE
	--format text as minutes when below an hour
	elseif remain < HOURISH then
		return '%dm', round(remain/MINUTE)
	--format text as hours when below a day
	elseif remain < DAYISH then
		return '%dh', round(remain/HOUR)
	--format text as days
	else
		return '%dd', round(remain/DAY)
	end
end

--returns true if the timer should be shown
--and false otherwise
function Timer:ShouldShow()
	--the timer should have text to display and also have its cooldown be visible
	if not (self.enabled and self.visible) or self.cooldown.noCooldownCount then
		return false
	end

	if self.duration < config.minDuration then
		return false
	end

	--the cooldown of the timer shouldn't be blacklisted
	return config.enabled
end


--[[ Settings Methods ]]--

--[[function Timer:GetSettings()

end]]--


--[[ Meta Functions ]]--

function Timer:ForAll(f, ...)
	if type(f) == 'string' then
		f = self[f]
	end

	for cd, timer in pairs(timers) do
		f(timer, ...)
	end
end

function Timer:ForAllShown(f, ...)
	if type(f) == 'string' then
		f = self[f]
	end

	for cd, timer in pairs(timers) do
		if timer:IsShown() then
			f(timer, ...)
		end
	end
end


--[[ Cooldown Display ]]--

--show the timer if the cooldown is shown
local function cooldown_OnShow(self)
	local timer = Timer:Get(self)
	if timer and timer.enabled then
		if timer:GetRemain() > 0 then
			timer.visible = true
			timer:UpdateShown()
		else
			timer:Stop()
		end
	end
end

--hide the timer if the cooldown is hidden
local function cooldown_OnHide(self)
	local timer = Timer:Get(self)
	if timer and timer.enabled then
		timer.visible = nil
		timer:Hide()
	end
end

--adjust the size of the timer when the cooldown's size changes
--facts to know:
--OnSizeChanged occurs more frequently than you would think
--so I've added a check to only resize timers when a cooldown's width changes
local function cooldown_OnSizeChanged(self, ...)
	local width = ...
	if self.omniccw ~= width then
		self.omniccw = width
		local timer = Timer:Get(self)
		if timer then
			timer:Size(...)
		end
	end
end

local function cooldown_StopTimer(self)
	local timer = Timer:Get(self)
	if timer and timer.enabled then
		timer:Stop()
	end
end

--apply some extra functionality to the cooldown
--so that we can track hide/show/and size changes
local function cooldown_Init(self)
	self:HookScript('OnShow', cooldown_OnShow)
	self:HookScript('OnHide', cooldown_OnHide)
	self:HookScript('OnSizeChanged', cooldown_OnSizeChanged)
	self.omnicc = true
end


local function cooldown_Show(self, start, duration)
	--don't do anything if there's no timer to display, or the timer has been blacklisted
	if self.noCooldownCount or not(start and duration) then
		cooldown_StopTimer(self)
		return
	end

	--hide/show cooldown model as necessary
	self:SetAlpha(config.showCooldownModels and 1 or 0)

	--start timer if duration is over the min duration & the timer is enabled
	if start > 0 and duration >= config.minDuration and config.enabled then
		--apply methods to the cooldown frame if they do not exist yet
		if not self.omnicc then
			cooldown_Init(self)
		end

		--hide cooldown model if necessary and start the timer
		local timer = Timer:Get(self) or Timer:New(self)
		timer:Start(start, duration)
	--stop timer
	else
		cooldown_StopTimer(self)
	end
end


--[[ ActionUI Button ]]--

local actions = {}
local function action_OnShow(self)
	actions[self] = true
end

local function action_OnHide(self)
	actions[self] = nil
end

local function action_Add(button, action, cooldown)
	if not cooldown.omniccAction then
		cooldown:HookScript('OnShow', action_OnShow)
		cooldown:HookScript('OnHide', action_OnHide)
	end
	cooldown.omniccAction = action
end

local class = ns.lib.class
local events = ns.lib.events

local cooldownsComponent = class:extend({

	events = {
		"ACTIONBAR_UPDATE_COOLDOWN",
		"PLAYER_ENTERING_WORLD",
		"ADDON_LOADED",
	},

	ctor = function(self)
		self:include(events)
	end,

	ACTIONBAR_UPDATE_COOLDOWN = function(self)
		for cooldown in pairs(actions) do
			local start, duration = GetActionCooldown(cooldown.omniccAction)
			cooldown_Show(cooldown, start, duration)
		end
	end,

	PLAYER_ENTERING_WORLD = function(self)
		Timer:ForAllShown('UpdateText')
	end,

	ADDON_LOADED = function(self, addonName)

		if addonName == addon then

			hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', cooldown_Show)
			hooksecurefunc('SetActionUIButton', action_Add)

			for i, button in pairs(ActionBarButtonEventsFrame.frames) do
		    	action_Add(button, button.action, button.cooldown)
			end

			self:unregister("ADDON_LOADED")

		end

	end,

})

cooldownsComponent:new()
