hms:
 home-manager switch --flake .#linux
nixos-rebuild:
  cd nixos && nixos-rebuild switch --flake .
