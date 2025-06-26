{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.gpg;
in {
  options.modules.programs.gpg.enable = lib.mkEnableOption "GnuPG for encryption and signing";

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      # This enables the gpg-agent through home-manager's interface for it
      # which is different from programs.gnupg.agent
    };

    # Configure GPG agent separately for more control, if needed,
    # especially for system-wide implications or specific settings not covered by programs.gpg.
    # The original nixos/configuration.nix and home-manager/home.nix had gnupg agent settings.
    # For Home Manager context:
    # programs.gnupg.agent = {
    #  enable = true;
    #  enableSSHSupport = true; # From original nixos/configuration.nix and implied by home.nix's git config
    # pinentryFlavor = "curses"; # Example: if you want a specific pinentry
    #};

    # For NixOS systems, the system-level GPG agent might also be configured.
    # This module primarily handles the Home Manager aspect.
    # If system-level GPG agent settings are needed (from nixos/configuration.nix),
    # they would go into a system-level module, e.g., modules/services/gpg-agent.nix
    # services.gnupg.agent.enable = lib.mkIf pkgs.stdenv.isLinux true;
    # services.gnupg.agent.enableSSHSupport = lib.mkIf pkgs.stdenv.isLinux true;
  };
}
