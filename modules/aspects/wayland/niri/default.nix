{pkgs, ...}: {
  programs.niri = {
    enable = true;
    useNautilus = true;
  };

  environment.corePackages = with pkgs; [
    brightnessctl
    fuzzel
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
    nautilus
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  systemd.user.services."swaybg" = {
    name = "swaybg.service";
    description = "Wallpaper tool for Wayland compositors";

    unitConfig = {
      After = "niri.service";
      Requires = "niri.service";
      PartOf = "niri.service";
    };

    serviceConfig = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '%h/Pictures/Wallpapers/default.jpg'";
      Restart = "on-failure";
    };

    wantedBy = ["graphical-session.target"];
  };
}
