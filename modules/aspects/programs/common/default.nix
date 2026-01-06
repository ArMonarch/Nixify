{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    curl
    fd
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
