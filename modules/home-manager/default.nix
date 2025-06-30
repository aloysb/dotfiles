{...}: {
  imports = [
    ./core.nix
    # Shell
    ../programs/zsh/user.nix

    # Services
    ../services/restic/user.nix

    # Programs - CLI
    ../programs/git/user.nix
    ../programs/nvim/user.nix
    ../programs/lazygit/user.nix
    ../programs/fzf/user.nix
    ../programs/bat/user.nix
    ../programs/zoxide/user.nix
    ../programs/direnv/user.nix
    ../programs/gpg/user.nix
    #./programs/pass/user.nix
    ../programs/core.nix

    # Configuration files
    ../dotfiles/default.nix
  ];
}
