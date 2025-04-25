local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux


require("./ui").setup(config)
require("./keys").setup(config)
require("./launcher").setup(config)
require("./font").setup(config)


wezterm.on('gui-startup', function(_)
  -- frontend workspace – one tab per app
  local front_win, front_tab = mux.spawn_window {
    workspace = 'frontend',
    cwd       = '/home/you/code/frontend/app‑1',
  }
  local app_dirs = {
    '/users/aloys/code/dabble/apps.telescope.co/signal/',
    '/users/aloys/code/dabble/platform.telescope.co/'
  }
  for _, dir in ipairs(app_dirs) do
    front_win:spawn_tab { cwd = dir }
  end

  -- api workspace – split pane (editor + server)
  local api_win, api_tab = mux.spawn_window {
    workspace = 'api',
    cwd       = '/users/aloys/code/dabble/api.telescope.co/http-api/',
  }
  api_tab:split { direction = 'right', size = 0.50 }

  -- land in the frontend workspace by default
  mux.set_active_workspace('frontend')
end)

return config
