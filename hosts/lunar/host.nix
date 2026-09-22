{
  # fs, hardware and user are compulsory per host; every other setting here
  # is a host-specific tweak on an aspect's defaults.
  imports = [
    ./fs.nix
    ./hardware.nix
    ./user # includes the hjem home setup
  ];

  nixify.aspect.programs.ghostty = {
    font = "jetbrains";
    settings.window-decoration = "server";
  };

  # folke tokyonight night scheme
  colorScheme = {
    base00 = "16161e";
    base01 = "1a1b26";
    base02 = "2f3549";
    base03 = "444b6a";
    base04 = "787c99";
    base05 = "787c99";
    base06 = "cbccd1";
    base07 = "d5d6db";
    base08 = "f7768e";
    base09 = "ff9e64";
    base0A = "e0af68";
    base0B = "41a6b5";
    base0C = "7dcfff";
    base0D = "7aa2f7";
    base0E = "bb9af7";
    base0F = "d18616";
  };

  boot.loader.timeout = 10;

  hardware.nvidia = {
    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Kathmandu";
  system.stateVersion = "25.05";
}
