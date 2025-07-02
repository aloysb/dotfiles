{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.hm.core;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  options.modules.hm.core.enable = lib.mkEnableOption "General suite of user packages";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Common packages from original home.nix
        curl
        wezterm # Assuming this is preferred over foot for now, or can be conditional
        ripgrep
        just
        fd
        jq
        tree
        lazydocker
        zig
        entr
        neofetch
        caddy
        corepack
        go
        delve
        ffmpeg
        devenv
        uv
        pre-commit
        thunderbird
        docker # Docker CLI tools
        docker-compose
        postgresql # Client tools
        pm2
        nodejs_20 # Or a more generic nodejs latest/lts
        btop
        go-task # Task runner

        # AI related tools
        claude-code
        repomix
        ollama
      ]
      ++ lib.optionals isDarwin [
        colima
        _1password-cli # Ensure this package name is correct
      ]
      ++ lib.optionals isLinux [
        # hyprland related pkgs - some of these might be dependencies of hyprland module itself
        # or system-level packages rather than home.packages
        # hyprpaper # often a service or system package for hyprland
        # rofi-wayland # if rofi module doesn't provide it
        # wl-clipboard
        # waybar # if waybar module doesn't provide it

        # others for Linux
        brightnessctl
        font-awesome # For icons in waybar etc.
        # impala # network TUI - check if still needed/used
        bluez # Bluetooth utilities, often system-level but sometimes user tools are useful
      ];

    programs.thefuck = {
      enable = false; # As per original config
      enableInstantMode = true;
      enableZshIntegration = config.modules.programs.zsh.enable;
    };

    programs.home-manager.enable = true; # This is for the HM module itself
  };
}
