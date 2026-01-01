{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    curl
    findutils
    htop
    ripgrep
    tldr
    wget
  ];

  environment.defaultPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
