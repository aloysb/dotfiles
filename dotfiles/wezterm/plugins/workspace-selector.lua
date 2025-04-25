local wezterm = require("wezterm")
local act     = wezterm.action
local mux     = wezterm.mux

local M       = {}

M.setup       = function()
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
  return { {
    key = "S",
    mods = hyper,
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
    {
      key    = 'U',
      mods   = hyper,
      action = act.PromptInputLine {
        description = 'Rename workspace',
        action = wezterm.action_callback(function(win, _pane, line)
          if line and #line > 0 then
            mux.rename_workspace(win:mux_window():get_workspace(), line)
            win:toast_notification('Workspace renamed to', line, nil, 3000)
          end
        end),
      },
    },
  }
end

return M
