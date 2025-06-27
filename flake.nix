{
  description = "Aloys' Nix Chaos";
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
    sops-nix = {
      # Added sops-nix input
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
    sops-nix,
    ...
  } @ inputs: let
    # Define all overlays here
    customOverlays = [
      # Overlay from home-manager/home.nix
      (import ./overlays/aider-overlay.nix)
      (final: prev: {
        # tree-sitter fix
        tree-sitter-bundled-vendor = prev.tree-sitter-bundled-vendor.overrideAttrs (oldAttrs: {
          outputHash = "sha256-ie+/48dVU3r+tx/sQBWRIZEWSNWwMBANCqQLnv96JXs=";
        });
      })
    ];

    username = "aloys";
    systemLinux = "x86_64-linux";
    systemDarwin = "aarch64-darwin";
    homeDirectory = system:
      if system == systemLinux
      then "/home/${username}"
      else "/Users/${username}";

    # Centralized pkgs definition for a given system
    pkgsForSystem = system:
      import nixpkgs {
        inherit system;
        overlays = customOverlays;
        config.allowUnfree = true;
      };

    # Common specialArgs for all systems
    commonSpecialArgs = system: {
      inherit inputs self username sops-nix; # sops-nix might be needed by HM modules
      home-directory = homeDirectory system;
      dotfiles = ./modules/dotfiles;
      userScripts = ./scripts;
      isLinux = system == systemLinux;
      isDarwin = system == systemDarwin;
      pkgs = pkgsForSystem system;
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
  };
}
