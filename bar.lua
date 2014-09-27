local addon, ns = ...

local config = ns.config

local core = Dark.core
local style = core.style


local bar = core.frameSeries:extend({

	new = function(self, this)

		setmetatable(this, { __index = self })

		this.frames = {}
		this.frameSize = config.buttonSize
		this.spacing = config.spacing

		this:init()

		ns.bars.add(this)

		return this
	end,

	afterLayout = function(self)

		local anchor, other, otherAnchor, x, y = unpack(self.anchor)
		local otherBar = ns.bars.getBar(other)

		self.container:ClearAllPoints()
		self.container:SetPoint(anchor, otherBar or other , otherAnchor, x, y)

		UIPARENT_MANAGED_FRAME_POSITIONS[self.container:GetName()] = nil
	end,

	customiseFrame = function(self, frame)

		frame:SetAttribute("showgrid", 1)
		frame:Show()

		style.actionButton(frame)
	end,

})

ns.bar = bar
