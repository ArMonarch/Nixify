{
  # make so that boot-loader can touch efi variables
  boot.loader.efi.canTouchEfiVariables = true;

  # enable and default configure for systemd-boot
  boot.loader.systemd-boot.enable = true;

  # disable grub
  boot.loader.grub.enable = false;
}
