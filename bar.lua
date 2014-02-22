local addon, ns = ...

local settings = ns.settings

local core = Dark.core
local style = core.style

local bar = {

	new = function(self, config)

		setmetatable(config, { __index = self })

		config.buttons = {}
		config:init()

		ns.bars.add(config)

		return config

	end,

	layout = function(self)

		local barWidth = ((settings.buttonSize + settings.spacing) * self.columns) - settings.spacing
		local barHeight = ((settings.buttonSize + settings.spacing) * self.rows) - settings.spacing

		self.bar:SetSize(barWidth, barHeight)

		local previous = first

		for i = 1, #self.buttons do

			local button = self.buttons[i]

			self:styleButton(button)

			button:ClearAllPoints()

			if (i - 1) % self.columns == 0 then

				local row = math.floor((i - 1) / self.columns)
				local offset = (settings.buttonSize + settings.spacing) * row

				button:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, -offset)
			else
				button:SetPoint("LEFT", previous, "RIGHT", settings.spacing, 0)
			end

			previous = button

		end

		local anchor, other, otherAnchor, x, y = unpack(self.anchor)
		local otherBar = ns.bars.getBar(other)

		self.bar:ClearAllPoints()
		self.bar:SetPoint(anchor, otherBar or other , otherAnchor, x, y)

		UIPARENT_MANAGED_FRAME_POSITIONS[self.bar:GetName()] = nil
	end,

	styleButton = function(self, button)

		button:SetSize(settings.buttonSize, settings.buttonSize)
		button:SetAttribute("showgrid", 1)
		button:Show()

		style.actionButton(button)

	end,

}

ns.bar = bar
