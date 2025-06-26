# This file acts as a bridge between the host's module enable flags
# and the actual import of Home Manager modules.
{ lib, config, pkgs, ... }:

let
  cfg = config.modules; # shortcut to access the main module flags
in
{
  imports = [
    # System / Core HM setup
    (lib.mkIf cfg.system.sops.enable ./system/sops-hm.nix) # Example for HM part of sops

    # Programs - CLI
    (lib.mkIf cfg.programs.git.enable ./programs/git.nix)
    (lib.mkIf cfg.programs.zsh.enable ./programs/zsh.nix)
    (lib.mkIf cfg.programs.nvim.enable ./programs/nvim.nix)
    (lib.mkIf cfg.programs.fzf.enable ./programs/fzf.nix)
    (lib.mkIf cfg.programs.bat.enable ./programs/bat.nix)
    (lib.mkIf cfg.programs.eza.enable ./programs/eza.nix)
    (lib.mkIf cfg.programs.zoxide.enable ./programs/zoxide.nix)
    (lib.mkIf cfg.programs.direnv.enable ./programs/direnv.nix)
    (lib.mkIf cfg.programs.gpg.enable ./programs/gpg.nix)
    (lib.mkIf cfg.programs.pass.enable ./programs/pass.nix)
    (lib.mkIf cfg.programs.dotfiles.enable ./programs/dotfiles.nix) # For symlinks

    # Programs - General Packages (home.packages)
    (lib.mkIf cfg.programs.packages.enable ./programs/packages.nix)

    # Desktop / GUI - Handled by Home Manager
    (lib.mkIf cfg.desktop.firefox.enable ./desktop/firefox.nix)
    # (lib.mkIf cfg.desktop.wezterm.enable ./desktop/wezterm.nix) # If Wezterm gets its own HM module

    # HM Services (Linux specific, but controlled by host flags)
    # These would need to be defined in modules/services/*-hm.nix
    # Example:
    # (lib.mkIf (cfg.services.cliphist.enable && pkgs.stdenv.isLinux) ./services/cliphist-hm.nix)
    # (lib.mkIf (cfg.services.hyprpaper.enable && pkgs.stdenv.isLinux) ./services/hyprpaper-hm.nix)
    # (lib.mkIf (cfg.services.podman.enable && pkgs.stdenv.isLinux) ./services/podman-hm.nix)
  ];

  # Common Home Manager settings that are not module-specific can go here
  # For example, if not set in the host config:
  # home.stateVersion = "24.11";
  # programs.home-manager.enable = true;

  # Default session variables or environment settings
  home.sessionVariables = lib.mkIf (cfg.home-manager.enable or true) { # Ensure HM is generally on
    XDG_CONFIG_HOME = "$HOME/.config";
    # Add other common session variables if needed
  };

  # Default session path entries
  home.sessionPath = lib.mkIf (cfg.home-manager.enable or true) [
    "${config.home.homeDirectory}/.local/bin" # A common user bin path
  ];

  # Allow unfree packages for Home Manager if the global flag is set
  nixpkgs.config.allowUnfree = lib.mkIf (config.nixpkgs.config.allowUnfree or false) true;
}
