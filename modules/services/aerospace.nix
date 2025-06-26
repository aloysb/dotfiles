{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.services.aerospace;
  dotfilesDir = specialArgs.dotfiles; # To potentially load config from dotfiles if not hardcoded
in
{
  options.modules.services.aerospace = lib.mkEnableOption "Aerospace window manager (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    services.aerospace = {
      enable = true;
      # The settings were extensive in the original darwin/configuration.nix.
      # These can be directly translated here.
      # Alternatively, if aerospace.toml is preferred, this module could symlink it
      # from dotfilesDir/aerospace/aerospace.toml using home.file or similar.
      # For now, translating the direct Nix configuration:
      settings = {
        after-login-command = [];
        after-startup-command = [];
        exec-on-workspace-change = [];
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = 60;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        key-mapping.preset = "qwerty";
        gaps = {
          inner = { horizontal = 0; vertical = 0; };
          outer = { left = 0; bottom = 0; top = 0; right = 0; };
        };
        exec.inherit-env-vars = true;
        mode = {
          main = {
            binding = {
              "alt-ctrl-shift-v" = "layout tiles horizontal vertical";
              "alt-ctrl-shift-d" = "layout accordion horizontal vertical";
              "alt-h" = "focus left";
              "alt-j" = "focus down";
              "alt-k" = "focus up";
              "alt-l" = "focus right";
              "alt-shift-h" = "move left";
              "alt-shift-j" = "move down";
              "alt-shift-k" = "move up";
              "alt-shift-l" = "move right";
              "ctrl-alt-shift-minus" = "resize smart -200";
              "ctrl-alt-shift-equal" = "resize smart +200";
              "ctrl-shift-alt-1" = "workspace 1";
              "ctrl-shift-alt-2" = "workspace 2";
              "ctrl-shift-alt-3" = "workspace 3";
              "ctrl-shift-alt-4" = "workspace 4";
              "ctrl-shift-alt-5" = "workspace 5";
              "ctrl-shift-alt-6" = "workspace 6";
              "ctrl-shift-alt-7" = "workspace 7";
              "ctrl-shift-alt-8" = "workspace 8";
              "ctrl-shift-alt-9" = "workspace 9";
              "ctrl-shift-alt-h" = "workspace 1"; # Temper keypads
              "ctrl-shift-alt-comma" = "workspace 2";
              "ctrl-shift-alt-period" = "workspace 3";
              "ctrl-shift-alt-n" = "workspace 4";
              "ctrl-shift-alt-e" = "workspace 5";
              "ctrl-shift-alt-i" = "workspace 6";
              "ctrl-shift-alt-l" = "workspace 7";
              "ctrl-shift-alt-u" = "workspace 8";
              "ctrl-shift-alt-y" = "workspace 9";
              "ctrl-shift-alt-keypad1" = "move-node-to-workspace 1";
              "ctrl-shift-alt-keypad2" = "move-node-to-workspace 2";
              "ctrl-shift-alt-keypad3" = "move-node-to-workspace 3";
              "ctrl-shift-alt-keypad4" = "move-node-to-workspace 4";
              "ctrl-shift-alt-keypad5" = "move-node-to-workspace 5";
              "ctrl-shift-alt-keypad6" = "move-node-to-workspace 6";
              "ctrl-shift-alt-keypad7" = "move-node-to-workspace 7";
              "ctrl-shift-alt-keypad8" = "move-node-to-workspace 8";
              "ctrl-shift-alt-keypad9" = "move-node-to-workspace 9";
              "shift-ctrl-alt-g" = "workspace-back-and-forth";
              "shift-ctrl-alt-f" = "fullscreen";
              "shift-ctrl-alt-q" = "enable toggle";
              "shift-ctrl-alt-b" = "balance-sizes";
              "shift-ctrl-alt-r" = "mode resize";
              "shift-ctrl-alt-x" = "mode quit";
              "shift-ctrl-alt-0" = "mode sendToWorkspace";
              "cmd-h" = [];
              "cmd-alt-h" = [];
            };
          };
          quit = {
            binding = {
              "shift-ctrl-alt-x" = "close-all-windows-but-current";
              enter = "mode main";
              esc = "mode main";
            };
          };
          sendToWorkspace = {
            binding = {
              enter = "mode main";
              esc = "mode main";
              "1" = "move-node-to-workspace 1"; "2" = "move-node-to-workspace 2"; "3" = "move-node-to-workspace 3";
              "4" = "move-node-to-workspace 4"; "5" = "move-node-to-workspace 5"; "6" = "move-node-to-workspace 6";
              "7" = "move-node-to-workspace 7"; "8" = "move-node-to-workspace 8"; "9" = "move-node-to-workspace 9";
            };
          };
          resize = {
            binding = {
              h = "resize width -50"; j = "resize height +50";
              k = "resize height -50"; l = "resize width +50";
              enter = "mode main"; esc = "mode main";
            };
          };
        };
        on-window-detected = [
          { "if" = {"app-id" = "com.github.wez.wezterm";}; run = ["layout tiling" "move-node-to-workspace 1"]; }
          { "if" = {"app-id" = "com.apple.Safari";}; run = ["layout tiling" "move-node-to-workspace 2"]; }
          { "if" = {"app-id" = "com.google.Chrome";}; run = ["layout tiling" "move-node-to-workspace 2"]; }
          { "if" = {"app-id" = "com.google.Chrome.dev";}; run = ["layout tiling" "move-node-to-workspace 2"]; }
          { "if" = {"app-id" = "com.linear";}; run = ["layout tiling" "move-node-to-workspace 5"]; }
          { "if" = {"app-id" = "com.apple.finder";}; run = ["layout floating"]; }
          { "if" = {"app-id" = "com.apple.iCal";}; run = ["layout floating"]; }
          { "if" = {"app-id" = "design.yugen.Flow";}; run = ["layout floating"]; }
          { run = ["layout tiling" "move-node-to-workspace 9"]; } # Catchall
        ];
      };
    };

    # Jankyborders - was in original darwin/configuration.nix under services
    # Assuming it's related to Aerospace or general window management on Darwin
    services.jankyborders = {
      enable = false; # As per original config
      active_color = "0xff81A1C1";
      inactive_color = "0xff4C566A";
      width = 5.0;
    };

    # If aerospace.toml is preferred, the dotfiles module should symlink:
    # home.file.".config/aerospace/aerospace.toml".source = "${dotfilesDir}/aerospace/aerospace.toml";
    # And the above `services.aerospace.settings` would be removed or reduced.
    # The `dotfiles` module already has an entry for this.
  };
}
