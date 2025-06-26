# Desktop environment modules
{ lib, config, pkgs, ... }: {
  imports = [
    ./core.nix # Should be empty or removed

    # Linux DE components
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    # ./wofi.nix # To be created (if used)
    ./dunst.nix
    ./foot.nix
    ./eww.nix

    # Cross-platform GUI apps
    ./firefox.nix
    # ./wezterm.nix # (already in packages, but could be a module for specific settings)

    # Darwin GUI elements
    ./dock.nix
  ];
}
