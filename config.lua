local addon, ns = ...

local config = {
	buttonSize = 25,
	spacing = 6,
	screenPadding = 10,

	cooldowns = {

		enabled = true,
		minDuration = 2.5,
		showCooldownModels = true,
		anchor = "CENTER",
		minSize = 0.5,

		tenthsDuration = 8,
		mmSSDuration = 0,

		fontFace = "normal",
		fontSize = 18,
		fontOutline = 'OUTLINE',

		fontcolors = {
			soon 	= { 1,		0,		0,		1, },
			seconds = { 1,		1,		0,		1, },
			minutes = {	1,		1,		1,		1, },
			hours 	= { 0.7,	0.7,	0.7,	1, },
		},
	},

	binding = {
		storeTo = "ACCOUNT"
	}

}

ns.config = config
