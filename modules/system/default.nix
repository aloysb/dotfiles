# System modules
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./core.nix # Should be empty or removed if not used
    ./nix-settings.nix
    ./users.nix
    ./homebrew.nix # homebrew module (Darwin only)
  ];
}
