{
  # each filesystem(fs), hardware, users are compalsary for every host profile
  # as it entails important details about the host system and these configuration
  # are different for each hosts and cannot be generalized. on the other hand
  # every other .nix are tweaks on their respective aspects configurations, tweaking
  # configurations that must vary from the aspect while using most of the aspects
  imports =
    [
      ./fs.nix
      ./hardware.nix
      ./user # this also include home setup with hjem
    ]
    ++ [
      ./stylix.nix
    ];

  boot.loader.timeout = 10;

  system.modules.shell.fish.features.integrations = ["eza" "git"];

  hardware.nvidia = {
    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Kathmandu";
  system.stateVersion = "25.05";
}
