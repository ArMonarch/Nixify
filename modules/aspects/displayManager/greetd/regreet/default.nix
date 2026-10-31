###################################################
# greetd display manager with the ReGreet GTK4 greeter running inside cage
###################################################
{
  # Sets up services.greetd itself; sessions come from wayland-sessions,
  # so niri is listed without naming it here.
  programs.regreet = {
    enable = true;
    settings = {
      GTK.application_prefer_dark_theme = true;
      widget.clock.format = "%B %d, %Y | %H:%M";
    };
  };
}
