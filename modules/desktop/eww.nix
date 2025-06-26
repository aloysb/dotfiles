{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.eww;
in
{
  options.modules.desktop.eww = lib.mkEnableOption "Eww (ElKowars wacky widgets) (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      # Eww is typically configured with its own set of files.
      # This module will ensure Eww is installed and can optionally manage its service.

      home.packages = [ pkgs.eww ]; # Ensure Eww is installed

      # Symlink Eww configuration directory if it's in your dotfiles
      # This should be handled by the dotfiles.nix module.
      # Example: home.file.".config/eww".source = "${specialArgs.dotfiles}/eww";

      # Systemd service to run Eww daemon for the user
      # This is optional; Eww can also be launched by Hyprland's startup execs.
      # systemd.user.services.eww = {
      #   Unit = {
      #     Description = "Eww - ElKowar's Wacky Widgets";
      #     PartOf = [ "graphical-session.target" ];
      #   };
      #   Service = {
      #     ExecStart = "${pkgs.eww}/bin/eww daemon";
      #     Restart = "on-failure"; # Or "always"
      #   };
      #   Install = {
      #     WantedBy = [ "graphical-session.target" ];
      #   };
      # };
    };
  };
}
