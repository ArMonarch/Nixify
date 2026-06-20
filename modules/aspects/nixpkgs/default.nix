###################################################
# Allows broken and unfree nixpkgs packages for NixOS
###################################################
{
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };
}
