{pkgs, ...}: {
  environment.corePackages = with pkgs; [
    vesktop
  ];
}
