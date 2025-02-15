local wezterm = require 'wezterm'
local M = {}

function M.setup(config)
  config.font = wezterm.font({
    -- family='Monaspace Neon',
    family = 'MonaspiceAr Nerd Font Propo',
    -- family='Monaspace Xenon',
    -- family='Monaspace Radon',
    -- family='Monaspace Krypton',
    weight = 'Regular',
    --harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
  })

  -- -- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
  -- -- wezterm ls-fonts
  -- -- wezterm ls-fonts --list-system
  -- config.font_rules = {
  --   --
  --   -- Italic (comments)
  --   --
  --   {
  --     intensity = 'Normal',
  --     italic = true,
  --     font = wezterm.font({
  --       family = "Monaspice Radon",
  --       weight = "ExtraLight",
  --       stretch = "Normal",
  --       style = "Normal",
  --       harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
  --     })
  --   },
  --
  --   --
  --   -- Bold (highlighting)
  --   --
  --   {
  --     intensity = 'Bold',
  --     italic = false,
  --     font = wezterm.font({
  --       family = "Monaspice Krypton",
  --       weight = "Light",
  --       stretch = "Normal",
  --       style = "Normal",
  --       harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
  --     })
  --   },
  -- }
end

return M
