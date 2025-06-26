{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.desktop.firefox;
in
{
  options.modules.desktop.firefox = lib.mkEnableOption "Firefox web browser";

  config = lib.mkIf (cfg.enable && config.modules.home-manager.enable) {
    home-manager.users.${specialArgs.username} = {
      programs.firefox = {
        enable = true;
        # package = pkgs.firefox; # Or pkgs.firefox-wayland if needed and available
        # profiles = {
        #   # Default profile
        #   "default" = {
        #     isDefault = true;
        #     # search = {
        #     #   default = "DuckDuckGo";
        #     #   privateDefault = "DuckDuckGo";
        #     #   force = true;
        #     # };
        #     # settings = {
        #     #   "browser.startup.homepage" = "https://duckduckgo.com";
        #     #   "gfx.webrender.all" = true; # Enable Webrender
        #     #   "gfx.webrender.compositor.force-enabled" = lib.mkIf pkgs.stdenv.isLinux true; # Wayland specific
        #     #   "widget.wayland-dmabuf-vaapi.enabled" = lib.mkIf pkgs.stdenv.isLinux true; # VA-API on Wayland
        #     #   "widget.wayland-dmabuf-webgl.enabled" = lib.mkIf pkgs.stdenv.isLinux true; # WebGL DMA-BUF on Wayland
        #     # };
        #     # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #     #   ublock-origin
        #     #   bitwarden
        #     #   # Add other extensions
        #     # ];
        #   };
        #   # You can define other profiles here
        #   # "work" = { ... };
        # };
      };
      # Add policies for firefox if needed
      # programs.firefox.policies = { };

      # Add firefox to home packages to ensure it's installed
      # (programs.firefox.enable usually handles this, but to be sure)
      home.packages = [ pkgs.firefox ];
    };

    # System-level settings for Firefox if any (e.g., fontconfig for Wayland)
    # environment.variables = lib.mkIf pkgs.stdenv.isLinux {
    #   MOZ_ENABLE_WAYLAND = "1"; # Make Firefox run natively on Wayland
    # };
    # This is often set by default now or handled by wrappers.
  };
}
