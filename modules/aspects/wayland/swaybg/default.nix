{pkgs, ...}: {
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
