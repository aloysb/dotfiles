{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.TODO
in {
  options.modules.TODO = lib.mkEnableOption "description here";

  config = lib.mkIf cfg.enable {
    #something = TODO;
  };
}
