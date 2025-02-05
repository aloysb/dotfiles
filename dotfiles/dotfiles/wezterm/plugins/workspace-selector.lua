local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

function M.get_keybinding(hyper)
	return {
		key = "S",
		mods = hyper,
		action = wezterm.action_callback(function(window, pane)
			local home = wezterm.home_dir
			local workspaces = {
				{ id = home, label = "Home" },
				{ id = home .. "/work", label = "Work" },
				{ id = home .. "/personal", label = "Personal" },
				{ id = home .. "/.config", label = "Config" },
				{ id = home .. "/sknks", label = "SKNKS" },
				{ id = home .. "/code/alonova", label = "Alonova" },
			}

			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							wezterm.log_info("id = " .. id)
							wezterm.log_info("label = " .. label)
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										cwd = id,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
					fuzzy_description = "Fuzzy find and/or make a workspace: ",
				}),
				pane
			)
		end),
	}
end

return M
