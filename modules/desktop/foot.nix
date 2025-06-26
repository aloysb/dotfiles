{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.foot;
in
{
  options.modules.desktop.foot = lib.mkEnableOption "Foot terminal emulator (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      programs.foot = {
        enable = true;
        # package = pkgs.foot; # Default is fine
        # settings = {
        #   main = {
        #     term = "xterm-256color";
        #     font = "JetBrainsMono Nerd Font Mono:size=10";
        #     # font-bold = "...";
        #     # font-italic = "...";
        #     # font-bold-italic = "...";
        #     # line-height = "1.0";
        #     # letter-spacing = "0";
        #     # horizontal-letter-offset = "0";
        #     # vertical-letter-offset = "0";
        #     # underline-offset = "auto";
        #     # box-drawings-uses-font-glyphs = "no";
        #     # dpi-aware = "yes"; # auto, yes, no
        #     # initial-window-size-pixels = "700x500"; # Or chars
        #     # initial-window-size-chars = "80x24";
        #     # initial-window-mode = "windowed"; # "fullscreen", "maximized"
        #     pad = "2x2"; # "RxC" in pixels, or "RxC%"
        #     # resize-delay-ms = 100;
        #     # notify = "notify-send -a foot -i foot ${title} ${body}";
        #     # selection-target = "primary"; # "clipboard", "both"
        #     # workers = 4; # Number of threads used for rendering
        #   };
        #   scrollback = {
        #     lines = 10000;
        #     # multiplier = "3.0";
        #     # indicator-position = "relative"; # "fixed", "none"
        #     # indicator-format = ""; # "percentage", "absolute"
        #   };
        #   url = {
        #     # launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
        #     # label-letters = "sadfjklewcmpgh";
        #     # osc8-underline = "url-mode"; # "always", "never"
        #     # protocols = "http, https, ftp, ftps, file, gemini, gopher";
        #     # uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]";
        #   };
        #   cursor = {
        #     # style = "block"; # "beam", "underline"
        #     # color = "inverse-foreground inverse-background";
        #     # blink = "no";
        #     # beam-thickness = "1.5";
        #     # underline-thickness = "font";
        #   };
        #   mouse = {
        #     # hide-when-typing = "no";
        #     # alternate-scroll-mode = "yes";
        #   };
        #   colors = {
        #     # alpha = "1.0"; # Background opacity
        #     # foreground = "d8dee9"; # Nord Snow Storm
        #     # background = "2e3440"; # Nord Polar Night
        #     # regular0 = "3b4252";  # nord3 - Black
        #     # regular1 = "bf616a";  # nord11 - Red
        #     # regular2 = "a3be8c";  # nord14 - Green
        #     # regular3 = "ebcb8b";  # nord13 - Yellow
        #     # regular4 = "81a1c1";  # nord9 - Blue
        #     # regular5 = "b48ead";  # nord15 - Magenta
        #     # regular6 = "88c0d0";  # nord8 - Cyan
        #     # regular7 = "e5e9f0";  # nord4 - White
        #     # bright0 = "4c566a";   # nord3 (brighter) - Bright Black
        #     # bright1 = "bf616a";   # nord11 - Bright Red
        #     # bright2 = "a3be8c";   # nord14 - Bright Green
        #     # bright3 = "ebcb8b";   # nord13 - Bright Yellow
        #     # bright4 = "81a1c1";   # nord9 - Bright Blue
        #     # bright5 = "b48ead";   # nord15 - Bright Magenta
        #     # bright6 = "8fbcbb";   # nord7 - Bright Cyan (using nord7 as nord8 is already light)
        #     # bright7 = "eceff4";   # nord6 - Bright White
        #     ## selection-foreground and selection-background are unset by default,
        #     ## using regular foreground/background but inverted.
        #     # selection-foreground = "2E3440";
        #     # selection-background = "ECEFF4";
        #   };
        #   # csd = {}; # Client-side decorations, if foot is compiled with it
        #   # key-bindings = {}; # Custom keybindings
        #   # search-bindings = {};
        #   # url-bindings = {};
        #   # text-bindings = {}; # Bindings for text manipulation mode
        #   # scrollback-bindings = {};
        #   # mouse-bindings = {};
        #   # bell = {};
        #   # Tweak settings for specific applications
        #   # "tweak" = {
        #   #   "max-shm-pool-size-mb" = 512;
        #   # };
        # };
        # This assumes foot.ini is symlinked by the dotfiles module if detailed config is there.
      };
    };
  };
}
