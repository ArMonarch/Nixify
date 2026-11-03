###################################################
# Essential command-line utilities and tools for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    fd
    file
    ripgrep
    tldr
    wget
    yazi
    unzip
  ];
}
