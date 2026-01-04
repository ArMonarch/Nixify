{
  flake.nixosModules = {
    colorScheme = {
      imports = [./colorScheme/default.nix];
    };
  };
}
