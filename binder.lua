local addon, ns = ...

local slash = ns.lib.slash
local bind = CreateFrame("Frame", "DarkHoverBind", UIParent)

local config = ns.config

local dialog = ns.dialog:new({
	name = "KEYBIND_MODE",
	description = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbuttons keybinding.",

	save = function(self)
		bind:Deactivate(true)
		self:hide()
	end,

	discard = function(self)
		bind:Deactivate(false)
		self:hide()
	end
})

local slashHandler = function()

	if InCombatLockdown() then
		print("You can't bind keys in combat.") return
	end

	if not bind.loaded then
		local find = string.find
		local _G = getfenv(0)

		bind:SetFrameStrata("DIALOG")
		bind:EnableMouse(true)
		bind:EnableKeyboard(true)
		bind:EnableMouseWheel(true)
		bind.texture = bind:CreateTexture()
		bind.texture:SetAllPoints(bind)
		bind.texture:SetTexture(0, 0, 0, .25)
		bind:Hide()

		local elapsed = 0
		GameTooltip:HookScript("OnUpdate", function(self, e)
			elapsed = elapsed + e
			if elapsed < .2 then return else elapsed = 0 end
			if (not self.comparing and IsModifiedClick("COMPAREITEMS")) then
				GameTooltip_ShowCompareItem(self)
				self.comparing = true
			elseif ( self.comparing and not IsModifiedClick("COMPAREITEMS")) then
				for key, frame in pairs(self.shoppingTooltips) do
					frame:Hide()
				end
				self.comparing = false
			end
		end)
		hooksecurefunc(GameTooltip, "Hide", function(self) for key, tt in pairs(self.shoppingTooltips) do tt:Hide() end end)

		bind:SetScript("OnEvent", function(self) self:Deactivate(false) end)
		bind:SetScript("OnLeave", function(self) self:HideFrame() end)
		bind:SetScript("OnKeyUp", function(self, key) self:Listener(key) end)
		bind:SetScript("OnMouseUp", function(self, key) self:Listener(key) end)
		bind:SetScript("OnMouseWheel", function(self, delta) if delta>0 then self:Listener("MOUSEWHEELUP") else self:Listener("MOUSEWHEELDOWN") end end)

		function bind:Update(b, spellmacro)
			if not self.enabled or InCombatLockdown() then return end
			self.button = b
			self.spellmacro = spellmacro

			self:ClearAllPoints()
			self:SetAllPoints(b)
			self:Show()

			ShoppingTooltip1:Hide()

			if spellmacro=="SPELL" then
				self.button.id = SpellBook_GetSpellBookSlot(self.button)
				self.button.name = GetSpellBookItemName(self.button.id, SpellBookFrame.bookType)

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					--self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = {GetBindingKey(spellmacro.." "..bind.button.name)}
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			elseif spellmacro=="MACRO" then
				self.button.id = self.button:GetID()

				if floor(.5+select(2,MacroFrameTab1Text:GetTextColor())*10)/10==.8 then self.button.id = self.button.id + 36 end

				self.button.name = GetMacroInfo(self.button.id)

				GameTooltip:SetOwner(bind, "ANCHOR_NONE")
				--GameTooltip:SetPoint("BOTTOM", bind, "TOP", 0, 1)
				GameTooltip:AddLine(bind.button.name, 1, 1, 1)

				bind.button.bindings = {GetBindingKey(spellmacro.." "..bind.button.name)}
					if #bind.button.bindings == 0 then
						GameTooltip:AddLine("No bindings set.", .6, .6, .6)
					else
						GameTooltip:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							GameTooltip:AddDoubleLine("Binding"..i, bind.button.bindings[i], 1, 1, 1)
						end
					end
				GameTooltip:Show()
			elseif spellmacro=="STANCE" or spellmacro=="PET" then
				self.button.id = tonumber(b:GetID())
				self.button.name = b:GetName()

				if not self.button.name then return end

				if not self.button.id or self.button.id < 1 or self.button.id > (spellmacro=="STANCE" and 10 or 12) then
					self.button.bindstring = "CLICK "..self.button.name..":LeftButton"
				else
					self.button.bindstring = (spellmacro=="STANCE" and "SHAPESHIFTBUTTON" or "BONUSACTIONBUTTON")..self.button.id
				end

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					--self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = {GetBindingKey(bind.button.bindstring)}
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			else
				self.button.action = tonumber(b.action)
				self.button.name = b:GetName()

				if not self.button.name then return end

				if not self.button.action or self.button.action < 1 or self.button.action > 132 then
					self.button.bindstring = "CLICK "..self.button.name..":LeftButton"
				else
					local modact = 1+(self.button.action-1)%12
					if self.button.action < 25 or self.button.action > 72 then
						self.button.bindstring = "ACTIONBUTTON"..modact
					elseif self.button.action < 73 and self.button.action > 60 then
						self.button.bindstring = "MULTIACTIONBAR1BUTTON"..modact
					elseif self.button.action < 61 and self.button.action > 48 then
						self.button.bindstring = "MULTIACTIONBAR2BUTTON"..modact
					elseif self.button.action < 49 and self.button.action > 36 then
						self.button.bindstring = "MULTIACTIONBAR4BUTTON"..modact
					elseif self.button.action < 37 and self.button.action > 24 then
						self.button.bindstring = "MULTIACTIONBAR3BUTTON"..modact
					end
				end

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					--self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = {GetBindingKey(bind.button.bindstring)}
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			end
		end

		function bind:Listener(key)
			if key == "ESCAPE" or key == "RightButton" then
				for i = 1, #self.button.bindings do
					SetBinding(self.button.bindings[i])
				end
				print("All keybindings cleared for |cff00ff00"..self.button.name.."|r.")
				self:Update(self.button, self.spellmacro)
				if self.spellmacro~="MACRO" then GameTooltip:Hide() end
				return
			end

			if key == "LSHIFT"
			or key == "RSHIFT"
			or key == "LCTRL"
			or key == "RCTRL"
			or key == "LALT"
			or key == "RALT"
			or key == "UNKNOWN"
			or key == "LeftButton"
			then return end

			if key == "MiddleButton" then key = "BUTTON3" end
			if key == "Button4" then key = "BUTTON4" end
			if key == "Button5" then key = "BUTTON5" end

			local alt = IsAltKeyDown() and "ALT-" or ""
			local ctrl = IsControlKeyDown() and "CTRL-" or ""
			local shift = IsShiftKeyDown() and "SHIFT-" or ""

			if not self.spellmacro or self.spellmacro=="PET" or self.spellmacro=="STANCE" then
				SetBinding(alt..ctrl..shift..key, self.button.bindstring)
			else
				SetBinding(alt..ctrl..shift..key, self.spellmacro.." "..self.button.name)
			end
			print(alt..ctrl..shift..key.." |cff00ff00bound to |r"..self.button.name..".")
			self:Update(self.button, self.spellmacro)
			if self.spellmacro~="MACRO" then GameTooltip:Hide() end
		end
		function bind:HideFrame()
			self:ClearAllPoints()
			self:Hide()
			GameTooltip:Hide()
		end
		function bind:Activate()
			self.enabled = true
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end


		function bind:Deactivate(save)

			local bindTarget = config.binding.saveTo == "ACCOUNT" and 1 or 2

			if save then
				SaveBindings(bindTarget)
				print("All keybindings have been saved.")
			else
				LoadBindings(bindTarget)
				print("All newly set keybindings have been discarded.")
			end

			self.enabled = false
			self:HideFrame()
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end

		-- REGISTERING
		local stance = StanceButton1:GetScript("OnClick")
		local pet = PetActionButton1:GetScript("OnClick")
		local button = SecureActionButton_OnClick

		local function register(val)
			if val.IsProtected and val.GetObjectType and val.GetScript and val:GetObjectType()=="CheckButton" and val:IsProtected() then
				local script = val:GetScript("OnClick")
				if script==button then
					val:HookScript("OnEnter", function(self) bind:Update(self) end)
				elseif script==stance then
					val:HookScript("OnEnter", function(self) bind:Update(self, "STANCE") end)
				elseif script==pet then
					val:HookScript("OnEnter", function(self) bind:Update(self, "PET") end)
				end
			end
		end

		local val = EnumerateFrames()
		while val do
			register(val)
			val = EnumerateFrames(val)
		end

		for i=1,12 do
			local b = _G["SpellButton"..i]
			b:HookScript("OnEnter", function(self) bind:Update(self, "SPELL") end)
		end

		local function registermacro()
			for i=1,36 do
				local b = _G["MacroButton"..i]
				b:HookScript("OnEnter", function(self) bind:Update(self, "MACRO") end)
			end
		end

		if not IsAddOnLoaded("Blizzard_MacroUI") then
			hooksecurefunc("LoadAddOn", function(addon)
				if addon=="Blizzard_MacroUI" then
					registermacro()
				end
			end)
		else
			registermacro()
		end
		bind.loaded = 1
	end

	if not bind.enabled then
		bind:Activate()
		dialog:show()
	end

end


local core = Dark.core

local style = core.style
local ui = core.ui


local bindInfoDisplay = {

	new = function(self)

		local this = setmetatable({}, { __index = self })


		local bind = CreateFrame("Frame", "DarkBindInfo", UIParent)
		bind:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 150)
		bind:SetSize(200, 60)
		bind:Hide()

		style.addShadow(bind)
		style.applyBackgroundTo(bind)

		local name = ui.createFont(bind)

		name:SetPoint("TOPLEFT", bind, "TOPLEFT", 5, 0)
		name:SetPoint("TOPRIGHT", bind, "TOPRIGHT", -5, 0)
		name:SetHeight(25)


		local keys = ui.createFont(bind)

		keys:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 0)
		keys:SetPoint("TOPRIGHT", name, "BOTTOMRIGHT", 0, 0)
		keys:SetPoint("BOTTOM", bind, "BOTTOM", 0, 0)

		this.ui = bind
		this.name = name
		this.keys = keys

		return this

	end,

	show = function(self)
		self.ui:Show()
	end,

	setInfo = function(self, buttonName, keysBound)

		self.name:SetText(buttonName)
		self.keys:SetText(keysBound)

	end,

}

local keybind = bindInfoDisplay:new()

local keybindConfirm = ns.dialog:new({
	name = "DARK_KEYBIND_MODE",
	description = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbuttons keybinding.",
})

local hoverBind = function()

	local bars = ns.bars
	local active = false

	keybindConfirm.save = function()
		active = false
	end

	keybindConfirm.discard = function()
		active = false
	end

	local onEnter = function(self)

		if not active then
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

	bars.each(function(bar)

		for i, button in ipairs(bar.frames) do
			button:HookScript("OnEnter", onEnter)
		end

	end)

	active = true
	keybindConfirm:show()
	keybind:show()

end

ns.binder = function()
	slash.register("bind", slashHandler)
	slash.register("hb", hoverBind)
end
