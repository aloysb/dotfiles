# Placeholder for core system module
{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
  ];
}
