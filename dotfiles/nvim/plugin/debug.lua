local dap = require('dap')
dap.adapters.go =
{
  type = 'server',
  host = '127.0.0.1',
  port = '${port}',

  -- -- **Add these two**:
  -- localRoot  = vim.fn.getcwd(), -- e.g. /Users/aloys/.../http-api
  -- remoteRoot = '/app',          -- path inside the container
  --
  -- -- optional, but can help:
  -- cwd        = vim.fn.getcwd(),
}

dap.configurations.go = {
  {
    type = "go",
    name = "telescope API",
    mode = "remote",
    request = "attach",
    host = '127.0.0.1',
    port = 2345,
  }
}

require('dap-go').setup()

require("dapui").setup()
print("hello")

dap.listeners.after.event_terminated['auto_attach'] = function()
  print("hello")
  vim.defer_fn(function()
    dap.run(dap.configurations.go[1])
  end, 300)
end
dap.listeners.after.event_exited['auto_attach'] = dap.listeners.after.event_terminated['auto_attach']


vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dlg',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set('n', '<leader>du', function() require("dapui").toggle() end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
--   require('dap.ui.widgets').hover()
-- end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
--   require('dap.ui.widgets').preview()
-- end)
-- vim.keymap.set('n', '<Leader>df', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set('n', '<Leader>ds', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.scopes)
-- end)
--
--
