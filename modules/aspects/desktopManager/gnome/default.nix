###################################################
# GNOME desktop environment configuration for NixOS
###################################################
{
  imports = [../common.nix];

  services.desktopManager.gnome = {
    enable = true;
  };
}
