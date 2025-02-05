local wezterm = require 'wezterm'
local config = wezterm.config_builder()

require("./ui").setup(config)
require("./keys").setup(config)

return config

