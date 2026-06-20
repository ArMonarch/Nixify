###################################################
# SDDM display manager configuration for NixOS with Wayland enabled
###################################################
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
