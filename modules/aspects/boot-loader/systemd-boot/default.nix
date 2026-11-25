###################################################
# systemd-boot boot-loader configuration for NixOS (enables systemd-boot with EFI variables, disables GRUB)
###################################################
{lib, ...}: {
  # make so that boot-loader can touch efi variables
  boot.loader.efi.canTouchEfiVariables = true;

  # enable and default configure for systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Boot menu resolution.
  boot.loader.systemd-boot.consoleMode = lib.mkDefault "auto";

  # Boot menu timeout in seconds.
  boot.loader.timeout = lib.mkDefault 5;

  # Generations kept on the ESP.
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

  # disable grub
  boot.loader.grub.enable = false;
}
