local addon, ns = ...

local init = function()

	local core = Dark.core

	local lib = {
		fonts = core.fonts,
		events = core.events,
	}

	ns.lib = lib

end

init()
