# Aloys' Dotfiles & System Configurations

This repository contains my personal dotfiles and system configurations, managed primarily with [Nix](https://nixos.org/), [Home Manager](https://github.com/nix-community/home-manager), and [Nix-Darwin](https://github.com/LnL7/nix-darwin).

## Overview

The main goal of this repository is to provide a reproducible and version-controlled setup for my development environments across macOS and NixOS systems.

Key components:

*   **`flake.nix`**: The entry point for Nix, defining packages, NixOS modules, Home Manager configurations, and Nix-Darwin setups.
*   **`dotfiles/`**: Contains application-specific configurations (e.g., Neovim, WezTerm, Emacs). These are typically symlinked into place by Home Manager.
*   **`darwin/`**: Specific configurations for macOS systems managed by `nix-darwin`.
*   **`nixos/`**: Specific configurations for NixOS systems.
*   **`home-manager/`**: Shared Home Manager configurations applicable to both macOS and NixOS.
*   **`taskfile.yml`**: A task runner file to simplify common operations like applying configurations.

## Using Tasks with `task`

This repository uses [Task](https://taskfile.dev/) as a command runner, similar to `make` or `just`. It helps automate common development and system management workflows.

### Installation

To use the tasks defined in `taskfile.yml`, you first need to install `task`.

**macOS (Homebrew):**
```bash
brew install go-task/tap/go-task
```

**Nix/NixOS:**
If you have Nix installed, you can install it via `nix-env` or include it in your Nix configuration:
```bash
nix-env -iA nixpkgs.task
```
Or add `pkgs.task` to your `home.packages` or `environment.systemPackages`.

For other installation methods (Linux, Windows, binaries), please refer to the [official Task installation guide](https://taskfile.dev/installation/).

### Available Tasks

To list all available tasks, run:
```bash
task
```
or
```bash
task --list-all
```

Here are some of the main tasks:

*   **`task hms`**:
    *   Description: Run `home-manager switch` for the current system.
    *   Usage: `task hms`
    *   Details: This task applies the Home Manager configuration defined in `home-manager/home.nix` and the system-specific flake output (e.g., `.#darwin` or `.#nixos`). It infers your system type (e.g., `darwin`, `linux`) using `uname`.

*   **`task darwin-switch`**:
    *   Description: Run `nix-darwin rebuild switch` (macOS only).
    *   Usage: `task darwin-switch`
    *   Details: This task applies the Nix-Darwin system configuration defined in `darwin/configuration.nix`. It will only run if your system is identified as `darwin`.

*   **`task nvim-reload`**:
    *   Description: Reloads the Neovim configuration by reinstalling its Nix profile.
    *   Usage: `task nvim-reload`
    *   Details: This is useful when you've made changes to the Neovim configuration managed by Nix and want to apply them without a full `home-manager switch`. It removes the existing profile and installs the one defined in `dotfiles/nvim/flake.nix`.

*   **`task nixos-switch`**:
    *   Description: Run `nixos-rebuild switch` (Linux/NixOS only).
    *   Usage: `task nixos-switch`
    *   Details: This task applies the NixOS system configuration. It will only run if your system is identified as `Linux`. It requires `sudo` privileges.

### System Specific Tasks

The `hms`, `darwin-switch`, and `nixos-switch` tasks use a variable `USER_SYSTEM`. This variable is automatically determined by running `uname | tr '[:upper:]' '[:lower:]'` (e.g., `darwin` for macOS, `linux` for Linux-based systems). The value of `USER_SYSTEM` should correspond to a hostname defined in your `flake.nix` outputs (e.g., `nixosConfigurations.your-hostname` or `darwinConfigurations.your-hostname`).

For example, if your `flake.nix` has:
```nix
{
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.myNixosBox = nixpkgs.lib.nixosSystem { ... };
    darwinConfigurations.myMac = inputs.nix-darwin.lib.darwinSystem { ... };
    homeConfigurations.user = inputs.home-manager.lib.homeManagerConfiguration { ... };
  };
}
```
Then `USER_SYSTEM` should resolve to `myNixosBox` on that NixOS machine, or `myMac` on that Mac. The tasks will then form the correct flake URI like `.#myNixosBox` or `.#myMac`.

If the automatically determined value is not correct, or you want to target a different configuration defined in your flake, you can override `USER_SYSTEM` when running a task:
```bash
task hms USER_SYSTEM=your-flake-host-identifier
task darwin-switch USER_SYSTEM=your-darwin-flake-identifier
task nixos-switch USER_SYSTEM=your-nixos-flake-identifier
```
Replace `your-flake-host-identifier`, `your-darwin-flake-identifier`, or `your-nixos-flake-identifier` with the actual Nix host name defined in your `flake.nix`.

## Nix Flakes

This repository is structured as a Nix Flake.

*   **To build and activate Home Manager for your user:**
    ```bash
    nix run home-manager/master -- switch --flake .#your-username@your-hostname
    ```
    (Or use the `task hms` command)

*   **To rebuild a NixOS system:**
    ```bash
    sudo nixos-rebuild switch --flake .#your-nixos-hostname
    ```

*   **To rebuild a Nix-Darwin system:**
    ```bash
    nix run nix-darwin/master#darwin-rebuild -- switch --flake .#your-darwin-hostname
    ```
    (Or use the `task darwin-switch` command if on macOS)

Make sure to replace `your-username@your-hostname`, `your-nixos-hostname`, or `your-darwin-hostname` with the appropriate values defined in your `flake.nix`. The tasks in `taskfile.yml` attempt to simplify this by inferring the system.Tool output for `overwrite_file_with_block`:
