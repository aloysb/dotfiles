{ lib, config, pkgs, inputs, specialArgs, ... }:

let
  cfg = config.modules.system.sops;
  # Define the path to the main secrets file relative to the flake's root.
  # This assumes your flake.nix is at the root of your repository.
  # `specialArgs.self` would typically point to the flake's outputs,
  # and `specialArgs.self.path` (if available and set up in flake.nix) could point to the flake's root directory.
  # Alternatively, and more simply for module imports, use a relative path from this module file
  # to the flake root, assuming a known directory structure.
  # If this module is at modules/system/sops.nix, then ../../secrets.yaml points to <flake-root>/secrets.yaml
  secretsFile = ../../secrets.yaml;
  username = specialArgs.username;

in
{
  options.modules.system.sops = lib.mkEnableOption "Sops integration for secrets management";

  config = lib.mkIf cfg.enable {
    # ====== NixOS System-Level Sops Configuration ======
    sops = lib.mkIf pkgs.stdenv.isLinux { # sops NixOS module is for NixOS
      enable = true; # Enable the sops-nix module for NixOS
      defaultSopsFile = secretsFile;
      # age.keyFile = "/var/lib/sops/age/keys.txt"; # Default location for NixOS system age key
      # age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Example: use SSH host key for decryption
      # Or specify your age public keys that can decrypt the secrets.yaml
      # age.publicKeys = [ "age1..." ];

      # Define system-level secrets that sops-nix should manage
      # These were in the original nixos/configuration.nix
      secrets.restic_password = {
        # mode = "0440"; # Example: set permissions
        # user = config.users.users.restic.name; # Example: set owner if a restic user exists
        # group = config.users.groups.restic.name; # Example: set group
        # No need to specify sopsFile if defaultSopsFile is set and key matches in YAML
      };

      # Example for user password if managed this way (from original nixos/configuration.nix)
      # Ensure 'userPasswords.aloys' (or similar based on username) exists in secrets.yaml
      # secrets."user_password_${username}" = {
      #   key = "userPasswords/${username}"; # Path in YAML: userPasswords.<username>
      # };
      # users.users.${username}.passwordFile = lib.mkIf (config.sops.secrets."user_password_${username}" != null)
      #   config.sops.secrets."user_password_${username}".path;
    };


    # ====== Home Manager Sops Configuration ======
    # This applies if home-manager itself is enabled for the user.
    # The sops-nix homeManagerModule should be imported in the host's HM config.
    # hosts/.../default.nix -> home-manager.users.xxx.imports = [ inputs.sops-nix.homeManagerModules.sops ];
    home-manager.users.${username} = lib.mkIf (config.modules.home-manager.enable) {
      sops = {
        defaultSopsFile = secretsFile; # Relative to where HM config is evaluated, or use absolute path.
                                       # The host HM config should pass this correctly.
        # age.keyFile = "${config.home.homeDirectory}/.sops/key.txt"; # Example user-specific age key
        # age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ]; # User's SSH key
        # Or specify public keys:
        # age.publicKeys = [ "age1..." ];

        # Define user-level secrets
        # From original home-manager/home.nix
        secrets.OPENROUTER_API_KEY = {
          # This will make the decrypted content available as a file.
          # To use it as an environment variable, Zsh/Bash init scripts need to source it.
          # Or, sops-nix might have mechanisms to directly expose it as an env var to certain programs.
          # For Zsh, you might have:
          # programs.zsh.initExtra = "export OPENROUTER_API_KEY=$(cat ${config.sops.secrets.OPENROUTER_API_KEY.path})";
        };
        # If you want sops-nix to generate a script that exports variables:
        # secrets."openrouter_api_key_env_file" = {
        #   key = "OPENROUTER_API_KEY"; # Key in secrets.yaml
        #   format = "bash"; # or "zsh"
        #   # This creates a file that can be sourced.
        # };
      };

      # Example of sourcing the secret into Zsh environment
      # This should ideally be in the zsh module, checking if sops is enabled.
      programs.zsh.initExtra = lib.mkIf (config.sops.secrets.OPENROUTER_API_KEY ? path) ''
        if [ -f "${config.sops.secrets.OPENROUTER_API_KEY.path}" ]; then
          export OPENROUTER_API_KEY="$(cat "${config.sops.secrets.OPENROUTER_API_KEY.path}")"
        fi
      '';
    };
  };
}
