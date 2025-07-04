{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.desktop.waybar;
in {
  options.modules.desktop.waybar = lib.mkEnableOption "Waybar status bar (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    # Waybar is typically a Home Manager program
    home-manager.users.${specialArgs.username} = {
      programs.waybar = {
        enable = true;
        package = pkgs.waybar; # Or a specific variant if needed
      };

      # Include packages that Waybar might need for its modules, if not dependencies of Waybar itself
      home.packages = with pkgs; [
        playerctl # For MPRIS module (music player control)
        pavucontrol # For PulseAudio module (if using it, or use pipewire tools)
        networkmanagerapplet # For network applet in systray (if using systray and NM)
        libappindicator-gtk3 # For systray icons
        gnome.gnome-tweaks # For fontconfig settings that Waybar might respect
        font-awesome # Icons
        (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];}) # Also in hyprland.nix
      ];
    };
  };
}
