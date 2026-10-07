{
  ladybird,
  rustPlatform,
  # The `ladybird` flake input (master), so `nix flake update ladybird` bumps it.
  src,
}:
# Reuse nixpkgs' recipe; it pins the deps master expects (ICU 78, pdf.js, wuffs 0.3).
ladybird.overrideAttrs {
  # No release tags yet, so pin the version to the input's commit.
  version = "0-unstable-${src.shortRev}";
  inherit src;
  cargoDeps = rustPlatform.importCargoLock {lockFile = "${src}/Cargo.lock";};
}
