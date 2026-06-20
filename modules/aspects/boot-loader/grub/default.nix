###################################################
# GRUB boot-loader configuration for NixOS (enables GRUB with OS prober, disables systemd-boot)
###################################################
{
  # enable and default configurations for grub boot-loader
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  # disable systemd-boot
  boot.loader.systemd-boot.enable = false;
}
