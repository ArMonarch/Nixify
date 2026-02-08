{
  services.pulseaudio = {
    enable = true;
  };

  security.rtkit.enable = true;

  services.pipewire.enable = false;
}
