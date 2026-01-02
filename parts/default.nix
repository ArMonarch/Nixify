{
  # explicitly import "parts" of a flake to compose it modularity. This
  # allows to import each part to construct the "final" flake insted of
  # declaring everything from a single, convoluted flake.
  imports = [
    ./lib # extended library built on top of `nixpkgs.lib`
    ./pkgs # per system packages exposed by the flake
    ./nixosModules # nixosModules exposed by this flake
  ];
}
