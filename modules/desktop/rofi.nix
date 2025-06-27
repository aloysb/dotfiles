{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.desktop.rofi;
  homeDir = specialArgs.home-directory;
  dotfilesDir = specialArgs.dotfiles; # ./dotfiles from flake root
in {
  options.modules.desktop.rofi = lib.mkEnableOption "Rofi application launcher (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland; # Ensure Wayland compatible version
      };
    };
  };
}
