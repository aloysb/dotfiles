-- File: wezterm/keybindings.lua
local wezterm = require("wezterm")
local act = wezterm.action
local workspace_selector = require("plugins.workspace-selector")
local layout_selector = require("plugins.layout-selector")
local docker = require("plugins.docker")
local M = {}

--workspace_selector.setup()

local hyper = "SUPER|ALT|SHIFT|CTRL"

local function map(key, mods, action)
  return {
    key = key,
    mods = mods,
    action = action,
  }
end

function M.setup(config)
  config.disable_default_key_bindings = true
  config.leader = { key = "Space", mods = "SUPER|SHIFT" }

  config.keys = {
    -- general
    map("p", hyper, act.ActivateCommandPalette),
    map("o", hyper, act.ShowLauncher),
    map("c", hyper, act.ActivateCopyMode),
    map("v", "SUPER", act.PasteFrom("Clipboard")),
    map(" ", hyper, act.QuickSelect),
    map("+", hyper, act.IncreaseFontSize),
    map("-", hyper, act.DecreaseFontSize),
    map("z", hyper, act.ShowDebugOverlay),
    map("n", hyper, act.SpawnWindow),
    map("t", hyper, act.SpawnTab 'CurrentPaneDomain'),
    map("[", hyper, act.ActivateTabRelative(-1)),
    map("]", hyper, act.ActivateTabRelative(1)),


    -- config.keys = {
    --   { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    --   { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
    -- }

    -- panes
    map("h", hyper, act.ActivatePaneDirection("Left")),
    map("j", hyper, act.ActivatePaneDirection("Down")),
    map("k", hyper, act.ActivatePaneDirection("Up")),
    map("l", hyper, act.ActivatePaneDirection("Right")),
    map("f", hyper, act.TogglePaneZoomState),
    map("x", hyper, act.CloseCurrentPane({ confirm = false })),
    map("d", hyper, act.SplitVertical),
    map("v", hyper, act.SplitHorizontal),
    map("/", hyper, act.Search({ Regex = "" })),
    map("s", hyper, act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" })),

    -- resize mode
    map(
      "r",
      hyper,
      act.ActivateKeyTable({
        name = "resize_pane",
        one_shot = false,
      })
    ),

    -- workspace and layout selectors
    table.unpack(workspace_selector.get_keybinding(hyper)),

    layout_selector.get_keybinding(hyper),
    docker.get_keybinding(hyper),
  }

  config.key_tables = {
    resize_pane = {
      { key = "h",      action = act.AdjustPaneSize({ "Left", 10 }) },
      { key = "l",      action = act.AdjustPaneSize({ "Right", 10 }) },
      { key = "k",      action = act.AdjustPaneSize({ "Up", 10 }) },
      { key = "j",      action = act.AdjustPaneSize({ "Down", 10 }) },
      { key = "Escape", action = "PopKeyTable" },
    },
  }
end

return M
