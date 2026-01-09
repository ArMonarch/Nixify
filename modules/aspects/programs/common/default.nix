{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    curl
    fd
    findutils
    htop
    ripgrep
    rsync
    tldr
    wget
    yazi
    unzip
  ];

  environment.defaultPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
