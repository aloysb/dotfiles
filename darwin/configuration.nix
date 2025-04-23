{
  self,
  pkgs,
  ...
}: {
  imports = [
    ./dock.nix
    ./homebrew/homebrew.nix
  ];
  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  programs.ssh.extraConfig = ''
    #AcceptEnv WEZTERM_REMOTE_PANE
  '';
  services = {
    openssh = {
      enable = true;
    };
    aerospace = {
      enable = true;
      settings = {
        # 'startAtLogin' must be true for 'afterLoginCommand' to work
        after-login-command = [];
        # 'afterStartupCommand' runs after 'afterLoginCommand'
        after-startup-command = [
        ];

        # Commands executed when the workspace changes
        exec-on-workspace-change = [];

        # Normalizations (see Aerospace guide)
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        # Layout settings
        accordion-padding = 60;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        # Key mapping preset
        key-mapping = {
          preset = "qwerty";
        };

        # Gaps configuration
        gaps = {
          inner = {
            horizontal = 8;
            vertical = 8;
          };
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
        };

        # Execution environment settings
        exec = {
          inherit-env-vars = true;
        };

        # Binding modes configuration
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

              # We use keypads on the temper
              "ctrl-shift-alt-1" = "workspace 1";
              "ctrl-shift-alt-2" = "workspace 2";
              "ctrl-shift-alt-3" = "workspace 3";
              "ctrl-shift-alt-4" = "workspace 4";
              "ctrl-shift-alt-5" = "workspace 5";
              "ctrl-shift-alt-6" = "workspace 6";
              "ctrl-shift-alt-7" = "workspace 7";
              "ctrl-shift-alt-8" = "workspace 8";
              "ctrl-shift-alt-9" = "workspace 9";

              # We use keypads on the temper
              "ctrl-shift-alt-h" = "workspace 1";
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

              "cmd-h" = []; # Disable "hide application"
              "cmd-alt-h" = []; # Disable "hide others"
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
              "1" = "move-node-to-workspace 1";
              "2" = "move-node-to-workspace 2";
              "3" = "move-node-to-workspace 3";
              "4" = "move-node-to-workspace 4";
              "5" = "move-node-to-workspace 5";
              "6" = "move-node-to-workspace 6";
              "7" = "move-node-to-workspace 7";
              "8" = "move-node-to-workspace 8";
              "9" = "move-node-to-workspace 9";
            };
          };

          resize = {
            binding = {
              h = "resize width -50";
              j = "resize height +50";
              k = "resize height -50";
              l = "resize width +50";
              enter = "mode main";
              esc = "mode main";
            };
          };
        };

        # On-window-detected rules

        on-window-detected = [
          {
            "if" = {"app-id" = "com.github.wez.wezterm";};
            run = ["layout tiling" "move-node-to-workspace 1"];
          }
          {
            "if" = {"app-id" = "com.apple.Safari";};
            run = ["layout tiling" "move-node-to-workspace 2"];
          }
          {
            "if" = {"app-id" = "com.google.Chrome";};
            run = ["layout tiling" "move-node-to-workspace 2"];
          }
          {
            "if" = {"app-id" = "com.google.Chrome.dev";};
            run = ["layout tiling" "move-node-to-workspace 2"];
          }
          {
            "if" = {"app-id" = "com.linear";};
            run = ["layout tiling" "move-node-to-workspace 5"];
          }
          {
            "if" = {"app-id" = "com.apple.finder";};
            run = ["layout floating"];
          }
          {
            "if" = {"app-id" = "com.apple.iCal";};
            run = ["layout floating"];
          }
          {
            "if" = {"app-id" = "design.yugen.Flow";};
            run = ["layout floating"];
          }
          # Catchall: send unmatched windows to workspace 9
          {
            run = ["layout tiling" "move-node-to-workspace 9"];
          }
        ];
      };
    };
    jankyborders = {
      enable = false;
      active_color = "0xff81A1C1";
      inactive_color = "0xff4C566A";
      width = 5.0;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nix = {
    settings = {
      trusted-users = [
        "root"
        "aloys"
      ];
    };
    extraOptions = ''
      auto-optimise-store = true
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  # Declare the user that will be running `nix-darwin`
  users.users.aloys = {
    name = "$USER";
    home = "/Users/$USER";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false; #using karabiners intead

  system.startup.chime = false;

  system.defaults = {
    finder = {
      QuitMenuItem = true;
      FXRemoveOldTrashItems = true;
    };
    NSGlobalDomain."com.apple.swipescrolldirection" = false; #non-natural scrolling
  };

  nix = {
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
  ];

  # options = {
  #   virtualisation = {
  #     docker = {
  #       enable = true;
  #       rootless = {
  #         enable = true;
  #       };
  #     };
  #   };
  # };
}
