{
  config,
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  installOpencode = lib.mkForce ''
    #    if ! command -v opencode >/dev/null 2>&1; then
          #echo "⏳ Installing opencode…"
          #curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/refs/heads/main/install | bash
          #export PATH=/Users/aloys/.opencode/bin:$PATH
    #    fi
  '';
in {
  nixpkgs.config.allowUnfree = true;
  # Apply the overlay to nixpkgs
  nixpkgs.overlays = [
    (import ../overlays/aider-overlay.nix)
    # Fix for tree-sitter-bundled-vendor hash mismatch
    (final: prev: {
      tree-sitter-bundled-vendor = prev.tree-sitter-bundled-vendor.overrideAttrs (oldAttrs: {
        outputHash = "sha256-ie+/48dVU3r+tx/sQBWRIZEWSNWwMBANCqQLnv96JXs=";
      });
    })
  ];

  home = rec {
    username = "aloys";
    homeDirectory =
      if isLinux
      then "/home/${username}/"
      else "/Users/${username}/";
    sessionPath =
      [
        "${config.home.homeDirectory}/.config/scripts"
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
    enable = false;
    package = pkgs.hyprland;
    xwayland.enable = false;
    settings = {
      "$mod" = "SUPER";
    };
    extraConfig = builtins.readFile ../dotfiles/hypr/hyprland.conf;
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
      aider-chat
      ffmpeg
      devenv
      hurl
      uv
      ollama
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
          hypr = "Hyprland -c /home/aloys/.config/hyprland/hyprland.conf";
          aid = "aider -c ~/.aider.config.yml";
          aidcp = "aider -c ~/.aider.config.yml --copy-paste";
          paid = "aider -c ~/.aider.perso.config.yml";
          paidcp = "aider -c ~/.aider.perso.config.yml --copy-paste";
          doomd = "emacs --daemon=\"doom\" --init-directory ~/.config/nix/dotfiles/emacs/doom";
          d = "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'doom'";
          emacsd = "emacs --daemon=\"vanilla\" --init-directory ~/.config/nix/dotfiles/emacs/vanilla";
          e = "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'vanilla'";
        };
        initExtraFirst = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme'';
        initExtra = ''
                 export OPENROUTER_API_KEY=`pass show openrouter/api_key`
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
