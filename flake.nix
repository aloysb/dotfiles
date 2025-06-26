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

    # Common specialArgs for all systems
    commonSpecialArgs = system: {
      inherit inputs self username hyprland sops-nix; # sops-nix might be needed by HM modules
      home-directory = homeDirectory system;
      dotfiles = ./dotfiles;
      userScripts = ./scripts;
      pkgs = pkgsForSystem system; # Make pkgs available in specialArgs for modules if they need it directly
                                   # though typically modules receive pkgs as a top-level argument.
    };

  in {
    ##########################################
    # Nix Darwin
    ##########################################
    darwinConfigurations."darwin-macbook-m1" = nix-darwin.lib.darwinSystem {
      system = systemDarwin;
      specialArgs = commonSpecialArgs systemDarwin;
      modules = [
        ./hosts/darwin-macbook-m1/default.nix
        # The home-manager configuration is now managed within hosts/darwin-macbook-m1/default.nix
      ];
    };

    ##########################################
    # NixOS configuration
    ##########################################
    nixosConfigurations."linux-homelab-x86" = nixpkgs.lib.nixosSystem {
      system = systemLinux;
      specialArgs = commonSpecialArgs systemLinux;
      modules = [
        ./hosts/linux-homelab-x86/default.nix
        # The home-manager configuration is now managed within hosts/linux-homelab-x86/default.nix
      ];
    };

    ##########################################
    # Home manager configurations (now part of host configurations)
    ##########################################
    # Home Manager configurations are now integrated into the darwinConfigurations
    # and nixosConfigurations respectively.
    # The `home-manager` block within each host's default.nix will define the HM setup.
    # If you still need to build standalone HM configs, you could do so like this:
    # homeConfigurations."${username}@${systemLinux}" = home-manager.lib.homeManagerConfiguration {
    #   pkgs = pkgsForSystem systemLinux;
    #   extraSpecialArgs = commonSpecialArgs systemLinux;
    #   modules = [
    #     # Import the HM setup from the Linux host, or a dedicated HM profile if preferred
    #     # This assumes hosts/linux-homelab-x86/default.nix defines a top-level 'home-manager' attribute
    #     # which might not be directly consumable here.
    #     # A more robust way is to have the host file itself configure HM.
    #     ./hosts/linux-homelab-x86/home.nix # If you were to extract HM config to a separate file per host
    #     # or directly:
    #     # ({ config, ... }: {
    #     #   imports = [ ./modules/home-manager.nix ]; # The bridge
    #     #   home.username = username;
    #     #   home.homeDirectory = homeDirectory systemLinux;
    #     #   # ... other HM global settings ...
    #     #   # Enable modules as done in the host file
    #     #   modules = { programs.zsh.enable = true; ... };
    #     # })
    #   ];
    # };
    # homeConfigurations."${username}@${systemDarwin}" = home-manager.lib.homeManagerConfiguration {
    #   pkgs = pkgsForSystem systemDarwin;
    #   extraSpecialArgs = commonSpecialArgs systemDarwin;
    #   modules = [
    #     # Similar to above, for Darwin
    #     # ./hosts/darwin-macbook-m1/home.nix
    #   ];
    # };
    # For now, we assume home manager is primarily configured as part of the system configurations.
    # The host files already set up home-manager.users.${username} which is the standard way.
  };
}
