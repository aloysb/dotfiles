{
  lib,
  config,
  specialArgs,
  ...
}: let
  isLinux = specialArgs.isLinux;
in {
  options.modules.services.openssh = lib.mkEnableOption "OpenSSH server";

  config = lib.mkIf config.modules.services.openssh.enable (lib.mkMerge [
    {
      services.openssh = {
        enable = true;
        extraConfig = ''
          AcceptEnv WEZTERM_REMOTE_PANE
        '';
      };
    }

    (lib.optionalAttrs isLinux {
      # Only NixOS has this option, so no guards needed inside the file.
      networking.firewall.allowedTCPPorts = [22];
    })
  ]);
}
