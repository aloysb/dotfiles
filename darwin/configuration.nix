{
  pkgs,
  nix-homebrew,
  self,
  ...
}: {
  imports = [
    ./dock.nix
  ];
  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nix.extraOptions = ''
    auto-optimise-store = true
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Declare the user that will be running `nix-darwin`
  users.users.aloys = {
    name = "$USER";
    home = "/Users/$USER";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.startup.chime = false;

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

  # Add the homebrew packages
  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";
    taps = [];
    brews = [
      "thefuck"
      # work SH
      "postgresql@15"
      "nss"
    ];
    casks = [
      "wezterm"
    ];
  };
}
