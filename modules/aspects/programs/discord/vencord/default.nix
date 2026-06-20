###################################################
# Discord client with the Vencord mod enabled for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (discord.override {withVencord = true;})
  ];
}
