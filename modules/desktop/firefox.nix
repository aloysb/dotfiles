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
    # This is a standard Home Manager module.
    # We configure `programs.firefox` and `home.packages` directly.
    programs.firefox = {
      enable = true;
      # You can add more detailed profile configuration here later
    };

    #home.packages = [pkgs.firefox];
  };
}
