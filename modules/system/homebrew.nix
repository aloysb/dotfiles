{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.homebrew;
in {
  options.modules.system.homebrew.enable = lib.mkEnableOption "Homebrew setup (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    homebrew = {
      enable = true;
      #onActivation.cleanup = "uninstall";
      # taps = import ./taps.nix;
      # brews = import ./brews.nix;
      # casks = import ./casks.nix;
    };
  };
}
