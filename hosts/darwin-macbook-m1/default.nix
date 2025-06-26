{ inputs, system, specialArgs, ... }:

let
  username = specialArgs.username;
  home-directory = specialArgs.home-directory;
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = specialArgs; # Pass along all specialArgs

  modules = [
    ../../modules/default.nix # Common modules

    # Import Homebrew module definition from nix-homebrew flake
    inputs.nix-homebrew.darwinModules.nix-homebrew
    # Import Stylix module if you use it for Darwin
    # inputs.stylix.darwinModules.stylix

    # Host-specific configurations can go here or be in separate files imported here
    ({ lib, config, pkgs, ... }: {
      # System state version
      system.stateVersion = 5; # As per your original darwin/configuration.nix

      # Enable Home Manager integration (this is a custom option from modules/default.nix)
      modules.home-manager.enable = true;

      # Enable desired modules for this host using the structure in modules/default.nix
      config.modules = {
        system = {
          nix-settings.enable = true;
          users.enable = true; # This will pull user setup from modules/system/users.nix
          sops.enable = true; # Assuming sops is used on Darwin too
          homebrew.enable = true; # Enable the homebrew module (to be created)
        };
        services = {
          openssh.enable = true; # Example, to be created
          aerospace.enable = true; # Example, to be created
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
          # firefox.enable = true; # If you use Firefox and have a module for it
          dock.enable = true; # macOS dock settings (module to be created)
        };
      };

      # Configuration for the nix-homebrew module itself (from nix-homebrew flake)
      # This is separate from `config.modules.system.homebrew.enable` which is our own module.
      # Our own module `modules/system/homebrew.nix` will likely CONFIGURE this `nix-homebrew` block.
      # For now, we keep the direct configuration as a placeholder until that module is written.
      # It might be that our `modules/system/homebrew.nix` sets these values.
      nix-homebrew = {
        enable = true; # This enables the actual nix-homebrew module from the input.
        inherit username;
        # Taps and formulae will be managed by the `modules/system/homebrew.nix` module.
        # For example, it would populate `homebrewCasks` and `homebrewPackages` here.
        taps = { # These are fundamental and needed for nix-homebrew to work
           "homebrew/homebrew-core" = inputs.homebrew-core;
           "homebrew/homebrew-cask" = inputs.homebrew-cask;
           "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        };
        mutableTaps = false;
      };

      # Home Manager configuration for this host
      home-manager = {
        useGlobalPkgs = true; # Use system-level pkgs for HM
        useUserPackages = true; # Allow user-specific packages in HM
        extraSpecialArgs = specialArgs; # Pass username, home-directory, inputs, self, dotfiles, userScripts
        users.${username} = { ... }: { # The ... is for args like pkgs, config, lib
          imports = [
            ../../modules/home-manager.nix # A new file to bridge host enables to HM module imports
          ];
          # Set home directory for HM, should be derived from specialArgs
          home.homeDirectory = home-directory;
          home.username = username;
          home.stateVersion = "24.11"; # As per your original home.nix
        };
      };

      # Include stylix if you are using it
      # stylix.enable = true;
      # stylix.image = ./wallpapers/mywallpaper.png; # Example
      # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    })
  ];
}
