###################################################
# PipeWire audio server (ALSA/PulseAudio) configuration for NixOS
###################################################
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  services.pulseaudio.enable = false;
}
