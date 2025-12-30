{lib, ...}: let
  inherit (lib) mkDefault;

  # shorthand alias to `lib.nixosSystem`
  mkSystem = lib.nixosSystem;
in {
  inherit mkSystem;

  mkNixosSystem = {
    hostname,
    username,
    inputs,
    modules,
    system,
    ...
  } @ args:
    mkSystem {
      inherit system;
      specialArgs = {
        inherit hostname username inputs;
      };
      modules =
        [
          {
            networking.hostName = "${username}_${hostname}";
            nixpkgs.hostPlatform = mkDefault system;
          }
        ]
        ++ modules;
    };
}
