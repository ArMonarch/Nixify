{
  lib,
  pkgs,
  ...
}: let
  # Mac <-> Fusion <-> vmware-user (an X client) <-> X clipboard <-> these
  # bridges <-> Wayland clipboard. xwayland-satellite alone only syncs the two
  # while an X window has keyboard focus, and vmware-user never has one;
  # wl-clipboard uses data-control, which niri allows without focus.
  # Text only. Each side compares before writing, so the two never loop.
  xToWayland = pkgs.writeShellApplication {
    name = "clipboard-x-to-wayland";
    runtimeInputs = with pkgs; [clipnotify xclip wl-clipboard diffutils coreutils];
    text = ''
      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT
      while clipnotify; do
        xclip -o -selection clipboard -t UTF8_STRING >"$tmp/x" 2>/dev/null || continue
        [ -s "$tmp/x" ] || continue
        wl-paste -n -t text >"$tmp/w" 2>/dev/null || : >"$tmp/w"
        cmp -s "$tmp/x" "$tmp/w" || wl-copy <"$tmp/x"
      done
    '';
  };

  waylandToX = pkgs.writeShellApplication {
    name = "clipboard-wayland-to-x";
    runtimeInputs = with pkgs; [xclip diffutils coreutils];
    text = ''
      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT
      cat >"$tmp"
      [ -s "$tmp" ] || exit 0
      xclip -o -selection clipboard -t UTF8_STRING 2>/dev/null | cmp -s - "$tmp" && exit 0
      xclip -selection clipboard -t UTF8_STRING -i "$tmp"
    '';
  };
in {
  # The agent only autostarts in X sessions. Under niri it runs against
  # xwayland-satellite's DISPLAY, which niri exports to user services.
  systemd.user.services.vmware-user = {
    description = "VMware user agent (host clipboard, drag and drop)";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "/run/wrappers/bin/vmware-user-suid-wrapper";
      Restart = "always";
      RestartSec = 2;
    };
  };

  systemd.user.services.clipboard-x-to-wayland = {
    description = "Copy the X clipboard to Wayland";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = lib.getExe xToWayland;
      Restart = "always";
      RestartSec = 2;
    };
  };

  systemd.user.services.clipboard-wayland-to-x = {
    description = "Copy the Wayland clipboard to X";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${lib.getExe waylandToX}";
      Restart = "always";
      RestartSec = 2;
    };
  };
}
