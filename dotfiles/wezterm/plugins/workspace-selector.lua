local wezterm = require("wezterm")
local act     = wezterm.action
local mux     = wezterm.mux

local M       = {}

M.setup       = function()
  wezterm.on('gui-startup', function(_)
    -- FRONTEND workspace – one tab per app
    local front_win, front_tab = mux.spawn_window {
      workspace = 'frontend',
      cwd       = '/home/you/code/frontend/app‑1',
    }
    local app_dirs = {
      '/Users/aloys/code/dabble/apps.telescope.co/signal/',
      '/Users/aloys/code/dabble/platform.telescope.co/'
    }
    for _, dir in ipairs(app_dirs) do
      front_win:spawn_tab { cwd = dir }
    end

    -- API workspace – split pane (editor + server)
    local api_win, api_tab = mux.spawn_window {
      workspace = 'api',
      cwd       = '/Users/aloys/code/dabble/api.telescope.co/http-api/',
    }
    api_tab:split { direction = 'Right', size = 0.50 }

    -- Land in the frontend workspace by default
    mux.set_active_workspace('frontend')
  end)


  wezterm.on("update-right-status", function(window, pane)
    local ws = window:active_workspace()

    -- build a FormatItem list:
    local status = wezterm.format {
      -- make it bold (optional)
      { Attribute = { Intensity = "Bold" } },
      -- the text itself
      { Text = "WS: " .. ws },
      -- you can reset attributes afterwards if needed:
      { Attribute = "ResetAttributes" },
    }

    window:set_right_status(status)
  end)
end

function M.get_keybinding(hyper)
  return {
    key = "S",
    mods = hyper,
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  }
end

return M
