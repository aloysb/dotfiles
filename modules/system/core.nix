{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    agenix-cli
  ];
}
