###################################################
# Enables Nix store auto-optimisation and flakes/nix-command experimental features for NixOS
###################################################
{inputs, ...}: {
  # Enable Flake Support
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # The global registry hands out unpinned nixpkgs refs that bypass the
      # system pin below and drag in a second nixpkgs.
      flake-registry = "";
    };

    # Ad-hoc `nix shell nixpkgs#…` reuses the system's nixpkgs, already in the store.
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Legacy `nix-shell -p` resolves through the same pin; no channels behind it.
    channel.enable = false;
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };
}
