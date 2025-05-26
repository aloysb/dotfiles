# This function takes anything specified directory and symlink it to ~/.config/folderName.
# This allows me to put any config doftiles that I don't want managed by nix in there and they will be symlinked in the right spot.
# Symlink allows me to change them on the fly without having to rebuild the system.
# I can't use readdir as it would make the system impure with paths :/
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Define the folders you want to symlink explicitly
  foldersToSymlink =
    [
      "nvim"
      "wezterm"
      "lazygit"
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      "aerospace"
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      "waybar"
      "rofi"
      "hypr"
      "wallpapers"
    ];
  pathToFolder = "${config.home.homeDirectory}/.config/nix/dotfiles";
in {
  home.file =
    lib.listToAttrs (lib.lists.forEach foldersToSymlink (folder: {
      name = ".config/${folder}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${pathToFolder}/${folder}";
        force = true;
        recursive = true;
      };
    }))
    // import ./scripts.nix {inherit config;};
}
