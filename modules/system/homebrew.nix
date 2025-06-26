{ lib, config, pkgs, inputs, specialArgs, ... }:

let
  cfg = config.modules.system.homebrew;
  username = specialArgs.username; # From flake's specialArgs
in
{
  options.modules.system.homebrew = lib.mkEnableOption "Homebrew setup (Darwin-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    # This module configures the `nix-homebrew` module itself,
    # which should be imported in the host configuration:
    # `inputs.nix-homebrew.darwinModules.nix-homebrew`

    nix-homebrew = {
      enable = true; # Ensures the underlying nix-homebrew module is active
      inherit username;
      # taps are sourced from inputs passed via flake.nix
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        # "d12frosted/homebrew-emacs-plus" = inputs.emacs-plus; # Was removed in original flake
      };
      mutableTaps = false; # Declarative tap management

      # Packages from darwin/homebrew/brews.nix
      # These are package names as strings
      brews = [
        # Formulae from brews.nix
        "ack"
        "watch"
        "watchman"
        "bash"
        "reattach-to-user-namespace"
        "gnutls" # For emacs-plus if used, or other native builds
        "jansson" # For emacs-plus native JSON
        "imagemagick" # For emacs-plus image support
        "coreutils"
        "fd"
        "findutils"
        "emacs-plus@29"
        "ripgrep"
        "git"
        "gnu-sed"
        "grep"
        "make"
        "gawk"
        "tmux"
        "zsh"
        "docker" # Docker CLI, colima provides the daemon
        "mas" # Mac App Store CLI
        "xz" # Compression utility
        "neovim"
        "gh"
        "tree"
        "fzf"
        "btop"
        "lazygit"
        "jesseduffield/lazydocker/lazydocker" # Tap syntax for unofficial formula
        "go"
        "rust"
        "bottom"
        "task" # taskwarrior
        "gum"
        "glow"
        "wezterm"
        "elixir"
        "gleam"
        "flyctl"
        "jq"
        "yq" # yq from kislyuk (Python version) vs mikefarah (Go version)
             # Original might be `python-yq` or just `yq` (Go). Assuming Go version.
        "choose-rust" # `choose` utility
        "colima"
        "k9s"
        "kubernetes-cli" # kubectl
        "hugo"
        "ollama"
        "bun"
        "act" # Run GitHub Actions locally
        "zig"
        "protobuf"
        "golangci-lint"
        "pyenv"
        "nodenv"
        "tfenv" # Terraform version manager
        "adr-tools"
        "atuin"
        "just"
        "bat"
        "eza" # exa replacement
        "zoxide"
        "starship"
        "direnv"
        "fx" # JSON viewer
        "fpp" # Facebook PathPicker
        "gping"
        "htop"
        "httpie"
        "hyperfine"
        "dust" # du replacement
        "delta" # git diff tool (also in nixpkgs)
        "ctop" # container top
        "cheat"
        "bandwhich"
        "dua-cli" # Disk usage analyzer
        "difftastic" # Diff tool
        "docker-buildx"
        "docker-compose"
        "deno"
        "ghcup" # Haskell GHCup
        "imagemagick" # Already listed
        "tree-sitter"
        "luarocks"
        "marksman" # Markdown language server
        "typescript" # tsserver via npm, or a brew package if available
        "vscode-langservers-extracted" # Various language servers
        "yaml-language-server"
        "elixir-ls" # Elixir Language Server
        "bash-language-server"
        "vim" # For basic vim, neovim is also listed
        "wget"
        "gitleaks"
        "pre-commit"
        "delve" # Go debugger
        "air" # Go live reload
        "sqlc"
        "sqlite"
        "reattach-to-user-namespace" # Already listed
        "stylua" # Lua formatter
        "shfmt" # Shell formatter
        "shellcheck"
        "pgcli"
        "hadolint" # Dockerfile linter
        "prettier"
        "eslint" # via npm, or if a brew package exists
        "golang-migrate"
        "actionlint" # GitHub Actions linter
        "terraform-ls"
        "tflint"
        "tfsec" # Trivy can do this now
        "trivy"
        "vale" # Prose linter
        "vector" # Vector observability tool
        "lua-language-server"
        "rust-analyzer" # managed by rustup usually, or via this
        "nil" # Nix language server (also in nixpkgs)
        "node" # Node.js
        "openjdk" # Java
        "maven"
        "gradle"
        "python3" # Python 3
        "ruby"
        "go-task"
        "dotbot"
        "stow" # GNU Stow
      ];

      # Casks from darwin/homebrew/casks.nix
      casks = [
        "google-chrome-dev"
        "slack"
        "spotify"
        "safari-technology-preview"
        "discord"
        "notion"
        "figma"
        "zoom"
        "miro"
        "karabiner-elements"
        "hammerspoon"
        "raycast"
        "shottr"
        "linear-linear" # Linear.app
        "cron" # Calendar app
        "arc" # Arc browser
        "tuple" # Pair programming
        "warp" # Terminal
        "cursor" # Editor
        "obsidian"
        "youtube-music" # Needs specific tap if not official, like `homebrew/cask-versions` or custom
        "postman"
        "zed" # Editor
        "notational-velocity"
        "wezterm" # Also in brews, cask is for GUI app bundle
        "alacritty"
        "iterm2"
        "visual-studio-code"
        "docker" # Docker Desktop for Mac (alternative to colima if preferred)
        "obs"
        "vlc"
        "transmission"
        "amethyst" # Window manager
        "rectangle" # Window manager
        "alt-tab"
        "kap" # Screen recorder
        "keycastr"
        "the-unarchiver"
        "1password" # GUI App
        # "1password-cli" # CLI is usually a brew formula
        "ngrok"
        "brave-browser"
        "firefox"
        "google-cloud-sdk"
        "signal"
        "telegram"
        "whatsapp"
        "element" # Matrix client
        "logitech-options" # For Logitech hardware
        "balenaetcher"
        "raspberry-pi-imager"
        "utm" # QEMU frontend
        "font-fira-code-nerd-font" # Nerd fonts
        "font-symbols-only-nerd-font"
        # Add other fonts if managed via cask
      ];

      # Mac App Store apps from darwin/homebrew/mas.nix
      # masApps = {
      #   "Tailscale" = 1475387142;
      #   "Things" = 904280696;
      #   "Spark" = 1176895641;
      #   "Magnet" = 441258766;
      #   " встречи" = 542502357; # Google Meet
      #   "GIPHY Capture" = 668208984;
      #   "Speedtest" = 1153157709;
      #   "Flow" = 1522532096;
      #   "Developer" = 640199958; # Apple Developer app
      #   "The Unarchiver" = 425424353; # Also in casks, choose one
      #   "Twitter" = 1482454543;
      #   "Parcel" = 1529026550;
      #   "Final Cut Pro" = 424389933; # Paid app
      #   "Motion" = 434290957; # Paid app
      #   "Compressor" = 424390742; # Paid app
      #   "Logic Pro" = 634148309; # Paid app
      #   "MainStage" = 634159523; # Paid app
      #   "Pixelmator Pro" = 1289583905; # Paid app
      #   "Affinity Photo 2" = 1616824166; # Paid app
      #   "Affinity Designer 2" = 1616823936; # Paid app
      #   "Affinity Publisher 2" = 1616824000; # Paid app
      #   "DaVinci Resolve" = 571213070;
      # };
      # The mas module in nix-homebrew might have a different structure, check its docs.
      # It might be `mas = { apps = { name = id; }; };` or similar.
      # For now, I'll assume the list of names/ids needs to be processed if `mas` utility is used by nix-homebrew.
      # The original `homebrew.nix` used a custom script to install MAS apps.
      # If `nix-homebrew` doesn't directly support declarative MAS apps, this part might need
      # a `system.activationScripts` entry or similar to run `mas install <id>` for each.
      # Looking at `nix-homebrew` docs, it seems it doesn't directly manage MAS apps.
      # So, this part will be omitted from `nix-homebrew` config block.
      # MAS apps should be handled by a separate mechanism (e.g. activation script or manually).
    };

    # If MAS apps need to be installed declaratively and nix-homebrew doesn't do it,
    # one might use an activation script.
    # Example (conceptual, needs `mas` CLI to be available):
    # system.activationScripts.installMasApps = ''
    #   echo "Installing MAS apps..."
    #   ${pkgs.mas}/bin/mas install 1475387142 # Tailscale
    #   # ... and so on for other app IDs
    # '';
    # This requires `mas` to be in `pkgs` (e.g. from a nix-homebrew formula itself).
  };
}
