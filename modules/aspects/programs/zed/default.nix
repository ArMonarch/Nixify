###################################################
# Zed editor installation for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zed-editor
  ];
}
