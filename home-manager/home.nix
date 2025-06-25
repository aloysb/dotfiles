{
  config,
  pkgs,
  lib,
  username, # Injected from extraSpecialArgs
  home-directory, # Injected from extraSpecialArgs
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  installOpencode = lib.mkForce ''
    #    if ! command -v opencode >/dev/null 2>&1; then
          #echo "⏳ Installing opencode…"
          #curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/refs/heads/main/install | bash
          #export PATH=${home-directory}/.opencode/bin:$PATH # Replaced hardcoded path
    #    fi
  '';
in {
  # sops-nix specific configuration for Home Manager
  sops.defaultSopsFile = ../secrets.yaml; # Path relative to this file to flake root's secrets.yaml
  sops.secrets.OPENROUTER_API_KEY = { # This will expose OPENROUTER_API_KEY directly if sops can do that
                                     # or create a file that sets it, to be sourced.
    # Assumes 'openrouter_api_key' (lowercase) is the key in secrets.yaml
    # If not, specify: key = "openrouter_api_key";
  };
  # sops.secrets.openrouter_api_key_env = { # Old approach
    # This will make the decrypted content of 'openrouter_api_key' from secrets.yaml
    # available as an environment variable OPENROUTER_API_KEY_ENV (if not using .sh extension)
    # or in a file that can be sourced.
    # For direct env var, we'd typically use 'programs.zsh.sessionVariables'
    # or a .sopsignore file to let sops manage it directly via a generated script.
    # Let's try to make it available as an environment variable directly.
    # If direct env var injection isn't straightforward, will use a file to source.
  };
  # To make it an environment variable that Zsh can use:
  # 1. Define the secret for sops-nix
  # 2. In zsh.initExtra (or similar), source the file sops provides, or use the variable if set by sops.

  nixpkgs.config.allowUnfree = true; # This is fine, can be set at module level too.
                                     # Flake-level pkgs already has allowUnfree = true.
  # nixpkgs.overlays are now managed in flake.nix

  home = rec {
    inherit username homeDirectory; # Use injected values
    sessionPath =
      [
        "${home-directory}/.config/scripts" # Use injected home-directory
        "${config.home.homeDirectory}/.opencode/bin"
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "/Applications/Docker.app/Contents/Resources/bin/"
      ];
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.11"; # Please read the comment before changing.
    # activation = {
    #   installOpenCode = installOpencode;
    # };
  };

  imports = [
    ./symlinks.nix # import non nix assets, such as lua config
  ];

  wayland.windowManager.hyprland = {
    enable = false; # This is for the HM module, but user starts it via config.
    package = pkgs.hyprland; # Matched with hyprland input in flake? No, this is fine.
    xwayland.enable = false;
    settings = {
      "$mod" = "SUPER";
    };
    # Process hyprland.conf to substitute paths if necessary, though it doesn't seem to have any.
    # For consistency and future-proofing, we can do it.
    # However, the main issue is hyprpaper.conf, which is called by hyprland.conf
    extraConfig = pkgs.substituteAll {
      src = ../dotfiles/hypr/hyprland.conf;
      home = home-directory; # or config.home.homeDirectory
    };
  };

  # Ensure hyprpaper.conf is correctly placed and substituted
  home.file."${config.xdg.configHome}/hypr/hyprpaper.conf" = {
    text = pkgs.substituteAll {
      src = ../dotfiles/hypr/hyprpaper.conf; # This is the templatized one
      HOME = home-directory; # Using HOME to match @HOME@
    };
    # Only create this if hyprland is likely to be used (isLinux)
    # This condition might need refinement based on how hyprland is enabled/used.
    # For now, assume if hyprland config is being managed, this is needed.
    # enable = isLinux; # This would require isLinux to be in scope or passed.
  };

  home.packages = with pkgs;
    [
      curl
      gh
      wezterm
      ripgrep # better grep
      just # better make
      fd # better find
      jq # json utils
      tree # display file tree
      lazygit # git TUI
      lazydocker # docker tui
      zig # replace cclang
      entr # run command on change/watch
      neofetch # system info
      delta # better git diff
      caddy # proxy (better ngingx)
      corepack # yarn/npm/pnpm
      go
      delve
      ffmpeg
      devenv
      hurl
      uv
      pre-commit
      thunderbird
      docker
      docker-compose
      postgresql
      pm2
      glow
      nodejs_20
      btop
      wireguard-tools
      go-task
      # ai
      claude-code
      repomix
      ollama
      aider-chat
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      colima # better docker daemon
      _1password-cli
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # hyprland related pkgs
      hyprpaper
      rofi-wayland
      wl-clipboard
      waybar
      # others
      brightnessctl # control brighness
      font-awesome
      impala # network TUI
      bluez
    ];

  services =
    {}
    // lib.optionalAttrs isLinux
    {
      cliphist = {
        enable = true;
        allowImages = true;
      };
      hyprpaper = {
        enable = false;
        settings = {
          preload = ["${config.home.homeDirectory}/.config/wallpapers/starry-sky-night-with-landscape-mountains.jpg"];
          wallpaper = ["${config.home.homeDirectory}/.config/wallpapers/starry-sky-night-with-landscape-mountains.jpg"];
        };
      };
      podman = {
        enable = true;
      };
    };

  programs =
    {
      git = {
        enable = true;
        userName = "aloysb";
        userEmail = "aloysberger@gmail.com";
        aliases = {
          oops = "commit --amend --no-edit";
        };
        delta = {
          enable = true;
          #options = {
          #  dark = true;
          #  plus-style = false;
          #  minus-style = false;
          #  light = false;
          #};
        };
        extraConfig = {
          pull.rebase = true;
          push.default = "upstream";
          core = {
            editor = "nvim";
            whitespace = "trailing-space,space-before-tab";
          };
          rebase = {
            autostash = true;
          };
          user.signingkey = "501A50921536CA05";
          commit.gpgSign = true;
          diff = {
            algorithm = "histogram";
          };
          rerere = {
            enabled = true;
          };
          log = {
            abbrevCommit = true;
            date = "iso"; # ← show ISO dates by default
          };
          url = {
            "git@github.com:" = {
              insteadOf = "gh:";
            };
          };
        };
      };
      password-store = {
        enable = true;
      };
      zsh = {
        enable = true;
        shellAliases = {
          hms = "pushd ~/.config/nix > /dev/null && just hms && popd > /dev/null";
          nixsw = "pushd ~/.config/nix > /dev/null && just nix-switch && popd > /dev/null";
          nvimsw = "pushd ~/.config/nix > /dev/null && just nvim-reload && popd > /dev/null";
          gg = "lazygit";
          yy = "yazi";
          fk = "fuck";
          p = "pnpm";
          hypr = "Hyprland -c ${config.home.homeDirectory}/.config/hyprland/hyprland.conf"; # Used config.home.homeDirectory
          aid = "aider -c ~/.aider.config.yml";
          aidcp = "aider -c ~/.aider.config.yml --copy-paste";
          paid = "aider -c ~/.aider.perso.config.yml";
          paidcp = "aider -c ~/.aider.perso.config.yml --copy-paste";
          doomd = "emacs --daemon=\"doom\" --init-directory ~/.config/nix/dotfiles/emacs/doom";
          d = "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'doom'";
          dl = "emacs --init-dir $XDG_CONFIG_HOME/nix/dotfiles/emacs/doom";
          emacsd = "emacs --daemon=\"vanilla\" --init-directory ~/.config/nix/dotfiles/emacs/vanilla";
          e = "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'vanilla' -a \"emacs --init-dir $XDG_CONFIG_HOME/nix/dotfiles/emacs/vanilla\"";
          el = "emacs --init-dir $XDG_CONFIG_HOME/nix/dotfiles/emacs/vanilla";
          t = "task";
        };
        initExtraFirst = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme'';
        initExtra = ''
                 # export OPENROUTER_API_KEY=`pass show openrouter/api_key` # Managed by sops-nix now
                 # If OPENROUTER_API_KEY is not available, you might need to source sops secrets:
                 # source "${config.sops.secretsFile}" # Or specific path provided by sops-nix HM module
                 export OLLAMA_API_BASE=http://127.0.0.1:11434
          source ~/.p10k.zsh
        '';
        sessionVariables = {
          VISUAL = "nvim";
          EDITOR = "nvim";
          HM = "${config.home.homeDirectory}/.config/nix/home-manager/";
          DOTFILES = "${config.home.homeDirectory}/.config/nix/dotfiles/"; # Where I keep the source link of my dotfiles not managed within HM
          DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
          COREPACK_ENABLE_AUTO_PIN = 0; # Sh
          CONF = "$HOME/.config/";
          DY = "$HOME/dylan/"; # SH
          XDG_CONFIG_HOME = "$HOME/.config";
          DOOMDIR = "$HOME/.config/nix/dotfiles/emacs/doom";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "docker"
            "docker-compose"
          ];
        };
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      bat = {
        enable = true;
        extraPackages = [pkgs.bat-extras.batman pkgs.bat-extras.batgrep];
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      yazi = {
        enable = true;
        enableZshIntegration = true;
      };
      gpg = {
        enable = true;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        historyWidgetOptions = [
          "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
          "--color header:italic"
          "--header 'Press CTRL-Y to copy command into clipboard'"
        ];
        changeDirWidgetOptions = [
          "--walker-skip .git,node_modules,target"
          "--preview 'eza -T'"
        ];
      };
      thefuck = {
        # reenable after https://github.com/NixOS/nixpkgs/pull/390454 is merged
        enable = false;
        enableInstantMode = true;
        enableZshIntegration = true;
      };
      eza = {
        enable = true;
        enableZshIntegration = true;
      };
      home-manager = {
        enable = true;
        path = lib.mkForce "$HOME/.config/nix/home-manager";
      };
    }
    // lib.optionalAttrs isLinux
    {
      qutebrowser.enable = true;
      firefox.enable = true;
    };
}
