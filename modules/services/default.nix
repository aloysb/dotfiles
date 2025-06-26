# Services modules
{ lib, config, pkgs, ... }: {
  imports = [
    ./core.nix # Should be empty or removed

    # NixOS Services
    ./docker.nix
    ./openssh.nix

    # Darwin Services
    ./aerospace.nix

    # Home Manager user services (if any are promoted to system-wide thinking)
    # e.g. ./cliphist-hm.nix if it were a system service instead of user
  ];
}
