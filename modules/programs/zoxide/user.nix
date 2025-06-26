{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.zoxide;
in {
  options.modules.programs.zoxide.enable = lib.mkEnableOption "zoxide (smarter cd)";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = config.modules.programs.zsh.enable; # If zsh module is active
      # enableBashIntegration = true;
      # enableFishIntegration = true;
      # options = [ "--cmd cd" ]; # Example options if needed
    };
  };
}
