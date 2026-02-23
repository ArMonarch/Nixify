{
  pkgs,
  username,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    fuzzel
    playerctl
    wl-clipboard
    xkeyboard-config
    xwayland-satellite
    nautilus
  ];

  hjem.users.${username}.xdg.config.files = {
    "niri/config.kdl" = {
      type = "copy";
      source = ./niri_config.kdl;
    };
  };
}
