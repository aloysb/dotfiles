{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.homebrew;
in {
  options.modules.system.homebrew = lib.mkEnableOption "Homebrew setup (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    # This module configures the `nix-homebrew` module itself,
    # which should be imported in the host configuration:
    # `inputs.nix-homebrew.darwinModules.nix-homebrew`

    nix-homebrew = {
      enable = true; # Ensures the underlying nix-homebrew module is active
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      };
      mutableTaps = false; # Declarative tap management
    };
  };
}
