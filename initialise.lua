local addon, ns = ...

local init = function()

	local core = Dark.core
	local dark = Darker

	local lib = {
		fonts = dark.media.fonts,
		events = core.events,
		slash = core.slash,
	}

	ns.lib = lib

end

init()
