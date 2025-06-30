{
  inputs,
  specialArgs,
  ...
}: let
  username = specialArgs.username;
  home-directory = specialArgs.home-directory;

  # Enable desired modules for this host using the structure in modules/default.nix
  modulesSystem = {
    home-manager = {
      enable = true;
    };
    system = {
      nix-settings.enable = true;
      users.enable = true; # This will pull user setup from modules/system/users.nix
      sops.enable = true; # Assuming sops is used on Darwin too
      homebrew.enable = true; # Enable the homebrew module (to be created)
    };
    services = {
      openssh.enable = true;
      aerospace.enable = true;
    };
    programs = {
      git.enable = true;
      #      zsh.enable = true;
      nvim.enable = true;
    };
    desktop = {
      #firefox.enable = true; # If you use Firefox and have a module for it
      dock.enable = true; # macOS dock settings (module to be created)
    };
  };

  modulesHM = {
    hm = {
      core.enable = true;
    };
    programs = {
      git.enable = true;
      lazygit.enable = true;
      dotfiles.enable = true;
      zsh.enable = true;
      fzf.enable = true;
      bat.enable = true;
      zoxide.enable = true;
      direnv.enable = true;
      gpg.enable = true;
      #pass.enable = true;
    };
    services = {
      restic.enable = true;
    };
  };
in {
  imports = [
    ../../modules/default.nix # Common modules
    # Import Homebrew module definition from nix-homebrew flake
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  # System state version
  system.stateVersion = 5;

  # Enable Home Manager integration (this is a custom option from modules/default.nix)
  modules = modulesSystem;

  # nix-homebrew = {
  #   enable = true; # This enables the actual nix-homebrew module from the input.
  #   taps = {
  #     # These are fundamental and needed for nix-homebrew to work
  #     "homebrew/homebrew-core" = inputs.homebrew-core;
  #     "homebrew/homebrew-cask" = inputs.homebrew-cask;
  #     "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
  #   };
  #   mutableTaps = false;
  # };

  # Home Manager configuration for this host
  home-manager = {
    useGlobalPkgs = true; # Use system-level pkgs for HM
    useUserPackages = true; # Allow user-specific packages in HM
    extraSpecialArgs = specialArgs; # Pass username, home-directory, inputs, self, dotfiles, userScripts
    backupFileExtension = "backup";
    users.${username} = {config, ...}: {
      imports = [
        ../../modules/home-manager/default.nix
      ];
      config = {
        launchd.enable = true;
        modules = modulesHM;
        home = {
          homeDirectory = home-directory;
          username = username;
          stateVersion = "24.11";
        };
      };
    };
  };
}
