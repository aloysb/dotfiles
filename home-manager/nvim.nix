{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim; # this contains the nightly overlay
    plugins = with pkgs.vimPlugins; [
      nord-nvim # theme
      fzf-lua
      oil-nvim
      blink-cmp
      nvim-treesitter.withAllGrammars
    ];
  };
}
