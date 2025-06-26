# Placeholder for core programs module
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
