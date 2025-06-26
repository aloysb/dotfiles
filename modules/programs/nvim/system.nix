{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.programs.nvim;
in {
  options.modules.programs.nvim.enable = lib.mkEnableOption "Neovim editor configuration";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.neovim]; # Barebone Neovim
  };
}
