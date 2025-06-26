{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.TODO;
in {
  config = lib.mkIf cfg.enable {
    # TODO;
  };
}
