{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.services.restic;
  username = specialArgs.username;

  parseDotEnv = import ./dotenv.nix {
    inherit lib;
    #file = ./.env.para;
    file = ./.env.example;
  };
  # A list of paths to back up
  # The tilde '~' will be automatically expanded to the user's home directory.
  backupPaths = [
    "/Users/${username}/areas"
    "/Users/${username}/resources"
    "/Users/${username}/archives"
    # "/Users/${username}/projects" # You can add this back if you're happy with the global excludes
  ];
in {
  options = {
    modules.services.restic = {
      enable = lib.mkEnableOption "restic backup service";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
      # Linux-specific configuration goes here.
      # For example, setting up systemd services.
      services.restic = {
        enable = true; # This typically enables the actual systemd service
        backups = {
          local = import ./para.nix {};
        };
      };
    })

    (lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      home.packages = with pkgs; [
        restic
      ];
      launchd.agents.restic-backup = {
        enable = true;
        # The command to execute
        config = {
          ProgramArguments =
            [
              "${pkgs.restic}/bin/restic"
              "backup"
            ]
            ++ backupPaths;

          EnvironmentVariables = parseDotEnv;

          StartCalendarInterval = {
            Hour = 0;
            Minute = 0;
          };

          StandardOutPath = "/Users/${username}/Library/Logs/restic-backup.log";
          StandardErrorPath = "/Users/${username}/Library/Logs/restic-backup.log";

          RunAtLoad = true;
        };
      };
    })
  ];
}
