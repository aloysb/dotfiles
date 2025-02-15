local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

require("./ui").setup(config)
require("./keys").setup(config)
--require("./font").setup(config)

return config
