{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale.enable = lib.mkEnableOption "Tailscale (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    services.tailscale.enable = true;
  };
}
