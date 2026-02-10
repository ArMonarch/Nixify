{
  # make so that boot-loader can touch efi variables
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = ["nodev"];
}
