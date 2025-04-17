{pkgs}:
with pkgs; [
  # LSP
  typescript-language-server # TS/TSX
  nil # Nix language server
  alejandra # Nixfmt
  golangci-lint # golang
  lua-language-server # lua
  biome # a toolchain for JS, useful for formatting json files as well
  zls # zig
  ruff # python lint/format
  elixir-ls
  emmet-language-server
  #  pylsp # python lsp
]
