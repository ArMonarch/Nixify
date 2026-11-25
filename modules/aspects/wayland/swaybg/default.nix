###################################################
# swaybg Wayland wallpaper systemd user service for NixOS
###################################################
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
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${./wallpapers/forest.jpg}";
      Restart = "on-failure";
    };

    wantedBy = ["graphical-session.target"];
  };
}
