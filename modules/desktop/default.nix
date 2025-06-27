# Desktop environment modules
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [
      ./core.nix # Should be empty or removed
      #./firefox.nix
      # Linux DE components
      # ./waybar.nix
      #./rofi.nix
      # ./wofi.nix # To be created (if used)
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ./dock.nix
    ];
}
