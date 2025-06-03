local blink = require("blink.cmp")

blink.setup({
  -- completion sources shown in the menu
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- inline function‑signature pop‑up
  signature = { enabled = true },

  -- all completion‑related knobs live under one table
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
})
