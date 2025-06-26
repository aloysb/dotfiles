{ lib, config, pkgs, ... }:

let
  cfg = config.modules.programs.eza;
in
{
  options.modules.programs.eza = lib.mkEnableOption "eza (ls replacement)";

  config = lib.mkIf (config.modules.home-manager.enable && cfg.enable) {
    programs.eza = {
      enable = true;
      enableZshIntegration = config.modules.programs.zsh.enable; # If zsh module is active
      # enableBashIntegration = true; # If using bash
      # enableFishIntegration = true; # If using fish
      git = true; # Enable git integration (shows status of files)
      icons = true; # Enable icons (requires a Nerd Font or similar)
      # Extra options can be set as aliases or zsh functions if needed,
      # e.g., `exa --long --header --git` aliased to `ll`
    };
  };
}
