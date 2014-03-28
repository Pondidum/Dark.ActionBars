local addon, ns = ...

local config = {
	buttonSize = 25,
	spacing = 6,
	screenPadding = 10,

	cooldowns = {

		config.enabled = true
		config.minDuration = 2.5
		config.showCooldownModels = true
		config.anchor = "CENTER"
		config.minSize = 0.5

		config.tenthsDuration = 8
		config.mmSSDuration = 0

		config.fontFace = fonts.normal
		config.fontSize = 18
		config.fontOutline = 'OUTLINE'
		config.fontcolors = {
			soon 	= { 1,		0,		0,		1, },
			seconds = { 1,		1,		0,		1, },
			minutes = {	1,		1,		1,		1, },
			hours 	= { 0.7,	0.7,	0.7,	1, },
		}
	},

}

ns.config = config
