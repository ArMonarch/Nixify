{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    chromium.override
    {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    }
  ];

  programs.chromium = {
    enable = true;
  };
}
