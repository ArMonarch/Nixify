###################################################
# greetd display manager with tuigreet greeter launching the Niri session
###################################################
{pkgs, ...}: let
  compositor_startcmd = "niri-session";
  extra_config = "--remember --asterisks --container-padding 2";
  theme = "--theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'";
  time_format = "--time --time-format '%B %d, %Y | %H:%M'";
in {
  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 1;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet ${extra_config} ${time_format} --cmd ${compositor_startcmd} ${theme}";
        user = "greeter";
      };
    };
  };

  # Undocumented but essential, from
  # reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # keeps errors off the greeter screen
    # without these, boot logs spam the greeter screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
