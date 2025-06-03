local wezterm = require 'wezterm'
local config = wezterm.config_builder()


require("./ui").setup(config)
require("./keys").setup(config)
require("./launcher").setup(config)
require("./font").setup(config)

return config
