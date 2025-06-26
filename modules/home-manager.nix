{...}: {
  imports = [
    # Programs - CLI
    ./programs/git/user.nix
    #./programs/zsh.nix
    ./programs/nvim/user.nix
    ./programs/lazygit/user.nix
    #./programs/fzf.nix
    #./programs/bat.nix
    #./programs/zoxide.nix
    #./programs/direnv.nix
    #./programs/gpg.nix
    #./programs/pass.nix
    #./programs/dotfiles.nix

    # Programs - General Packages (home.packages)
    #    ./programs/packages.nix
    ../dotfiles/default.nix

    # Desktop / GUI - Handled by Home Manager
    #./desktop/firefox.nix
  ];
}
