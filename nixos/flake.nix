{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    cursor.url = "github:omarcresp/cursor-flake/main";
  };

  outputs = {
    self,
    nixpkgs,
    cursor,
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ({pkgs, ...}: {
          environment.systemPackages = [cursor.packages.${pkgs.system}.default];
        })
      ];
    };
  };
}
