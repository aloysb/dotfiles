local wezterm = require 'wezterm'
local M = {}

local wezterm = require 'wezterm'
local M = {}

function M.setup(config)
  config.font =
      wezterm.font('JetBrains Mono')
  -- config.font = wezterm.font({
  --   family = 'Fira Code',
  --   weight = 'Regular',
  --   -- Optionally, you can enable ligature features:
  --   harfbuzz_features = { 'calt', 'liga' },
  -- })
end

return M
