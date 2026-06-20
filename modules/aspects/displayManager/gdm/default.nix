###################################################
# GDM display manager configuration for NixOS with Wayland enabled
###################################################
{
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
}
