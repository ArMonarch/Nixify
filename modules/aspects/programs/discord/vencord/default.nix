{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    (discord.override {withVencord = true;})
  ];
}
