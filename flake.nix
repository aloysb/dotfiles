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

    # Add neovim-nightly-overlay with a specific revision
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/c689a1c053b079dc95231ab4d800e7d3cf13c0ce";
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

    hyprland = {
      url = "github:hyprwm/Hyprland/b1e5cc66bdb20b002c93479490c3a317552210b3";
      #url = "github:hyprwm/Hyprland/b74a56e2acce8fe88a575287a20ac196d8d01938";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
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
    neovim-nightly-overlay,
    hyprland,
    stylix,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
    ];

    systemLinux = "aarch64-linux";
    systemDarwin = "aarch64-darwin";

    # A helper function for the home manager configuration.
    mkHomeConfig = system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          inherit overlays;
        };
        modules = [
          ./home-manager/home.nix
          {nixpkgs.overlays = overlays;}
        ];
        extraSpecialArgs = {
          inherit hyprland;
        };
      };
  in {
    ##########################################
    # Nix Darwin
    ##########################################
    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = systemDarwin;
      specialArgs = {inherit self;};
      modules = [
        ./darwin/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "aloys";
            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
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
    nixosConfigurations.myNixOS = nixpkgs.lib.nixosSystem {
      system = systemLinux;
      modules = [
        ./nixos/configuration.nix
      ];
    };

    ##########################################
    # Home manager configuration
    ##########################################
    homeConfigurations = {
      # For Linux systems
      linux = mkHomeConfig systemLinux;
      # For macOS systems (if you want a separate Home Manager config)
      darwin = mkHomeConfig systemDarwin;
    };
  };
}
