{ lib, config, pkgs, specialArgs, ... }: # Added specialArgs

let
  cfg = config.modules.system.users;
  # It's better to get username and homeDirectory from specialArgs
  # as they are passed down from the flake and are consistent.
  username = specialArgs.username;
  homeDirectory = specialArgs.home-directory;
in
{
  options.modules.system.users = lib.mkEnableOption "User accounts and groups";

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      name = username;
      home = homeDirectory;
      # Common group for sudo access, typically 'wheel'
      extraGroups = lib.mkIf pkgs.stdenv.isLinux [ "wheel" ]
                 ++ lib.mkIf pkgs.stdenv.isDarwin [ "admin" ]; # 'admin' for macOS sudo
    };

    # NixOS specific user settings
    users.users.${username} = lib.mkIf pkgs.stdenv.isLinux {
      isNormalUser = true;
      # initialPassword = "password"; # WARNING: Insecure. Manage with sops or imperatively.
                                    # This should be removed or handled by sops.
      # shell = pkgs.zsh; # This will be handled by the ZSH module via Home Manager
      extraGroups = [ "nixos" "docker" "uinput" "input" ]; # From original nixos/configuration.nix
                                                          # "wheel" is already added above.
      # packages = with pkgs; [ gh ]; # User packages better handled by Home Manager
    };

    # Darwin specific user settings
    system.primaryUser = lib.mkIf pkgs.stdenv.isDarwin username;

    # environment.variables can be set here if they are truly system-wide
    # For user-specific EDITOR/VISUAL, Home Manager is preferred.
    environment.variables = lib.mkIf pkgs.stdenv.isLinux {
      EDITOR = "vim"; # From original nixos/configuration.nix
      VISUAL = "vim"; # From original nixos/configuration.nix
    };

    # Security settings from Darwin config
    security.pam.services.sudo_local.touchIdAuth = lib.mkIf pkgs.stdenv.isDarwin true;

    # Keyboard settings from Darwin config (can be a separate module if it grows)
    system.keyboard.enableKeyMapping = lib.mkIf pkgs.stdenv.isDarwin true;
    system.keyboard.remapCapsLockToEscape = lib.mkIf pkgs.stdenv.isDarwin false; # using karabiners instead

    # Startup sound from Darwin config
    system.startup.chime = lib.mkIf pkgs.stdenv.isDarwin false;

    # System defaults from Darwin config
    system.defaults = lib.mkIf pkgs.stdenv.isDarwin {
      finder.QuitMenuItem = true;
      finder.FXRemoveOldTrashItems = true;
      NSGlobalDomain."com.apple.swipescrolldirection" = false; # non-natural scrolling
    };

    # Fonts (example from Darwin, can be common)
    fonts.packages = lib.mkIf pkgs.stdenv.isDarwin [
      pkgs.nerd-fonts.fira-code
    ];
    # For Linux, fonts are often managed differently or as part of DE setup.
    # If common fonts are needed for both, this can be unconditional.

    # Base packages that were in nixos/configuration.nix environment.systemPackages
    # This is distinct from home.packages.
    # environment.systemPackages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    #   # vim # Handled by programs.vim.enable or HM
    #   # wget
    # ]);
  };
}
