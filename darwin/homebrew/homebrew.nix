{...}: {
  homebrew = {
    enable = true;
    #onActivation.cleanup = "uninstall";
    taps = import ./taps.nix;
    brews = import ./brews.nix;
    casks = import ./casks.nix;
  };
}
