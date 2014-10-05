local addon, ns = ...

local init = function()

	local core = Dark.core

	local lib = {
		fonts = core.fonts,
		events = core.events,
		slash = core.slash,
	}

	ns.lib = lib

end

init()
