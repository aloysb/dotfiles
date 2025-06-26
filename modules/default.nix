{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.home-manager.enable = mkEnableOption "Home Manager integration";
  imports = [
    ./system/default.nix
    ./services/default.nix
    ./programs/default.nix
    ./desktop/default.nix
  ];
}
