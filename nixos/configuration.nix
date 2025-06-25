{
  pkgs,
  inputs, # Injected from specialArgs
  username, # Injected from specialArgs
  home-directory, # Injected from specialArgs
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops # Import sops-nix module
  ];

  # sops-nix configuration
  sops.defaultSopsFile = ../../secrets.yaml; # Path to the secrets file from flake root
  sops.secrets.restic_password = { # Example secret
    # No need to specify sopsFile if defaultSopsFile is set and key matches
    # This will make the decrypted content of 'restic_password' from secrets.yaml
    # available as a file at /run/secrets/restic_password
    # The actual file path can be customized if needed.
  };
  # If you want to use it for user password:
  # sops.secrets.user_password_aloys = {
  #   key = "userPasswords/aloys"; # Assumes 'userPasswords.aloys: <hashed_password_ENC>' in secrets.yaml
  # };
  # users.users.${username}.passwordFile = config.sops.secrets.user_password_aloys.path;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelModules = ["uinput"];

  # Define the custom systemd service
  #systemd.services.kanata = {
  #   description = "Kanata Service";
  #   after = ["local-fs.target"];
  #   requires = ["local-fs.target"];
  #   serviceConfig = {
  #     ExecStartPre = "/usr/bin/modprobe uinput";
  #     ExecStart = "/usr/bin/kanata -c /etc/kanata/pocket3.kbd";
  #     Restart = "no";
  #   };
  #   wantedBy = ["sysinit.target"];
  # };
  # nixpkgs.overlays are now managed in flake.nix

  hardware.graphics.enable = true;
  services.libinput.enable = true;
  hardware = {
    #pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default
  networking = {
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  environment = {
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  programs = {
    vim = {
      enable = true;
      defaultEditor = true;
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    git = {
      enable = true;
      config = {
        user.name = "aloysb";
        user.email = "aloysberger@gmail.com";
      };
    };
    zsh.enable = true;

    hyprland = {
      enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
      };
      rootless = {
        enable = true;
      };
    };
  };
  users = {
    groups.uinput = {};
    users = {
      ${username} = { # Use abstracted username
        isNormalUser = true;
        extraGroups = ["wheel" "nixos" "docker" "uinput" "input"];
        initialPassword = "password"; # This should be managed by sops-nix or removed
        home = home-directory; # Ensure home directory is set
        packages = with pkgs; [
          gh
        ];
        shell = pkgs.zsh;
      };
    };
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #environment.systemPackages = [
  #	cursor.packages.${pkgs.system}.default
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
