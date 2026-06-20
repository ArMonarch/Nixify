###################################################
# Firefox Nightly with WebGPU support for NixOs
###################################################
{
  pkgs,
  inputs',
  ...
}: {
  programs.firefox = {
    enable = true;
    package = inputs'.firefox-nightly.packages.firefox-nightly-bin;
  };
}
