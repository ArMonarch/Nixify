{pkgs, ...}: {
  environment.corePackages = with pkgs; [rmpc];
}
