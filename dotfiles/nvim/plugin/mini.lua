local spec_treesitter = require('mini.ai').gen_spec.treesitter
require("mini.ai").setup(
  {
    F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
    o = spec_treesitter({
      a = { '@conditional.outer', '@loop.outer' },
      i = { '@conditional.inner', '@loop.inner' },
    })
  }
)
require("mini.surround").setup({})
require("mini.comment").setup({})
require("mini.pairs").setup({})
require("mini.bufremove").setup({})
require("mini.bracketed").setup({})
