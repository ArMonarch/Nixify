{pkgs, ...}: {
  # fs, hardware and user are compulsory per host; every other setting here
  # is a host-specific tweak on an aspect's defaults.
  imports = [
    ./fs.nix
    ./hardware.nix
    ./user # includes the hjem home setup
  ];

  networking.firewall.enable = true;

  nixify.aspect.programs.ghostty.font = "jetbrains";

  # Ladybird's font fallback lists name these families.
  fonts.packages = [pkgs.dejavu_fonts pkgs.liberation_ttf];

  boot.loader.timeout = 10;

  hardware.nvidia = {
    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Kathmandu";
  system.stateVersion = "26.05";
}
