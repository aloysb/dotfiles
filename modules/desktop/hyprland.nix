{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.hyprland;
  homeDir = specialArgs.home-directory;
  dotfilesDir = specialArgs.dotfiles; # ./dotfiles from flake root
in
{
  options.modules.desktop.hyprland = lib.mkEnableOption "Hyprland Wayland compositor (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    # System-level Hyprland settings from nixos/configuration.nix
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland; # Use hyprland input from flake
      # xwayland.enable = true; # Default is true, can be explicit if needed
      # portalPackage = pkgs.xdg-desktop-portal-hyprland; # Default is fine usually
    };

    # Environment variables specific to Hyprland sessions (if any)
    # environment.sessionVariables = {
    #   XCURSOR_THEME = "Adwaita"; # Example
    #   XCURSOR_SIZE = "24";
    # };

    # Home Manager Hyprland settings from home-manager/home.nix
    # This part applies if home-manager is enabled for the user
    home-manager.users.${specialArgs.username} = lib.mkIf (config.modules.home-manager.enable) {
      # wayland.windowManager.hyprland was how it was structured in home.nix
      # However, programs.hyprland.enable = true is the system NixOS option.
      # For HM, we'd typically symlink configs or set env vars.
      # The original home.nix had wayland.windowManager.hyprland.enable = false but set package and extraConfig.
      # This suggests it was mainly for config management.

      # The actual hyprland.conf is symlinked by the dotfiles module:
      # home.file.".config/hypr/hyprland.conf".source = "${dotfilesDir}/hypr/hyprland.conf";
      # The pkgs.substituteAll for hyprland.conf was in home.nix, let's replicate that logic here if needed.
      # However, the original hyprland.conf doesn't seem to have substitutions.
      # The hyprpaper.conf DID have substitutions.

      # If Hyprland itself needs specific XDG Desktop Portal
      # xdg.portal = {
      #   enable = true;
      #   extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      #   # Default portal can be set if needed
      #   # default = "hyprland";
      # };

      # Ensure related packages for Hyprland ecosystem are available
      # Some of these might be dependencies pulled by programs.hyprland.enable automatically.
      # Others are for user experience within Hyprland (launchers, bars, etc.)
      # These will be handled by their own modules (rofi, waybar) or general packages.
      # environment.systemPackages = with pkgs; [
      #   # hyprpaper # Handled by its own module/service or as a package
      #   # rofi-wayland # Handled by rofi module
      #   # wl-clipboard
      #   # waybar # Handled by waybar module
      #   # mako or dunst for notifications
      #   # grim slurp for screenshots
      # ];

      # Font for hyprland/wayland if not covered by a general font module
      fonts.packages = with pkgs; [
        noto-fonts noto-fonts-cjk noto-fonts-emoji # Good defaults
        font-awesome # For icons
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; }) # Nerd Fonts
      ];

      # Systemd services related to Hyprland environment, e.g., pipewire, polkit agent
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # jack.enable = true; # If JACK support is needed
      };
      # services.power-profiles-daemon.enable = true; # For power management on laptops
      # security.rtkit.enable = true; # For PipeWire real-time audio

      # Polkit agent for authentication in Wayland sessions
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    # Ensure uinput is available for advanced input device handling if needed by specific tools
    boot.kernelModules = [ "uinput" ];
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
    users.groups.uinput = {}; # User needs to be in this group (handled by users.nix)
  };
}
