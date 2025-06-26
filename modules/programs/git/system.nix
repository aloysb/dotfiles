{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.git;
in {
  options.modules.programs.git.enable = lib.mkEnableOption "Git version control";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
