{
  config,
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  nixpkgs.overlays = [
  ];

  home = rec {
    username = "aloys";
    homeDirectory =
      if isLinux
      then "/home/${username}/"
      else "/Users/${username}/";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  imports = [
    ./symlinks.nix # import non nix assets, such as lua config
    ./nvim.nix # neovim pkgs
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
      git
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
      asdf-vm # asdf version manage
      zig # replace cclang
      entr # run command on change/watch
      neofetch # system info
      delta # better git diff
      caddy # proxy (better ngingx)
      corepack # yarn/npm/pnpm
      go
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      colima # better docker daemon
      # work SH
      mkcert
      awscli2
      ffmpeg
      resvg
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # hyprland related pkgs
      hyprpaper
      rofi-wayland
      waybar
      # others
      brightnessctl # control brighness
      kitty
    ]
    ++ import ./lsp.nix {inherit pkgs;};

  services =
    {}
    // lib.optionalAttrs isLinux
    {
      hyprpaper = {
        enable = false;
        settings = {
          preload = ["${config.home.homeDirectory}/.config/wallpapers/nord_wave.png"];
          wallpaper = ["${config.home.homeDirectory}/.config/wallpapers/nord_wave.png"];
        };
      };
      podman = {
        enable = true;
      };
    };

  programs =
    {
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        enable = true;
        shellAliases = {
          hms = "home-manager switch --flake $HOME/.config/nix/#darwin";
          gg = "lazygit";
          v = "nvim";
          yy = "yazi";
          fk = "fuck";
          p = "pnpm";
          hypr = "Hyprland -c /home/aloys/.config/hyprland/hyprland.conf";
        };
        initExtra = ''
          . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
          autoload -Uz bashcompinit && bashcompinit
          . "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"
          eval $(thefuck --alias)
          PATH=$PATH:${config.home.homeDirectory}/.config/scripts
        '';
        sessionVariables = {
          VISUAL = "nvim";
          EDITOR = "nvim";
          HM = "${config.home.homeDirectory}/.config/nix/home-manager/";
          DOTFILES = "${config.home.homeDirectory}/.config/nix/dotfiles/"; # Where I keep the source link of my dotfiles not managed within HM
          DOCKER_HOST = "unix:///var/run/docker.sock"; # this is to be able to run docker rootless
          ASDF_DATA_DIR = "${config.home.homeDirectory}/.config/asdf";
          COREPACK_ENABLE_AUTO_PIN = 0; # Sh
          CONF = "$HOME/.config/";
          DY = "$HOME/dylan/"; # SH
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "aliases"
            "git"
            "docker"
            "docker-compose"
            "eza"
            "git-commit"
            "gh"
          ];
        };
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
        enable = true;
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
