require 'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>v", -- set to `false` to disable one of the mappings
      node_incremental = "l",
      scope_incremental = "L",
      node_decremental = "h",
    },
  },
}
