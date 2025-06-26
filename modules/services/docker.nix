{ lib, config, pkgs, ... }:

let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = lib.mkEnableOption "Docker daemon configuration";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) { # Docker daemon primarily for Linux
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true; # Explicitly ensure it starts on boot
      autoPrune = {
        enable = true;
        # flags = ["--all"]; # Example: prune everything
        # dates = "daily";   # Example: prune daily
      };
      # Rootless Docker setup from original nixos/configuration.nix
      rootless = {
        enable = true;
        setSocketVariable = true; # Sets DOCKER_HOST for rootless Docker user sessions
      };
      # Add current user to the docker group if not using rootless or for admin tasks
      # This is handled by the users module: users.users.<name>.extraGroups = [ "docker" ];
    };

    # Ensure the user is part of the 'docker' group if this module is enabled.
    # This is now handled in modules/system/users.nix by adding "docker" to extraGroups.
    # users.users.${config.system.primaryUser}.extraGroups = lib.mkIf (config.users.users.${config.system.primaryUser} != null) [ "docker" ];
  };
}
