self: super: {
  bitwarden-cli =
    super.callPackage (
      (import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz";
        sha256 = "1b4f7d9f3f5f2c6c0c5c1f9d4b0b2b9e0e4c2e3e2f1f0d0c1b";
      })).pkgs.bitwarden-cli
    )
    {};
}
