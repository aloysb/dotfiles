{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.programs.nvim;
  dotfilesDir = specialArgs.dotfiles; # Path to ./dotfiles from flake root
in {
  options.modules.programs.nvim.enable = lib.mkEnableOption "Neovim editor configuration";

  config = lib.mkIf cfg.enable {
    # Neovim is primarily configured by its own Lua files,
    # so the main thing Home Manager does is install it and symlink configs.
    # The existing `home-manager/symlinks.nix` handles the config linking.
    # We'll replicate that logic in the `dotfiles.nix` module later.

    # Ensure Neovim is installed
    home.packages = [pkgs.neovim];

    # If you had specific `programs.neovim` options in Home Manager, they would go here.
    # For example:
    # programs.neovim = {
    #   enable = true; # This is implicit if we are in this module and it's enabled.
    #   package = pkgs.neovim; # Or a specific version/overlay
    #   defaultEditor = true; # Sets EDITOR, VISUAL if not already set
    #   viAlias = true;
    #   vimAlias = true;
    # };

    # The actual nvim config is at `dotfiles/nvim/`
    # This will be symlinked by the `dotfiles` module to `~/.config/nvim`
    # No specific nvim settings were in the original home-manager/home.nix programs.neovim section,
    # it relied on symlinks.
  };
}
