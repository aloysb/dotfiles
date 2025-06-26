{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  imports = [
    ./system/default.nix
    ./services/default.nix
    ./programs/default.nix
    ./desktop/default.nix
  ];

  options.modules = {
    system = {
      # Base system configurations
      nix-settings = mkEnableOption "Nix settings (GC, trusted users, etc.)";
      users = mkEnableOption "User accounts and groups";
      sops = mkEnableOption "Sops integration for secrets management";
      homebrew = mkEnableOption "Homebrew setup (Darwin-specific)"; # Will be conditional
      # Potentially others like 'fonts', 'locale', 'time'
    };

    services = {
      # System services
      openssh = mkEnableOption "OpenSSH server";
      docker = mkEnableOption "Docker daemon";
      # Potentially 'bluetooth', 'printing', 'pipewire', 'cliphist' (Linux HM)
      aerospace = mkEnableOption "Aerospace window manager (Darwin-specific)";
      # hyprpaper (Linux HM) - might fit better under desktop if it's user-specific service
      # podman (Linux HM)
    };

    programs = {
      # User-level programs, mostly via Home Manager
      # CLI
      git = mkEnableOption "Git version control";
      zsh = mkEnableOption "Zsh shell and configuration";
      nvim = mkEnableOption "Neovim editor";
      tmux = mkEnableOption "Tmux terminal multiplexer"; # Example, if you add it
      fzf = mkEnableOption "fzf fuzzy finder";
      bat = mkEnableOption "bat (cat clone with syntax highlighting)";
      eza = mkEnableOption "eza (ls replacement)";
      zoxide = mkEnableOption "zoxide (smarter cd)";
      direnv = mkEnableOption "direnv per-directory environments";
      gpg = mkEnableOption "GnuPG for encryption and signing";
      pass = mkEnableOption "Password Store (pass)"; # password-store
      # General packages
      packages = mkEnableOption "General suite of packages"; # For home.packages
      dotfiles = mkEnableOption "Symlinking of dotfiles"; # For managing symlinks from home-manager/symlinks.nix
    };

    desktop = {
      # GUI applications and desktop environment components
      # Linux DE
      hyprland = mkEnableOption "Hyprland Wayland compositor";
      waybar = mkEnableOption "Waybar status bar";
      rofi = mkEnableOption "Rofi application launcher";
      wofi = mkEnableOption "Wofi (alternative to Rofi, if used)"; # Example from user request
      dunst = mkEnableOption "Dunst notification daemon"; # Example from user request
      foot = mkEnableOption "Foot terminal emulator"; # Example from user request
      eww = mkEnableOption "Eww widgets"; # Example from user request

      # Cross-platform GUI
      firefox = mkEnableOption "Firefox web browser";
      # wezterm = mkEnableOption "WezTerm terminal emulator"; # Already in home.packages, but could be a module

      # Darwin GUI
      dock = mkEnableOption "macOS Dock settings (Darwin-specific)";
      # Potentially 'yabai', 'skhd' if you used them
    };

    # A global switch for all home-manager modules, can be useful
    home-manager = {
      enable = mkEnableOption "Enable Home Manager integration";
      # Potentially user-specific HM settings if not derived from host
      # username = mkOption { type = types.str; description = "Username for Home Manager."; };
      # homeDirectory = mkOption { type = types.str; description = "Home directory for Home Manager."; };
    };

  };
}
