{...}: let
  excludes = [
    "**/.git"
    "**/node_modules"
    "**/*.cache"
    "**/dist"
    "**/tmp"
  ];
in {
  paths = [
    #"~/projects" # Need a script to exclude git repos, node modules, etc.
    "~/areas"
    "~/resources"
    "~/archives"
  ];
  repository = "s3:s3.us-west-004.backblazeb2.com";
  exclude = excludes;
  #environmentFile = "./.env.para";
  passwordFile = "./.restic-password";
  initialize = true;
  timerConfig = {
    Persistent = true;
    OnCalendar = "*-*-* 00:00:00";
  };
}
