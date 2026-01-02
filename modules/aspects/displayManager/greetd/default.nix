{
  niri ? true,
  plasma ? false,
  hyperland ? false,
}: {
  username,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.lib.getExe pkgs.tuigreet} --cmd=niri";
      };
    };
  };

  assertions = [
    {
      assertion = niri == true || plasma == true || hyperland == true;
      message = "any one {`hyperland` `niri` `plasma`} wayland compositer must be enabled";
    }
  ];
}
