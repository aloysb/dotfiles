# lower case uname
system := `uname | tr '[:upper:]' '[:lower:]'`

hms:
   nix run home-manager/master -- switch --flake .#{{system}}
nix-switch:
   nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{{system}}
nvim-reload:
  nix profile remove dotfiles/nvim
  nix profile install git+file:///Users/aloys/.config/nix?dir=dotfiles/nvim#nvim
