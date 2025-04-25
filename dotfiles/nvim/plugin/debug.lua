require("lze").load {
  -- core dap
  {
    "nvim-dap",
    keys = {
      { "<leader>dc",  "<cmd>lua require('dap').continue()<CR>",                                                    desc = "DAP: Continue" },
      { "<leader>dn",  "<cmd>lua require('dap').step_over()<CR>",                                                   desc = "DAP: Step Over" },
      { "<leader>di",  "<cmd>lua require('dap').step_into()<CR>",                                                   desc = "DAP: Step Into" },
      { "<leader>do",  "<cmd>lua require('dap').step_out()<CR>",                                                    desc = "DAP: Step Out" },
      { "<leader>db",  "<cmd>lua require('dap').toggle_breakpoint()<CR>",                                           desc = "DAP: Toggle Breakpoint" },
      { "<leader>dlg", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", desc = "DAP: Logpoint" },
      { "<leader>dr",  "<cmd>lua require('dap').repl.open()<CR>",                                                   desc = "DAP: Open REPL" },
      { "<leader>dl",  "<cmd>lua require('dap').run_last()<CR>",                                                    desc = "DAP: Run Last" },
    },
    after = function()
      local dap = require("dap")
      dap.adapters.go = {
        type = "server",
        host = "127.0.0.1",
        port = 2345,
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Telescope API",
          mode = "remote",
          request = "attach",
          host = "127.0.0.1",
          port = 2345,
          substitutePath = {
            {
              from = "/Users/aloys/code/dabble/api.telescope.co/http-api/",
              to   = "/app", -- inside container
            },
          },
        },
      }
    end,
  },
  -- UI floating windows
  {
    "nvim-dap-ui",
    on_plugin = "nvim-dap",
    after = function()
      require("dapui").setup()
      vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP UI Toggle" })
    end,
  },
  {
    "nvim-nio",
    dep_of = "nvim-dap-ui",
  },
  -- Go-specific helpers (breakpoints, hover, etc)
  {
    "nvim-dap-go",
    on_plugin = "nvim-dap",
    after = function()
      require("dap-go").setup()
    end,
  },
  -- in-buffer virtual text for eval results
  {
    "nvim-dap-virtual-text",
    on_plugin = "nvim-dap",
    after = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
