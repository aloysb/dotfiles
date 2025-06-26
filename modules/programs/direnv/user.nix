{
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.direnv;
in {
  options.modules.programs.direnv.enable = lib.mkEnableOption "direnv per-directory environments";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = config.modules.programs.zsh.enable; # If zsh module is active
      # enableBashIntegration = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true; # Enable nix-direnv integration for use with .envrc files
      # that use `use flake` or `use nix`.
      # You can specify a standard library for direnv if needed
      # stdlib = ''
      #   # custom direnv functions
      # '';
    };
  };
}
