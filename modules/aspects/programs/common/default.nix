{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    fd
    file
    htop
    ripgrep
    tldr
    wget
    yazi
    unzip
  ];
}
