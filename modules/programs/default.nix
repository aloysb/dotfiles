# Programs modules
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./core.nix # Should be empty or removed

    # CLI Tools
    ./nvim/system.nix
    ./git/system.nix
    # ./fzf.nix
    # ./bat.nix
    # ./zoxide.nix
    # ./direnv.nix
    # ./gpg.nix
    # ./pass.nix # password-store

    # General packages & dotfiles management
    #./packages.nix # For home.packages
  ];
}
