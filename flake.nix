{
  description = "Nix-darwin + nixos configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs?rev=d2faa1bbca1b1e4962ce7373c5b0879e5b12cef2";
      # pinned until nix-darwin issue resolved https://github.com/LnL7/nix-darwin/issues/1317
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
      url = "github:nix-community/neovim-nightly-overlay?rev=adee34d9e71f021dd8b635e8dd8e7329dea6ef79";
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
  };

  outputs = inputs @ {
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
    ...
  }: let
    # Remove the custom nixpkgs and neovimNightlyFixed
    overlays = [
      # Temporarily disable neovim-nightly-overlay to allow the system to update
      # neovim-nightly-overlay.overlays.default
    ];

    systemDarwin = "aarch64-darwin";
    systemLinux = "aarch64-linux";

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
      system = systemDarwin; #
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
