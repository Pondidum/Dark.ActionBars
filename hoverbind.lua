local addon, ns = ...

local slash = ns.lib.slash
local style = ns.lib.style

local core = Dark.core
local ui = core.ui

local bindingActive = false

local bindInfoDisplay = {

	new = function(self, this)

		this = setmetatable(this or {}, { __index = self })

		local bind = CreateFrame("Frame", "DarkBindInfo", UIParent)
		bind:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 150)
		bind:SetSize(200, 60)
		bind:Hide()

		style:frame(bind)

		local name = ui.createFont(bind)

		name:SetPoint("TOPLEFT", bind, "TOPLEFT", 5, 0)
		name:SetPoint("TOPRIGHT", bind, "TOPRIGHT", -5, 0)
		name:SetHeight(25)

		local keys = ui.createFont(bind)

		keys:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 0)
		keys:SetPoint("TOPRIGHT", name, "BOTTOMRIGHT", 0, 0)
		keys:SetPoint("BOTTOM", bind, "BOTTOM", 0, 0)

		local accept = CreateFrame("Button", "$parentAccept", bind, "ActionButtonTemplate")
		accept:SetPoint("TOPLEFT", bind, "BOTTOMLEFT", 0, -6)
		accept:SetPoint("RIGHT", bind, "CENTER", -3, 0)
		accept:SetHeight(25)

		accept.text = ui.createFont(accept)
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

		cancel.text = ui.createFont(cancel)
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

local hoverBind = function()

	local bars = ns.bars

	local onEnter = function(self)

		if not bindingActive then
			return
		end

		local command

		if self.buttonType then
			command = self.buttonType .. self:GetID()
		else
			command = self:GetName()

			if command:match("StanceButton") then
				command = "SHAPESHIFTBUTTON" .. self:GetID()
			elseif command:match("PetActionButton") then
				command = "BONUSACTIONBUTTON" .. self:GetID()
			end

		end

		keybind:setInfo(self:GetName(), GetBindingKey(command))

	end

	local onLeave = function(self)

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

	bindingActive = true
	keybind:show()

end

ns.binder = function()
	slash.register("hb", hoverBind)
end
