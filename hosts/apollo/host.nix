{
  imports = [
    ./fs.nix
    ./hardware.nix
    ./user.nix
  ];

  boot.loader.timeout = 15;
  # list grub devices incase if grub is used
  boot.loader.grub.devices = ["/dev/vda"];

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Kathmandu";
  system.stateVersion = "25.05";
}
