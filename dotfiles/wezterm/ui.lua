local M = {}


-- ~/.config/wezterm/colors.lua  (or just paste inside your wezterm.lua)

local nordfox = {
  bg0    = "#232831", -- darkest
  bg1    = "#2e3440", -- main background
  bg2    = "#39404f",
  bg3    = "#444c5e", -- cursor-line – nice highlight
  fg1    = "#cdcecf",
  fg_dim = "#7e8188",
  blue   = "#81a1c1",
}


function M.setup(config)
  -- Opacity settings
  config.window_background_opacity = 0.92

  config.text_background_opacity = .2
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  config.colors = config.colors or {}


  config.colors = {
    tab_bar = {
      background = nordfox.bg1, -- strip along the bottom
      active_tab = {            -- the tab you’re on
        bg_color = nordfox.bg3,
        fg_color = nordfox.fg1,
        intensity = "Bold",
      },
      inactive_tab = { -- other tabs
        bg_color = nordfox.bg1,
        fg_color = nordfox.fg_dim,
      },
      inactive_tab_hover = { -- when mouse is over a tab
        bg_color = nordfox.bg2,
        fg_color = nordfox.fg1,
        italic   = true,
      },
      new_tab = {
        bg_color = nordfox.bg1,
        fg_color = nordfox.blue,
      },
      new_tab_hover = {
        bg_color = nordfox.bg2,
        fg_color = nordfox.blue,
        italic   = true,
      }
    }
  }

  -- Font and UI settings
  config.line_height = 1.3
  config.font_size = 13.0
  config.window_decorations = "RESIZE"
  config.enable_tab_bar = true

  config.color_scheme = "nordfox"
  --config.color_scheme = "nord-light"
  --	config.color_scheme = "Tokyo Night Light (Gogh)"
  --
  config.adjust_window_size_when_changing_font_size = true
  config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.8,
  }
end

return M
