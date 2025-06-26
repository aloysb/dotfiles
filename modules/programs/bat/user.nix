{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.bat;
in {
  options.modules.programs.bat.enable = lib.mkEnableOption "bat (cat clone with syntax highlighting)";

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      # Configuration options for bat can be added here if needed
      # e.g., theme, style, etc.
      # config = {
      #   theme = "Nord"; # Example theme
      # };
      extraPackages = with pkgs.bat-extras; [
        batman # man page viewer using bat
        batgrep # grep using bat for highlighting
        # batdiff # diff with bat, though git delta is used for git diffs
      ];
    };
  };
}
