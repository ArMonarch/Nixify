{
  niri ? false,
  hyprland ? false,
}: {
  username,
  pkgs,
  ...
}: let
  compositor_startcmd =
    if niri == true
    then "niri-session"
    else if hyprland == true
    then "hyprland"
    else "";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.lib.getExe pkgs.tuigreet} --cmd=${compositor_startcmd}";
      };
    };
  };

  assertions = [
    {
      assertion = niri == true || hyprland == true;
      message = "any one {`hyperland` `niri` `plasma`} wayland compositer must be enabled";
    }
  ];
}
