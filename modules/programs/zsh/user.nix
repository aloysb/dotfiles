{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.programs.zsh;
  homeDir = specialArgs.home-directory; # Use specialArgs for home-directory
  dotfilesDir = specialArgs.dotfiles; # Path to ./dotfiles from flake root
in {
  options.modules.programs.zsh.enable = lib.mkEnableOption "Zsh shell and configuration";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        hms = "pushd ${homeDir}/.config/nix > /dev/null && just hms && popd > /dev/null"; # Assuming just is installed
        nixsw = "pushd ${homeDir}/.config/nix > /dev/null && just nix-switch && popd > /dev/null";
        nvimsw = "pushd ${homeDir}/.config/nix > /dev/null && just nvim-reload && popd > /dev/null";
        gg = "lazygit"; # Assuming lazygit is installed
        yy = "yazi"; # Assuming yazi is installed
        fk = "fuck"; # Assuming thefuck is installed
        p = "pnpm"; # Assuming pnpm (via corepack) is available
        hypr = "Hyprland -c ${homeDir}/.config/hyprland/hyprland.conf"; # Path to hyprland config
        aid = "aider -c ~/.aider.config.yml";
        aidcp = "aider -c ~/.aider.config.yml --copy-paste";
        paid = "aider -c ~/.aider.perso.config.yml";
        paidcp = "aider -c ~/.aider.perso.config.yml --copy-paste";
        # Emacs aliases might need adjustment based on how Emacs is installed/configured
        doomd = "emacs --daemon=\"doom\" --init-directory ${dotfilesDir}/emacs/doom";
        d =
          if pkgs.stdenv.isDarwin
          then "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'doom'"
          else "emacsclient -c -n -q -s 'doom'";
        dl = "emacs --init-dir ${dotfilesDir}/emacs/doom";
        emacsd = "emacs --daemon=\"vanilla\" --init-directory ${dotfilesDir}/emacs/vanilla";
        e =
          if pkgs.stdenv.isDarwin
          then "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n -q -s 'vanilla' -a \"emacs --init-dir ${dotfilesDir}/emacs/vanilla\""
          else "emacsclient -c -n -q -s 'vanilla' -a \"emacs --init-dir ${dotfilesDir}/emacs/vanilla\"";
        el = "emacs --init-dir ${dotfilesDir}/emacs/vanilla";
        t = "task"; # Assuming taskwarrior is installed
      };
      initExtraFirst = ''
        # Powerlevel10k theme sourcing
        if [ -f "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" ]; then
          source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
        fi
      '';
      initExtra = ''
        # Secrets (e.g., OPENROUTER_API_KEY) should be handled by sops-nix module if enabled
        # export OPENROUTER_API_KEY=$(pass show openrouter/api_key) # Old way

        export OLLAMA_API_BASE=http://127.0.0.1:11434

        # Source Powerlevel10k configuration if it exists
        # Assuming .p10k.zsh is symlinked or managed by dotfiles module
        if [ -f "${homeDir}/.p10k.zsh" ]; then
          source "${homeDir}/.p10k.zsh"
        fi
      '';
      sessionVariables = {
        VISUAL = "nvim"; # Assuming nvim is preferred editor
        EDITOR = "nvim";
        HM = "${homeDir}/.config/nix/home-manager/"; # Path to HM config
        DOTFILES = "${homeDir}/.config/nix/dotfiles/"; # Path to non-HM dotfiles source
        # DOCKER_HOST specific to colima on Darwin, might need conditional logic
        # or to be set by a colima module if one exists.
        DOCKER_HOST = lib.mkIf pkgs.stdenv.isDarwin "unix://${homeDir}/.colima/default/docker.sock";
        COREPACK_ENABLE_AUTO_PIN = "0";
        CONF = "$HOME/.config/"; # Standard XDG
        DY = "$HOME/dylan/"; # User specific
        # XDG_CONFIG_HOME is automatically set by HM if not mistaken, but doesn't hurt
        XDG_CONFIG_HOME = "$HOME/.config";
        DOOMDIR = "${dotfilesDir}/emacs/doom"; # Path to doom emacs config
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "docker-compose"
        ];
        # theme = "powerlevel10k/powerlevel10k"; # p10k handles its own theme loading
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          # file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme"; # Not needed if sourced in initExtraFirst
        }
        # Add other zsh plugins here if needed, e.g., zsh-autosuggestions, zsh-syntax-highlighting
        # { name = "zsh-autosuggestions"; src = pkgs.zsh-autosuggestions; }
        # { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
      ];
    };

    # Ensure zsh is the default shell for the user on NixOS
    #users.defaultUserShell = lib.mkIf pkgs.stdenv.isLinux pkgs.zsh;

    # Ensure .p10k.zsh is symlinked if it's part of the dotfiles repo
    # This would typically be handled by the dotfiles module.
    # home.file.".p10k.zsh" = {
    #   source = ../../dotfiles/.p10k.zsh; # Adjust path as needed
    #   enable = true; # Or some condition
    # };
  };
}
