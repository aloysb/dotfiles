# Symlinks the content of ./scripts from flake root to ~/.config/scripts
{
  config,
  userScripts, # Injected from symlinks.nix (originally from flake.nix)
  ...
}:
# let
  # pathToFolder = "${config.home.homeDirectory}/.config/nix/scripts"; # Old way
# in
{
  # This will create a symlink from ~/.config/scripts to the ./scripts directory in the Nix store.
  # All files from ./scripts will then be available under ~/.config/scripts/
  # For example, REPO_ROOT/scripts/backup -> /nix/store/...-scripts/backup -> ~/.config/scripts/backup
  home.file.".config/scripts" = {
    source = userScripts; # userScripts is the path to the ./scripts directory from flake root
    force = true;
    recursive = true; # Ensures the directory is linked
  };
}
