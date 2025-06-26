# Desktop environment modules
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./core.nix # Should be empty or removed
    #./firefox.nix

    # Linux DE components
    # ./waybar.nix
    #./rofi.nix
    # ./wofi.nix # To be created (if used)

    # Cross-platform GUI apps
    # ./wezterm.nix # (already in packages, but could be a module for specific settings)

    # Darwin GUI elements
    ./dock.nix
  ];
}
