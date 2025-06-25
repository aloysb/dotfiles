{
  description = "Nix-darwin + nixos configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Needed for nix darwin for now as not all pkgs are within nixpkgs
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    # emacs-plus input removed as per review (unused/broken)
    # emacs-plus = {
    #   url = "github:d12frosted/homebrew-emacs-plus";
    #   flake = false;
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland/b1e5cc66bdb20b002c93479490c3a317552210b3";
      #url = "github:hyprwm/Hyprland/b74a56e2acce8fe88a575287a20ac196d8d01938";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
    };
    sops-nix = { # Added sops-nix input
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure it uses the same nixpkgs
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    hyprland,
    stylix,
    sops-nix, # Added sops-nix to function arguments
    ...
  } @ inputs: let
    # Define all overlays here
    customOverlays = [
      # Overlay from home-manager/home.nix
      (import ./overlays/aider-overlay.nix)
      (final: prev: { # tree-sitter fix
        tree-sitter-bundled-vendor = prev.tree-sitter-bundled-vendor.overrideAttrs (oldAttrs: {
          outputHash = "sha256-ie+/48dVU3r+tx/sQBWRIZEWSNWwMBANCqQLnv96JXs=";
        });
      })
      # Overlay from nixos/configuration.nix
      (final: prev: { # Hyprland fix
        hyprland = prev.hyprland.override { # Corrected typo hyrpland -> hyprland
          libgbm = prev.mesa; # Assuming mesa is correctly available in prev scope
        };
      })
    ];

    username = "aloys";
    systemLinux = "aarch64-linux";
    systemDarwin = "aarch64-darwin";
    homeDirectory = system:
      if system == systemLinux
      then "/home/${username}"
      else "/Users/${username}";

    # Centralized pkgs definition for a given system
    pkgsForSystem = system: import nixpkgs {
      inherit system;
      overlays = customOverlays;
      config.allowUnfree = true;
    };

    # Helper function for creating NixOS systems
    mkNixOsSystem = modulesPath: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgsForSystem system; # Use centralized pkgs
        specialArgs = {
          inherit inputs self username;
          home-directory = homeDirectory system;
          # pkgs can also be passed here if modules expect it explicitly instead of using the top-level pkgs
        };
        modules = [ modulesPath ];
      };

    # A helper function for the home manager configuration.
    mkHomeConfig = system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem system; # Use centralized pkgs
        modules = [
          ./home-manager/home.nix # your own HM config
          inputs.sops-nix.homeManagerModules.sops # Added sops-nix HM module
        ];
        extraSpecialArgs = {
          inherit inputs self username hyprland sops-nix;
          home-directory = homeDirectory system;
          dotfiles = ./dotfiles; # Pass the path to the dotfiles directory
          userScripts = ./scripts; # Pass the path to the user scripts directory
        };
      };
  in {
    ##########################################
    # Nix Darwin
    ##########################################
    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = systemDarwin;
      specialArgs = {
        inherit self inputs username; # Added username
        home-directory = homeDirectory systemDarwin; # Added home-directory
      };
      modules = [
        ./darwin/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = username; # Use abstracted username
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              # "d12frosted/homebrew-emacs-plus" = inputs.emacs-plus; # Removed
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        stylix.darwinModules.stylix
      ];
    };

    ##########################################
    # NixOS configuration
    ##########################################
    nixosConfigurations.myNixOS = mkNixOsSystem ./nixos/configuration.nix systemLinux;

    ##########################################
    # Home manager configuration
    ##########################################
    homeConfigurations = {
      # For Linux systems
      "aloys@${systemLinux}" = mkHomeConfig systemLinux; # Changed key format for clarity
      # For macOS systems
      "aloys@${systemDarwin}" = mkHomeConfig systemDarwin; # Changed key format for clarity
    };
  };
}
