# Programs modules
{ lib, config, pkgs, ... }: {
  imports = [
    ./core.nix # Should be empty or removed

    # CLI Tools
    ./zsh.nix
    ./git.nix
    ./nvim.nix
    ./fzf.nix
    ./bat.nix
    ./eza.nix
    ./zoxide.nix
    ./direnv.nix
    ./gpg.nix
    ./pass.nix # password-store

    # Development related
    # ./tmux.nix # If you add it

    # General packages & dotfiles management
    ./packages.nix # For home.packages
    ./dotfiles.nix # For symlinks
  ];
}
