# Copy my scripts in a "script" dir
# TODO: clean this up
{config}: let
  # Define the folders you want to symlink explicitly
  pathToFolder = "${config.home.homeDirectory}/.config/nix/scripts";
in {
  ".config/scripts" = {
    source = config.lib.file.mkOutOfStoreSymlink pathToFolder;
    force = true;
    recursive = true;
  };
}
