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
        gh
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
        delta # Git delta is also configured in the git module, this ensures it's in packages
        caddy
        corepack
        go
        delve
        ffmpeg
        devenv
        hurl
        uv
        pre-commit
        thunderbird
        docker # Docker CLI tools
        docker-compose
        postgresql # Client tools
        pm2
        glow # Markdown reader
        nodejs_20 # Or a more generic nodejs latest/lts
        btop
        wireguard-tools # For VPN
        go-task # Task runner

        # AI related tools
        claude-code
        repomix
        ollama
        aider-chat # This is in an overlay, ensure overlay is active
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

    # Programs that were enabled via `programs.<name>.enable` but are essentially just packages
    # if their modules don't do much more than install them + basic config.
    # Example: yazi was `programs.yazi.enable`. If its module only installs and adds zsh integration
    # (which is often default or covered by zsh plugin managers), it could just be in home.packages.
    # For now, assuming specific modules like yazi, eza, etc., handle their own package installation.

    programs.yazi = {
      enable = true; # Keep explicit yazi program enable for now
      enableZshIntegration = config.modules.programs.zsh.enable;
    };

    programs.thefuck = {
      enable = false; # As per original config
      enableInstantMode = true;
      enableZshIntegration = config.modules.programs.zsh.enable;
    };

    # home-manager itself, if it needs to be in packages (usually not)
    # programs.home-manager.enable = true; # This is for the HM module itself
  };
}
