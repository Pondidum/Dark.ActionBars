local addon, ns = ...

local dialog = {

	new = function(self, config)

		setmetatable(config, { __index = self})
		config:init()

		return config

	end,

	init = function(self)

		local dialogDefinition =  {
			text = self.description,
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

