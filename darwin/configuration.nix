{self, ...}: {
  imports = [
    ./dock.nix
    ./homebrew/homebrew.nix
  ];
  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  programs.ssh.extraConfig = ''
    #AcceptEnv WEZTERM_REMOTE_PANE
  '';
  services = {
    openssh = {
      enable = true;
    };
    karabiner-elements = {
      enable = true;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nix = {
    settings = {
      trusted-users = [
        "root"
        "aloys"
      ];
    };
    extraOptions = ''
      auto-optimise-store = true
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  # Declare the user that will be running `nix-darwin`
  users.users.aloys = {
    name = "$USER";
    home = "/Users/$USER";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.startup.chime = false;

  system.defaults = {
    finder = {
      QuitMenuItem = true;
      FXRemoveOldTrashItems = true;
    };
    NSGlobalDomain."com.apple.swipescrolldirection" = false; #non-natural scrolling
  };

  nix = {
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  # options = {
  #   virtualisation = {
  #     docker = {
  #       enable = true;
  #       rootless = {
  #         enable = true;
  #       };
  #     };
  #   };
  # };
}
