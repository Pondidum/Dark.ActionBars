local addon, ns = ...

local dialog = {

	new = function(self, name)

		local this = setmetatable({}, { __index = self})
		this.name = name

		this:init()

		return this

	end,

	init = function(self)

		local dialogDefinition =  {
			text = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbuttons keybinding.",
			button1 ="Save",
			button2 = "Discard",
			OnAccept = function() self:save() end,
			OnCancel = function() self:discard() end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = false
		}

		StaticPopupDialogs[self.name] = dialogDefinition

	end,

	save = function(self)
		self:hide()
	end,

	discard = function(self)
		self:hide()
	end,

	show = function(self)
		StaticPopup_Show(self.name)
	end,

	hide = function(self)
		StaticPopup_Hide(self.name)
	end
}

ns.dialog = dialog

--local d = dialog:new("KEYBIND_MODE")

