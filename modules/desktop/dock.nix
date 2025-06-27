{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.dock;
in {
  options.modules.desktop.dock.enable = lib.mkEnableOption "macOS Dock settings (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    # Configuration based on the original darwin/dock.nix
    system.defaults.dock = {
      autohide = true;
      dashboard-in-overlay = false; # Though dashboard is gone, setting might exist
      mru-spaces = false;
      show-process-indicators = true; # Redundant with system.dock.showindicators, but harmless
      launchanim = false;
      expose-group-app = true;
      scroll-to-open = true;
      minimize-to-application = true;
      # autohideDelay = 2.0; # Optional: delay before hiding
      # autohideSpeed = 0.5; # Optional: speed of hide/show animation
      mineffect = "scale"; # "genie" or "scale"
      orientation = "bottom"; # "left", "bottom", "right"
      showhidden = true; # Show translucent icons for hidden apps
      tilesize = 48; # Size of icons in pixels

      # Persistent apps in the Dock
      # The list of apps needs to be exact bundle identifiers or paths to .app bundles
      persistent-apps = [
        "/Applications/WezTerm.app"
        "/Applications/Emacs.app" # Assuming Emacs is installed via Homebrew cask or similar
        "/Applications/Firefox.app"
        "/System/Applications/System Settings.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/Applications/Spotify.app"
        "/Applications/Discord.app"
      ];

      # Persistent others (folders, URLs)
      # Example: persistentOthers = [ "~/Downloads" ];
      persistent-others = [];
    };
  };
}
