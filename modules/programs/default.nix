# Programs modules
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./core.nix
    ./nvim/system.nix
    ./git/system.nix
  ];
}
