# Services modules
{pkgs, ...}: {
  imports =
    [
      ./core.nix # Should be empty or removed

      # NixOS Services
      ./docker.nix

      # Darwin Services
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      ./aerospace.nix
      ./openssh.nix
      ./tailscale/darwin.nix
    ];
}
