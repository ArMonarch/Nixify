###################################################
# OpenSSH daemon configuration for NixOS
###################################################
{
  services.openssh = {
    enable = true;
    ports = [22];
  };
}
