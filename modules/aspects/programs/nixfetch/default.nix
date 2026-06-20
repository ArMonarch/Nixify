{
  config,
  lib,
  inputs',
  ...
}: {
  environment.systemPackages = [
    inputs'.nixfetch.packages.default
  ];

  environment.variables = {
    NIXFETCH_IMAGE = "/home/frenzfries/Project/Nixify/modules/aspects/programs/nixfetch/alice_glasses.png";
  };

  # show the fetch on every interactive fish start
  programs.fish.interactiveShellInit = lib.modules.mkIf config.programs.fish.enable "nixfetch";
}
