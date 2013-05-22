local addon, ns = ...
local core = Dark.core
local events = core.events.new()
	
events.register("PLAYER_ENTERING_WORLD", function()
	ns.hideBlizzard()
	ns.skinButtons()
	ns.layoutBars()
end)