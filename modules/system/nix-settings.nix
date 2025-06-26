{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.system.nix-settings;
  username = config.users.users.${config.system.primaryUser}.name; # Get username from config
in {
  options.modules.system.nix-settings.enable = lib.mkEnableOption "Nix settings (GC, trusted users, etc.)";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root"] ++ (lib.optional (username != null) username);
    };

    nix.optimise.automatic = true;

    nix.gc = {
      automatic = true;
      interval = {
        Weekday = 0; # Changed from Day to Weekday for NixOS compatibility
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Darwin specific nix settings
    nix.extraOptions = lib.mkIf pkgs.stdenv.isDarwin ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    # environment.systemPackages for things that should be globally available on the system
    # This is a common place, but specific packages might be better in their own modules
    # or under home.packages for user-specific tools.
    # For now, let's add curl as it was in darwin/configuration.nix
    environment.systemPackages = lib.mkIf pkgs.stdenv.isDarwin [pkgs.curl];
  };
}
