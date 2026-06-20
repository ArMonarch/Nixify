###################################################
# Power management (power-profiles-daemon and UPower) configuration for NixOS
###################################################
{
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
