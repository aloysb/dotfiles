{ lib, config, pkgs, ... }:

let
  cfg = config.modules.programs.fzf;
in
{
  options.modules.programs.fzf = lib.mkEnableOption "fzf fuzzy finder";

  config = lib.mkIf (config.modules.home-manager.enable && cfg.enable) {
    programs.fzf = {
      enable = true;
      enableZshIntegration = config.modules.programs.zsh.enable; # Only if zsh module is also enabled
      # enableBashIntegration = true; # If you use bash
      # enableFishIntegration = true; # If you use fish

      historyWidgetOptions = [
        "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'" # pbcopy is macOS specific
                                                                     # For Linux, use xclip or wl-copy
        "--color header:italic"
        "--header 'Press CTRL-Y to copy command into clipboard'"
      ];
      changeDirWidgetOptions = [
        "--walker-skip .git,node_modules,target"
        "--preview 'eza -T'" # Assumes eza is installed and on PATH
      ];
      # Default options for fzf command itself
      # defaultOptions = [ "--height 40%" "--layout=reverse" ];
    };

    # Adjust pbcopy for Linux if possible, or make it conditional
    # This is a bit tricky as pbcopy is a command, not a fzf option directly.
    # The binding itself is fine, but the command inside needs to be cross-platform.
    # One way is to define a script that handles clipboard copy based on OS.
    # For now, will leave as is and assume user has a `pbcopy` equivalent on Linux if needed,
    # or this feature might only fully work on macOS.
  };
}
