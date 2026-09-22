{pkgs, ...}: {
  imports = [
    ./fs.nix
    ./user.nix
  ];

  time.timeZone = "Asia/Kathmandu";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixify.aspect.programs.ghostty.settings = {
    window-decoration = "server";
  };

  # The release of the first install; leave it alone.
  system.stateVersion = "25.11";
}
