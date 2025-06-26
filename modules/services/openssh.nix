{ lib, config, pkgs, ... }:

let
  cfg = config.modules.services.openssh;
in
{
  options.modules.services.openssh = lib.mkEnableOption "OpenSSH server configuration";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      # settings = {
      #   PermitRootLogin = "no"; # Example: common security practice
      #   PasswordAuthentication = false; # Example: if only using key-based auth
      #   KbdInteractiveAuthentication = false; # Also for disabling password auth
      # };
      # extraConfig allows appending raw string to sshd_config
      # This was in darwin/configuration.nix, useful for both platforms
      extraConfig = ''
        AcceptEnv WEZTERM_REMOTE_PANE # If you use Wezterm's remote pane feature
      '';
    };

    # Firewall rules for SSH (NixOS specific)
    networking.firewall = lib.mkIf (pkgs.stdenv.isLinux && config.networking.firewall.enable) {
      allowedTCPPorts = [ 22 ]; # Or whatever port SSH is configured on
    };
  };
}
