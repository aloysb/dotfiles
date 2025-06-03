local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

function M.get_keybinding(hyper)
	return {
		key = "y",
		mods = hyper,
		action = wezterm.action_callback(function(window, pane)
			local layouts = {
				{
					id = "1",
					label = "Vertical 75/25",
				},
				{
					id = "2",
					label = "Vertical/Horizontal 75/25",
				},
			}

			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							if id == "1" then
								pane:split({ direction = "Right", size = 0.25 })
							elseif id == "2" then
								pane:split({ direction = "Right", size = 0.25 })
								pane:split({ direction = "Bottom", size = 0.25 })
							end
						end
					end),
					title = "Choose Workspace",
					choices = layouts,
					fuzzy = true,
					fuzzy_description = "Fuzzy find and/or make a workspace: ",
				}),
				pane
			)
		end),
	}
end

return M
