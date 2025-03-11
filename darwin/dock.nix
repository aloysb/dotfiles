{...}: {
  system.defaults.dock = {
    autohide = true;
    static-only = true;
    show-recents = false;
    autohide-time-modifier = 0.2;
    autohide-delay = 0.1;
    persistent-apps = [
      "/System/Applications/Utilities/Terminal.app"
    ];
  };
}
