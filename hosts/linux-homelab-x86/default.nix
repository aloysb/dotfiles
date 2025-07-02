{
  inputs,
  system,
  specialArgs,
  ...
}: let
  username = specialArgs.username;
  home-directory = specialArgs.home-directory;
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = specialArgs; # Pass along all specialArgs

    modules = [
      ../../modules/default.nix # Common modules

      # Hardware configuration for this specific host
      ../../nixos/hardware-configuration.nix # Keep this as it's machine-specific

      # Host-specific configurations
      ({
        lib,
        config,
        pkgs,
        ...
      }: {
        # Bootloader (example, keep your original or move to a system module if very generic)
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = false; # As per your original

        # Networking (example, keep your original or move to a module if generic enough)
        # For now, kept here as it can be quite host-specific.
        networking.wireless.iwd.enable = true; # As per your original
        networking.networkmanager.enable = false; # Explicitly disable if iwd is used.
        networking.hostName = "linux-homelab"; # Or derive from specialArgs if needed, e.g. specialArgs.hostName

        # System state version
        system.stateVersion = "25.05"; # As per your original nixos/configuration.nix

        # Enable Home Manager integration (custom option from modules/default.nix)
        modules.home-manager.enable = true;

        # Enable desired modules for this host using the structure in modules/default.nix
        config.modules = {
          system = {
            nix-settings.enable = true;
            users.enable = true; # This will pull user setup from modules/system/users.nix
          };
          services = {
            openssh.enable = true; # Module to be created/populated
            docker.enable = true; # Module to be created/populated
          };
          programs = {
            git.enable = true;
            zsh.enable = true;
            nvim.enable = true;
            fzf.enable = true;
            bat.enable = true;
            eza.enable = true;
            zoxide.enable = true;
            direnv.enable = true;
            gpg.enable = true;
            pass.enable = true;
            packages.enable = true;
            dotfiles.enable = true;
          };
          desktop = {
            #hyprland.enable = true; # Module to be created/populated
            waybar.enable = true; # Module to be created/populated
            rofi.enable = true; # Module to be created/populated
            firefox.enable = true; # Module to be created/populated
            # dunst.enable = true;    # Module to be created/populated
            # foot.enable = true;     # Module to be created/populated
            # eww.enable = true;      # Module to be created/populated
          };
        };

        # Home Manager configuration for this host
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs; # Pass username, home-directory, inputs, self, dotfiles, userScripts
          users.${username} = {...}: {
            # The ... is for args like pkgs, config, lib
            imports = [
              ../../modules/home-manager.nix # A new file to bridge host enables to HM module imports
            ];
            home.homeDirectory = home-directory;
            home.username = username;
            home.stateVersion = "24.11"; # As per your original home.nix
          };
        };
      })
    ];
  }
