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
}
