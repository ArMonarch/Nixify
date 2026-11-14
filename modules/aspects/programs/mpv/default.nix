###################################################
# mpv video player for NixOS
###################################################
{
  pkgs,
  username,
  ...
}:
let
  # mpris lets niri's playerctl media keys reach mpv. uosc replaces the
  # built-in osc with a full control bar and menus; thumbfast feeds it seek
  # previews. The nixpkgs wrapper already puts yt-dlp on mpv's PATH.
  package = pkgs.mpv.override {
    scripts = with pkgs.mpvScripts; [
      mpris
      uosc
      thumbfast
    ];
  };

  config = pkgs.writeText "mpv.conf" ''
    # uosc draws its own controls and seek bar
    osc=no
    osd-bar=no

    profile=high-quality
    vo=gpu-next
    # auto-safe only picks decoders known to be correct, else falls back to cpu
    hwdec=auto-safe

    # stay on the last frame instead of closing, and resume where playback stopped
    keep-open=yes
    save-position-on-quit=yes

    # load subtitles named like the video, even with a suffix
    sub-auto=fuzzy

    slang=en,eng,english
    subs-with-matching-audio=yes
  '';

  # uosc hides everything until the cursor nears an edge. Pin the bar like
  # vlc: always shown in a window or when paused, mouse-revealed fullscreen.
  uoscConf = pkgs.writeText "uosc.conf" ''
    timeline_persistency=windowed,paused
    controls_persistency=windowed,paused
    volume_persistency=windowed,paused
  '';
in
{
  environment.systemPackages = [ package ];

  hjem.users.${username}.xdg.config.files = {
    "mpv/mpv.conf" = {
      type = "symlink";
      source = config;
    };
    "mpv/script-opts/uosc.conf" = {
      type = "symlink";
      source = uoscConf;
    };
  };
}
