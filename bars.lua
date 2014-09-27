local addon, ns = ...

local configs = {}
local ordered = {}

local bars = {

	add = function(config)
		configs[config.name] = config
		table.insert(ordered, config)
	end,

	get = function(name)
		return configs[name]
	end,

	getBar = function(name)
		local config = configs[name]

		if config then
			return config.container
		end

		return nil

	end,

	each = function(action)

		for i, config in ipairs(ordered) do
			action(config)
		end

	end,
}

ns.bars = bars
