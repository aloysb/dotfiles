{ lib, config, pkgs, ... }:

let
  cfg = config.modules.programs.pass;
in
{
  options.modules.programs.pass = lib.mkEnableOption "Password Store (pass)";

  config = lib.mkIf (config.modules.home-manager.enable && cfg.enable) {
    programs.password-store = {
      enable = true;
      # settings = {
      #   PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      # };
      # Ensure GPG support is configured if not already handled by the gpg module
      # package = pkgs.pass.withExtensions (ext: [ ext.pass-otp ]); # Example with OTP extension
    };

    # If GPG module is enabled, it should already set up the agent.
    # If not, you might need basic gpg agent settings here.
    # programs.gpg.enable = lib.mkIf (!config.modules.programs.gpg.enable) true;
  };
}
