local M = {}

function M.setup(config)
  -- Opacity settings
  config.window_background_opacity = 0.92
  config.text_background_opacity = 0.5

  -- Font and UI settings
  config.line_height = 1.3
  config.font_size = 13.0
  config.window_decorations = "RESIZE"
  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = true
  config.color_scheme = "nordfox"
  --config.color_scheme = "nord-light"

  --	config.color_scheme = "Tokyo Night Light (Gogh)"
  config.adjust_window_size_when_changing_font_size = true
end

return M
