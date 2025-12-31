{
  # make so that boot-loader can touch efi variables
  boot.loader.efi.canTouchEfiVariables = true;

  # enable and default configurations for grub boot-loader
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    devices = ["nodev"];
  };

  # disable systemd-boot
  boot.loader.systemd-boot.enable = false;
}
