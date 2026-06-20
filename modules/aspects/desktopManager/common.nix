###################################################
# Common desktop environment packages shared across desktop managers
###################################################
{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    libnotify
    wl-clipboard
  ];
}
