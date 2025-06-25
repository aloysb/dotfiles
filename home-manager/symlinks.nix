# This function takes anything specified directory and symlink it to ~/.config/folderName.
# This allows me to put any config doftiles that I don't want managed by nix in there and they will be symlinked in the right spot.
# Symlink allows me to change them on the fly without having to rebuild the system.
# I can't use readdir as it would make the system impure with paths :/
{
  config,
  lib,
  pkgs,
  dotfiles, # Injected from extraSpecialArgs
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
      # "hypr" # hypr configs are handled by home.file for hyprpaper.conf and wayland.windowManager.hyprland.extraConfig
      "wallpapers"
    ];
  # pathToFolder is now the injected dotfiles path from the flake root
  # pathToFolder = "${config.home.homeDirectory}/.config/nix/dotfiles"; # Old way
in {
  home.file =
    lib.listToAttrs (lib.lists.forEach foldersToSymlink (folder: {
      name = ".config/${folder}"; # Symlink target, e.g., ~/.config/nvim
      value = {
        source = "${dotfiles}/${folder}"; # Symlink source, e.g., REPO_ROOT/dotfiles/nvim
                                          # mkOutOfStoreSymlink is not needed if `dotfiles` is a store path.
                                          # If `dotfiles` is just a path string like "./dotfiles",
                                          # then mkOutOfStoreSymlink is appropriate if it needs to point
                                          # outside the store. Given it's from flake root, it will be copied to store.
                                          # So direct path should be fine.
        force = true;
        recursive = true; # recursive for symlinks typically means if source is a dir, target is a dir.
                         # For home.file, `source` being a directory and `recursive = true` is not standard.
                         # Usually, `home.file.<path>.source` points to a file.
                         # To link directories, `home.xdg.configFile.<name>.source = path` is better.
                         # Or just ensure the `source` is treated as a directory by `home.file`.
      };
    }))
    // import ./scripts.nix {inherit config pkgs lib dotfiles userScripts;}; # Pass userScripts
}
