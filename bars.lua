local addon, ns = ...

local configs = {}

local bars = {

	add = function(config)
		configs[config.name] = config
	end,

	get = function(name)
		return configs[name]
	end,

	getBar = function(name)
		local config = configs[name]

		if config then
			return config.bar
		end

		return nil

	end,

	each = function(action)

		for name, config in pairs(configs) do
			action(config)
		end

	end,
}

ns.bars = bars