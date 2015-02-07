local addon, ns = ...

local class = ns.lib.class
local events = ns.lib.events

local addon = class:extend({

	ctor = function(self)
		self:include(events)
		self:register("PLAYER_ENTERING_WORLD")
	end,

	PLAYER_ENTERING_WORLD = function()

		ns.hideBlizzard()
		ns.binder()

		ns.bars.each(function(bar)
			bar:performLayout()
		end)

	end,
})

Dark.actionBars = addon:new()
