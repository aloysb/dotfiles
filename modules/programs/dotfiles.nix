{ lib, config, pkgs, specialArgs, ... }:

let
  cfg = config.modules.programs.dotfiles;
  homeDir = specialArgs.home-directory;
  dotfilesSrc = specialArgs.dotfiles; # This is the ./dotfiles directory from flake root
  scriptsSrc = specialArgs.userScripts; # This is the ./scripts directory from flake root

  # Helper to create a symlink, ensuring target directory exists
  mkSymlink = targetPath: sourcePath: {
    "${homeDir}/${targetPath}" = {
      source = "${dotfilesSrc}/${sourcePath}";
      # force = true; # Use if you need to overwrite existing files/symlinks
      # recursive = true; # If linking directories with content (though source usually implies this)
    };
  };

  mkScriptSymlink = scriptName: {
    "${homeDir}/.config/scripts/${scriptName}" = { # Target directory for scripts
      source = "${scriptsSrc}/${scriptName}";
      executable = true; # Make the symlink (or rather the target) executable if it's a script
    };
  };

in
{
  options.modules.programs.dotfiles = lib.mkEnableOption "Symlinking of general dotfiles";

  config = lib.mkIf (config.modules.home-manager.enable && cfg.enable) {

    home.file = lib.mkMerge [
      # Replicating symlinks from original home-manager/symlinks.nix
      # Adjust target and source paths as per your actual dotfiles structure within ./dotfiles

      # Aerospace (macOS)
      (lib.mkIf pkgs.stdenv.isDarwin (mkSymlink ".config/aerospace/aerospace.toml" "aerospace/aerospace.toml"))

      # Emacs (Doom)
      (mkSymlink ".config/doom" "emacs/doom")
      # Emacs (Vanilla) - Assuming .emacs.d or .config/emacs is the target
      (mkSymlink ".config/emacs" "emacs/vanilla") # Or ".emacs.d" if preferred

      # Hyprland
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/hypr/hyprland.conf" "hypr/hyprland.conf"))
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/hypr/hyprpaper.conf" "hypr/hyprpaper.conf"))
      # Note: hyprpaper.conf in original home.nix was using pkgs.substituteAll.
      # If substitutions are needed, this symlink approach might need adjustment,
      # or the hyprpaper module should handle its config file with substitutions.
      # For now, direct symlink.

      # Kanata (Linux)
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/kanata/kanata.kbd" "kanata/kanata.kbd"))

      # Lazygit
      (mkSymlink ".config/lazygit/config.yml" "lazygit/config.yml")

      # Neovim (nvim)
      (mkSymlink ".config/nvim" "nvim") # This links the entire nvim config directory

      # Rofi (Linux)
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/rofi/config.rasi" "rofi/config.rasi"))
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/rofi/nord.rasi" "rofi/nord.rasi")) # Theme

      # Wallpapers (if you want them symlinked into .config or similar)
      # Example: mkSymlink ".config/wallpapers" "wallpapers"
      # The original hyprpaper config directly referenced paths within .config/wallpapers,
      # so this module should ensure those wallpapers are placed correctly.
      # For now, let's symlink the directory.
      (mkSymlink ".config/wallpapers" "wallpapers")


      # Waybar (Linux)
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/waybar/config.jsonc" "waybar/config.jsonc"))
      (lib.mkIf pkgs.stdenv.isLinux (mkSymlink ".config/waybar/style.css" "waybar/style.css"))

      # Wezterm
      (mkSymlink ".config/wezterm" "wezterm") # Links the entire wezterm config directory

      # Zsh - .p10k.zsh if it's in dotfiles repository and not generated
      # (mkSymlink ".p10k.zsh" "zsh/.p10k.zsh") # Example if you have it under zsh/ in dotfiles repo

      # Aider config files
      (mkSymlink ".aider.config.yml" "aider/.aider.config.yml") # Assuming you move aider configs into ./dotfiles/aider/
      (mkSymlink ".aider.perso.config.yml" "aider/.aider.perso.config.yml")


      # Scripts from ./scripts directory passed as specialArgs.userScripts
      # These were previously added to sessionPath. Symlinking them to a known bin dir is also an option.
      # Example: if you want all scripts from ./scripts to be symlinked into ~/.local/bin or ~/.config/scripts
      # This requires listing them or iterating over them if Nix can do that at evaluation time (tricky).
      # For now, specific scripts from original config:
      (mkScriptSymlink "backup")
      (mkScriptSymlink "bundleid")
      (mkScriptSymlink "compress_gh")
      (mkScriptSymlink "psc")
      (mkScriptSymlink "sc")
      (mkScriptSymlink "tlscp-start")
    ];

    # Ensure the target directory for scripts exists
    home.xdg.enable = true; # Ensures XDG directories like .config are there
    home.file."${homeDir}/.config/scripts" = {
      source = lib.mkSourceByPath "${homeDir}/.config/scripts"; # Ensures directory exists
      recursive = true; # Should be a directory
      # Ensure it's only created, not a symlink itself unless that's intended.
      # Using an empty source with `lib.mkSourceByPath` or similar to just ensure directory.
      # A simpler way if just ensuring directory:
      # text = ""; # Creates an empty file, not what we want for a directory.
      # Use home.activation to create directory if it doesn't exist.
    };
    # A better way to ensure a directory for scripts:
    # home.activation.ensureScriptDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #  mkdir -p "${homeDir}/.config/scripts"
    # '';
    # For now, sessionPath in zsh.nix already adds `${homeDir}/.config/scripts`

    # The sessionPath in zsh.nix should include `${config.home.homeDirectory}/.config/scripts`
    # if scripts are symlinked there.
  };
}
