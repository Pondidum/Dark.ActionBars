local addon, ns = ...

local config = ns.config
local style = ns.lib.style

local bar = Darker.layoutEngine:extend({

	ctor = function(self, options)

		options.layout = "series"
		options.itemSize = config.buttonSize
		options.itemSpacing = config.spacing

		self:base():ctor(options.container, options)

		self.anchor = options.anchor
		self.name = options.name
		self.customiseFrame = options.customiseFrame or self.customiseFrame

		options.init(self)
		ns.bars.add(self)

	end,

	afterLayout = function(self)

		local anchor, other, otherAnchor, x, y = unpack(self.anchor)
		local otherBar = ns.bars.getBar(other)

		self.container:ClearAllPoints()
		self.container:SetPoint(anchor, otherBar or other , otherAnchor, x, y)

		UIPARENT_MANAGED_FRAME_POSITIONS[self.container:GetName()] = nil

		for i, child in ipairs(self.children) do
			self:customiseFrame(child)
		end
	end,

	customiseFrame = function(self, frame)
		frame:SetAttribute("showgrid", 1)
		frame:Show()

		style:actionButton(frame)
	end,

	add = function(self, child)
		self:addChild(child)
	end,
})

ns.bar = bar
