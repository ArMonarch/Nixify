{
  pkgs,
  lib,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = true;
  };

  hardware.graphics.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  services.seatd.enable = true;

  environment.corePackages = with pkgs; [
    niri
    ghostty
    fuzzel
    swaylock
    mako
    swayidle
    vulkan-tools
    mesa
    mesa-demos
  ];
}
