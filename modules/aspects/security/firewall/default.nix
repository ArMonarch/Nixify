###################################################
# Enables the NixOS firewall using the nftables backend
###################################################
{
  networking.firewall = {
    enable = true;
    backend = "nftables";
  };
}
