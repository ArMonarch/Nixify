{pkgs, ...}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.corePackages = with pkgs; [
    brightnessctl
    fuzzel
    playerctl
    swaybg
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  systemd.user.services."swaybg" = {
    name = "swaybg.service";
    description = "Wallpaper tool for Wayland compositors";

    unitConfig = {
      After = "niri.service";
      Requisite = "niri.service";
    };

    serviceConfig = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '%h/Pictures/Wallpapers/default.jpg'";
      Restart = "on-failure";
    };
  };
}
