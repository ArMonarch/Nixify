{
  networking.firewall = {
    enable = true;
    backend = "nftables";
  };
}
