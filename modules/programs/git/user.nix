{
  lib,
  config,
  pkgs,
  specialArgs,
  ...
}: let
  cfg = config.modules.programs.git;
  username = specialArgs.username; # Get username from specialArgs passed from flake
  userEmail = "aloysberger@gmail.com"; # As per original config, can be made an option
in {
  options.modules.programs.git.enable = lib.mkEnableOption "Git version control";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = username; # Use the abstracted username
      userEmail = userEmail; # Use the defined email
      aliases = {
        oops = "commit --amend --no-edit";
      };
      delta = {
        enable = true;
        # Options for delta can be set here if needed
        # options = {
        #   dark = true; # Example, if your terminal is dark
        # };
      };
      extraConfig = {
        pull.rebase = true;
        push.default = "upstream"; # Or "current" or other preferred default
        core = {
          editor = "nvim"; # Assuming nvim is the editor of choice
          whitespace = "trailing-space,space-before-tab";
        };
        rebase = {
          autostash = true;
        };
        # GPG signing key - this should ideally be configured dynamically
        # For now, using the hardcoded one from your config.
        user.signingkey = "501A50921536CA05";
        commit.gpgSign = true; # Enable commit signing
        diff = {
          algorithm = "histogram";
        };
        rerere = {
          enabled = true;
        };
        log = {
          abbrevCommit = true;
          date = "iso";
        };
        url = {
          "git@github.com:" = {
            insteadOf = "gh:";
          };
        };
      };
    };

    home.packages = with pkgs; [
      gh # GitHub CLI
      delta # For delta
      pre-commit # For pre-commit hooks
      gitleaks # For secret scanning
    ];

    # Ensure GPG agent is set up if commit signing is enabled
    # This is often handled by a gpg module or system-level gpg agent setup
    # For Home Manager, it could be:
    # programs.gnupg.agent = lib.mkIf config.programs.git.extraConfig.commit.gpgSign {
    #   enable = true;
    #   enableSSHSupport = true; # Common to enable this as well
    # };
  };
}
