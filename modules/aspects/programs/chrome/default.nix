###################################################
# Google Chrome with VA-API hardware acceleration for NixOS
###################################################
{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.google-chrome.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];
}
