{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.dunst;
in
{
  options.modules.desktop.dunst = lib.mkEnableOption "Dunst notification daemon (Linux-specific)";

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      services.dunst = {
        enable = true;
        # package = pkgs.dunst; # Default is fine
        # settings = {
        #   global = {
        #     monitor = 0;
        #     follow = "mouse"; # "keyboard" or "none"
        #     geometry = "300x5-30+20"; # widthxheight-x+y
        #     indicate_hidden = "yes";
        #     shrink = "no";
        #     separator_height = 2;
        #     padding = 8;
        #     horizontal_padding = 8;
        #     frame_width = 3;
        #     frame_color = "#81A1C1"; # Example color (Nord Polar Night)
        #     separator_color = "frame";
        #     sort = "yes";
        #     font = "JetBrainsMono Nerd Font Mono 10";
        #     line_height = 0;
        #     markup = "full";
        #     format = "<b>%s</b>\\n%b";
        #     alignment = "left"; # "center", "right"
        #     show_age_threshold = 60; # seconds
        #     word_wrap = "yes";
        #     ellipsize = "middle"; # "start", "end"
        #     ignore_newline = "no";
        #     stack_duplicates = true;
        #     hide_duplicate_count = true;
        #     show_indicators = "yes";
        #     icon_position = "left"; # "right", "off"
        #     max_icon_size = 32;
        #     sticky_history = "yes";
        #     history_length = 20;
        #     dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
        #     browser = "${pkgs.firefox}/bin/firefox -new-tab";
        #     mouse_left_click = "close_current";
        #     mouse_middle_click = "do_action";
        #     mouse_right_click = "close_all";
        #   };
        #   urgency_low = {
        #     background = "#A3BE8C"; # Nord Frost Green
        #     foreground = "#2E3440"; # Nord Polar Night
        #     timeout = 10;
        #   };
        #   urgency_normal = {
        #     background = "#EBCB8B"; # Nord Frost Yellow
        #     foreground = "#2E3440";
        #     timeout = 10;
        #   };
        #   urgency_critical = {
        #     background = "#BF616A"; # Nord Aurora Red
        #     foreground = "#ECEFF4"; # Nord Snow Storm
        #     timeout = 0; # Sticky
        #     frame_color = "#BF616A";
        #   };
        #   # You can add custom rules for applications here
        #   # Example:
        #   # spotify = {
        #   #   summary = "Spotify";
        #   #   format = "%s";
        #   #   urgency = "low";
        #   # };
        # };
      };
    };
  };
}
