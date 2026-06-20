###################################################
# Enables Nix store auto-optimisation and flakes/nix-command experimental features for NixOS
###################################################
{
  # Enable Flake Support
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
