{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim; #this contains the nightly overlay
    plugins = with pkgs.vimPlugins; [
      nightfox-nvim # theme
      fzf-lua
      oil-nvim
      blink-cmp
      nvim-treesitter.withAllGrammars
      diffview-nvim
      gitsigns-nvim
      mini-ai
      mini-surround
      mini-pairs
      mini-comment
      mini-bracketed
      mini-bufremove
      nvim-web-devicons
    ];
  };
}
