# Services modules
{...}: {
  imports = [
    ./core.nix # Should be empty or removed

    # NixOS Services
    ./docker.nix

    # Darwin Services
    ./aerospace.nix
    ./openssh.nix
  ];
}
