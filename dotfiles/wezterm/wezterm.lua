local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

require("./ui").setup(config)
require("./keys").setup(config)

config.keys = {
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
}
return config
