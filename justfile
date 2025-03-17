system := `uname | tr '[:upper:]' '[:lower:]'`

hms:
   home-manager switch --flake .#{{system}}
nix-init:
   nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{{system}}
hm-init:
   nix run home-manager/master -- --flake .#{{system}} switch
