local w = require("wezterm")
local M = {}

-- Helper function to get running containers
function M.get_keybinding(hyper)
	return {
		key = "i",
		mods = hyper,
		action = w.action_callback(function(window, pane)
			local success, stdout, stderr = w.run_child_process({
				"docker",
				"container",
				"ls",
				"--format",
				"{{.ID}}:{{.Names}}",
			})

			if not success then
				w.log_error("couldn't get the list of running docker containers")
				w.log_error(stderr)
				return nil
			end
			w.log_info(stdout)
			-- local dps = w.json_parse(stdout)
			-- w.log_info(dps)
		end),
	}
end

return M
