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

  # Show the fetch once when a terminal first opens. NIXFETCH_SHOWN is exported,
  # so it is inherited across `exec fish` and into subshells: nixfetch only runs
  # for the first interactive shell of a fresh terminal, never on reloads.
  programs.fish.interactiveShellInit = lib.modules.mkIf config.programs.fish.enable ''
    if not set -q NIXFETCH_SHOWN
      set -gx NIXFETCH_SHOWN 1
      nixfetch
    end
  '';
}
