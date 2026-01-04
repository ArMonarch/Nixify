{
  niri ? false,
  hyprland ? false,
}: {pkgs, ...}: let
  compositor_startcmd =
    if niri == true
    then "niri-session"
    else if hyprland == true
    then "hyprland"
    else "";
  theme = "--theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red;'";
  time_format = "--time --time-format '%I:%M %p | %a • %h | %F'";
in {
  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 1;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --container-padding 2 ${time_format} --cmd ${compositor_startcmd}";
        user = "greeter";
      };
    };
  };

  environment.corePackages = with pkgs; [
    tuigreet
  ];

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  assertions = [
    {
      assertion = niri == true || hyprland == true;
      message = "any one {`hyperland` `niri` `plasma`} wayland compositer must be enabled";
    }
  ];
}
