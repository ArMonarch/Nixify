###################################################
# GRUB boot-loader configuration for NixOS (enables GRUB with OS prober, disables systemd-boot)
###################################################
{lib, ...}: {
  # enable and default configurations for grub boot-loader
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  # Boot menu timeout in seconds.
  boot.loader.timeout = lib.mkDefault 5;

  # disable systemd-boot
  boot.loader.systemd-boot.enable = false;
}
