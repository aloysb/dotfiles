{
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.lazygit;
in {
  options.modules.programs.lazygit.enable = lib.mkEnableOption "Lazygit the awesome git TUI";

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
