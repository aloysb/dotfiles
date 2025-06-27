{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.programs.nvim;
  dotfilesDir = specialArgs.dotfiles; # Path to ./dotfiles from flake root
in {
  options.modules.programs.nvim.enable = lib.mkEnableOption "Neovim editor configuration";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.neovim];
  };
}
