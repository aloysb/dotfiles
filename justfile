system := uname

e:
@echo {{system}}

hms-linux:
   home-manager switch --flake .#linux
hms-darwin:
   home-manager switch --flake .#darwin
darwin-nix-init:
   nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin
darwin-hm-init:
   nix run home-manager/master -- --flake .#darwin switch
