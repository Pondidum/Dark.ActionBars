local addon, ns = ...

local class = ns.lib.class
local slash = ns.lib.slash
local style = ns.lib.style
local fonts = ns.lib.fonts

local bars = ns.bars

local bindInfoDisplay = {

	new = function(self, this)

		this = setmetatable(this or {}, { __index = self })

		local bind = CreateFrame("Frame", "DarkBindInfo", UIParent)
		bind:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 150)
		bind:SetSize(200, 60)
		bind:Hide()

		style:frame(bind)

		local name = fonts:create(bind)

		name:SetPoint("TOPLEFT", bind, "TOPLEFT", 5, 0)
		name:SetPoint("TOPRIGHT", bind, "TOPRIGHT", -5, 0)
		name:SetHeight(25)

		local keys = fonts:create(bind)

		keys:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 0)
		keys:SetPoint("TOPRIGHT", name, "BOTTOMRIGHT", 0, 0)
		keys:SetPoint("BOTTOM", bind, "BOTTOM", 0, 0)

		local accept = CreateFrame("Button", "$parentAccept", bind, "ActionButtonTemplate")
		accept:SetPoint("TOPLEFT", bind, "BOTTOMLEFT", 0, -6)
		accept:SetPoint("RIGHT", bind, "CENTER", -3, 0)
		accept:SetHeight(25)

		accept.text = fonts:create(accept)
		accept.text:SetAllPoints(accept)
		accept.text:SetJustifyH("CENTER")
		accept.text:SetText("Accept")

		style:actionButton(accept)

		accept:RegisterForClicks("AnyUp")
		accept:SetScript("OnClick", function() this:accept() end)


		local cancel = CreateFrame("Button", "$parentCancel", bind, "ActionButtonTemplate")
		cancel:SetPoint("TOPRIGHT", bind, "BOTTOMRIGHT", 0, -6)
		cancel:SetPoint("LEFT", bind, "CENTER", 3, 0)
		cancel:SetHeight(25)

		cancel.text = fonts:create(cancel)
		cancel.text:SetAllPoints(cancel)
		cancel.text:SetJustifyH("CENTER")
		cancel.text:SetText("Discard")

		style:actionButton(cancel)

		cancel:RegisterForClicks("AnyUp")
		cancel:SetScript("OnClick", function() this:cancel() end)


		this.ui = bind
		this.name = name
		this.keys = keys

		return this

	end,

	show = function(self)
		self.ui:Show()
	end,

	hide = function(self)
		self.ui:Hide()
	end,

	setInfo = function(self, buttonName, keysBound)

		self.name:SetText(buttonName)
		self.keys:SetText(keysBound)

	end,

}

local bindingActive = false

local keybind = bindInfoDisplay:new({
	description = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbuttons keybinding.",

	accept = function(self)
		bindingActive = false
		self:hide()
	end,

	cancel = function(self)
		bindingActive = false
		self:hide()
	end,
})

local binds = class:extend({

	ctor = function(self)
		self.binds = {}
	end,

	getCommand = function(self, button)

		local command

		if button.buttonType then
			command = button.buttonType .. button:GetID()
		else
			command = button:GetName()

			if command:match("StanceButton") then
				command = "SHAPESHIFTBUTTON" .. button:GetID()
			elseif command:match("PetActionButton") then
				command = "BONUSACTIONBUTTON" .. button:GetID()
			end

		end

		return command
	end,

	readButtonBinds = function(self, button)

		local command = self:getCommand(button)
		local binds = self.binds[button] or {}

		table.wipe(binds)


		for i, v in ipairs({GetBindingKey(command)}) do
			binds[v] = true
		end

		self.binds[button] = binds

	end,

	addButtonBind = function(self, button, bind)

		self.binds[button] = self.binds[button] or {}
		self.binds[button][bind] = true

	end,

	getButtonBinds = function(self, button)

		local binds = {}

		for i,v in ipairs(self.binds[button] or {}) do
		 	table.insert(binds, v)
		end

		return binds
	end,
})

local hoverBinder = class:extend({

	ctor = function(self)

		self.binds = binds:new()

		self:readAllBinds()
		self:hookButtons()
		self:display()

	end,

	readAllBinds = function(self)

		bars.each(function(bar)

			for i, button in ipairs(bar.children) do
				self.binds:readButtonBinds(button)
			end

		end)

	end,

	hookButtons = function(self)

		local onEnter = function(button)

			if not bindingActive then
				return
			end

			local binds = self.binds:getButtonBinds(button)
			local text = table.concat(binds)

			keybind:setInfo(button:GetName(), text)

		end

		local onLeave = function(button)

			if not bindingActive then
				return
			end

			keybind:setInfo("", "")

		end

		bars.each(function(bar)

			for i, button in ipairs(bar.children) do
				button:HookScript("OnEnter", onEnter)
				button:HookScript("OnLeave", onLeave)
			end

		end)

	end,

	display = function(self)

		if bindingActive then
			return
		end

		bindingActive = true
		keybind:show()


	end,
	--keybind:setInfo(self:GetName(), GetBindingKey(command))

})

-- local hoverBind = function()

-- 	local bars = ns.bars

-- 	local onEnter = function(self)

-- 		if not bindingActive then
-- 			return
-- 		end

-- 		local command

-- 		if self.buttonType then
-- 			command = self.buttonType .. self:GetID()
-- 		else
-- 			command = self:GetName()

-- 			if command:match("StanceButton") then
-- 				command = "SHAPESHIFTBUTTON" .. self:GetID()
-- 			elseif command:match("PetActionButton") then
-- 				command = "BONUSACTIONBUTTON" .. self:GetID()
-- 			end

-- 		end

-- 		keybind:setInfo(self:GetName(), GetBindingKey(command))

-- 	end

-- 	local onLeave = function(self)

-- 		if not bindingActive then
-- 			return
-- 		end

-- 		keybind:setInfo("", "")

-- 	end

-- 	bars.each(function(bar)

-- 		for i, button in ipairs(bar.children) do
-- 			button:HookScript("OnEnter", onEnter)
-- 			button:HookScript("OnLeave", onLeave)
-- 		end

-- 	end)

-- 	bindingActive = true
-- 	keybind:show()

-- end

ns.binder = function()
	slash.register("hb", function()
		hoverBinder:new()
	end)
end
