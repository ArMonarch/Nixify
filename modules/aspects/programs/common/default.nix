{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    curl
    eza
    findutils
    git
    htop
    ripgrep
    tldr
    wget
  ];

  environment.defaultPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
