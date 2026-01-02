{
  # enable and default configurations for grub boot-loader
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  # disable systemd-boot
  boot.loader.systemd-boot.enable = false;
}
