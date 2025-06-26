{
  lib,
  config,
  specialArgs,
  ...
}: let
  dotfiles = specialArgs.dotfiles; # ./dotfiles  (flake root)
  scripts = specialArgs.userScripts; # ./scripts   (flake root)
  isDarwin = specialArgs.isDarwin;
  cfg = config.modules.programs.dotfiles;

  # helper: link one file/dir under $HOME
  link = target: source: {
    "${target}" = {source = "${dotfiles}/${source}";};
  };

  # helper: link an executable script under ~/.config/scripts
  linkScript = name: {
    ".config/scripts/${name}" = {
      source = "${scripts}/${name}";
      executable = true;
    };
  };
in {
  options.modules.programs.dotfiles.enable = lib.mkEnableOption "link my dotfiles";

  config = lib.mkIf cfg.enable {
    # makes sure ~/.config exists (harmless on every OS)
    #    home.xdg.enable = true;

    # all links collected in one attr-set
    home.file = lib.mkMerge [
      # -------- always ----------
      #(link ".config/doom" "emacs/doom")
      (link ".config/wezterm" "wezterm")
      (link ".config/lazygit/config.yml" "lazygit/config.yml")
      (link ".config/nvim" "nvim")
      #(link ".config/wallpapers" "wallpapers")
      #(link ".aider.config.yml" "aider/.aider.config.yml")
      #(link ".aider.perso.config.yml" "aider/.aider.perso.config.yml")

      # -------- macOS only -------
      (lib.mkIf isDarwin (link ".config/aerospace/aerospace.toml"
          "aerospace/aerospace.toml"))

      # -------- Linux only -------
      # (linuxOnly {
      #   ".config/hypr/hyprland.conf" = {source = "${dotfiles}/hypr/hyprland.conf";};
      #   ".config/hypr/hyprpaper.conf" = {source = "${dotfiles}/hypr/hyprpaper.conf";};
      #   ".config/rofi/config.rasi" = {source = "${dotfiles}/rofi/config.rasi";};
      #   ".config/rofi/nord.rasi" = {source = "${dotfiles}/rofi/nord.rasi";};
      #   ".config/waybar/config.jsonc" = {source = "${dotfiles}/waybar/config.jsonc";};
      #   ".config/waybar/style.css" = {source = "${dotfiles}/waybar/style.css";};
      # })

      # -------- scripts ----------
      # (linkScript "backup")
      # (linkScript "bundleid")
      # (linkScript "compress_gh")
      # (linkScript "psc")
      # (linkScript "sc")
      # (linkScript "tlscp-start")
    ];

    # guarantee the scripts directory exists before links are made
    home.activation.makeScriptsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.config/scripts"
    '';
  };
}
