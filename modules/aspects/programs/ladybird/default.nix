###################################################
# Ladybird browser for NixOS
#
# Independent engine (LibWeb/LibJS), still pre-alpha,
# so it sits beside a daily-driver browser.
###################################################
{inputs', ...}: {
  # From unstable: the 26.05 snapshot is flagged insecure (CVE-2026-58592).
  environment.systemPackages = [inputs'.nixpkgs-unstable.legacyPackages.ladybird];
}
