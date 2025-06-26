{ lib, config, pkgs, ... }:

let
  cfg = config.modules.desktop.dock;
in
{
  options.modules.desktop.dock = lib.mkEnableOption "macOS Dock settings (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    # Configuration based on the original darwin/dock.nix
    system.dock = {
      enable = true; # Enable dock management
      autohide = true;
      # autohideDelay = 2.0; # Optional: delay before hiding
      # autohideSpeed = 0.5; # Optional: speed of hide/show animation
      mineffect = "scale"; # "genie" or "scale"
      orientation = "bottom"; # "left", "bottom", "right"
      showhidden = true; # Show translucent icons for hidden apps
      showindicators = true; # Show indicators for open apps
      showLaunchpad = true; # Show Launchpad icon
      tilesize = 48; # Size of icons in pixels

      # Persistent apps in the Dock
      # The list of apps needs to be exact bundle identifiers or paths to .app bundles
      # Example: persistentApps = [ "/Applications/Safari.app" "com.apple.Terminal" ];
      # From original dock.nix:
      persistentApps = [
        "/Applications/WezTerm.app"
        "/Applications/Google Chrome Dev.app"
        "/Applications/Safari Technology Preview.app"
        # "/Applications/Emacs.app" # Assuming Emacs is installed via Homebrew cask or similar
        # "/Applications/Firefox.app"
        # "/Applications/Zed.app"
        "/Applications/Obsidian.md"
        "/System/Applications/System Settings.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        # "/Applications/Spotify.app"
        # "/Applications/Discord.app"
        # "/Applications/Telegram.app"
        # "/Applications/WhatsApp.app"
        # "/Applications/Signal.app"
        # "/Applications/Notion.app"
        # "/Applications/Linear.app"
        # "/Applications/Cron.app"
        # "/Applications/Spark Desktop.app"
        # "/Applications/Superhuman.app"
        # "/Applications/Things3.app"
        # "/Applications/Tailscale.app" # If installed as an app
        # "/Applications/Parcel.app"
      ];

      # Persistent others (folders, URLs)
      # Example: persistentOthers = [ "~/Downloads" ];
      # From original dock.nix (empty, but structure is there):
      persistentOthers = [];

      # Other dock settings from `system.defaults.dock` in original configuration
      # These are now part of `services.dock` in nix-darwin
      # "dashboard-in-overlay" = false; # Dashboard is deprecated
      "mru-spaces" = false; # Don't automatically rearrange Spaces
      # "show-process-indicators" = true; # Covered by showindicators
      # "static-only" = false; # Allow non-apps in dock (folders, etc.)
      # "launchanim" = true; # Launch animation for apps
      # "expose-group-by-app" = true; # Group windows by app in Mission Control
      # "scroll-to-open" = true; # Scroll on Dock icon to open Exposé/Cycle windows
      # "minimize-to-application" = true; # Minimize windows into their app icon
    };

    # Additional system.defaults for the Dock if not covered by system.dock options
    # These were in the original darwin/dock.nix system.defaults.dock section
    system.defaults.dock = {
      dashboard-in-overlay = false; # Though dashboard is gone, setting might exist
      mru-spaces = false;
      show-process-indicators = true; # Redundant with system.dock.showindicators, but harmless
      # static-only = false; # Not directly in system.dock, might be useful
      launchanim = true;
      expose-group-by-app = true;
      scroll-to-open = true;
      minimize-to-application = true;
    };
  };
}
