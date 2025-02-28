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

    # Add neovim-nightly-overlay
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

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
    neovim-nightly-overlay,
    hyprland,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
	(final: prev: {
		hyprland = prev.hyprland.override {
			libgbm = prev.mesa;
		};
	})
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
        "./nix-darwin/configuration.nix"
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "aloys";
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
