{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    fd
    findutils
    htop
    btop
    ripgrep
    tldr
    wget
    yazi
    unzip
  ];
}
