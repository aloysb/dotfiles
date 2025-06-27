{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.firefox;
in {
  options.modules.desktop.firefox.enable = lib.mkEnableOption "Firefox web browser";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
