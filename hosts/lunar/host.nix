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
      ./user.nix
    ]
    ++ [
      ./boot-loader.nix
    ];

  system.stateVersion = "25.05";
}
