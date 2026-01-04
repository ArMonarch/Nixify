{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.corePackages = with pkgs; [
    brightnessctl
    fuzzel
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
