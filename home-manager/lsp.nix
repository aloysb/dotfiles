{pkgs}:
with pkgs; [
  # LSP
  typescript-language-server # TS/TSX
  nil # Nix language server
  alejandra # Nixfmt
  golangci-lint # golang
  lua-language-server # lua
]
