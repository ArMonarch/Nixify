###################################################
# GRUB EFI support configuration for NixOS (enables EFI variables and EFI installation)
###################################################
{
  # make so that boot-loader can touch efi variables
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = ["nodev"];
}
