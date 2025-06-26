{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.rofi;
  homeDir = specialArgs.home-directory;
  dotfilesDir = specialArgs.dotfiles; # ./dotfiles from flake root
in
{
  options.modules.desktop.rofi = lib.mkEnableOption "Rofi application launcher (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland; # Ensure Wayland compatible version
        # Themes and configs are symlinked by the dotfiles module.
        # Example of setting themes directly if not using files:
        # theme = "nord"; # If a nord theme is built-in or provided
        # themes = [
        #   { name = "nord"; src = pkgs.fetchurl { ... }; }
        # ];
        # extraConfig = { modi = "drun,run,window"; };
      };

      # Ensure Rofi config files are symlinked
      # This is handled by the dotfiles.nix module:
      # home.file.".config/rofi/config.rasi".source = "${dotfilesDir}/rofi/config.rasi";
      # home.file.".config/rofi/nord.rasi".source = "${dotfilesDir}/rofi/nord.rasi";

      # Packages that Rofi might need for its plugins or modi
      home.packages = with pkgs; [
        # rofi-plugins # If you use specific plugins not bundled
        # networkmanager_dmenu # For a Rofi-based network manager
        # Add other Rofi related tools/scripts here
      ];
    };
  };
}
