###################################################
# Aseprite sprite editor for NixOS
#
# nixpkgs marks it unfree (source-available EULA),
# so Hydra never caches it and it builds locally.
# Needs the `nixpkgs` aspect for allowUnfree.
###################################################
{
  lib,
  pkgs,
  username,
  ...
}: let
  # Vendored from catppuccin/aseprite@c4c95e3 (MIT). The per-flavour copies,
  # not themes/all, since only these carry the 2026-08 Aseprite update.
  flavours = ["frappe" "latte" "macchiato" "mocha"];

  # Copied file by file: aseprite's scan skips a symlinked extension directory,
  # and hjem's copy only takes files. Writable and never clobbered, so whatever
  # aseprite changes in them survives a rebuild.
  extension = flavour: let
    name = "catppuccin-theme-${flavour}";
  in
    map (file:
      lib.nameValuePair "aseprite/extensions/${name}/${file}" {
        type = "copy";
        source = ./${name}/${file};
        permissions = "0644";
        clobber = false;
      })
    ["package.json" "theme.xml" "sheet.png"];

  # macOS-style editing on Super, added next to the Ctrl defaults. "Super" is
  # aseprite's Linux name for the key (src/ui/shortcut.cpp).
  keys = pkgs.writeText "user.aseprite-keys" ''
    <?xml version="1.0" encoding="utf-8"?>
    <keyboard version="1">
      <commands>
        <key command="Copy" shortcut="Super+C" />
        <key command="Cut" shortcut="Super+X" />
        <key command="Paste" shortcut="Super+V" />
        <key command="MaskAll" shortcut="Super+A" />
        <key command="Undo" shortcut="Super+Z" />
        <key command="Redo" shortcut="Super+Shift+Z" />
        <key command="Redo" shortcut="Super+Y" />
      </commands>
    </keyboard>
  '';
in {
  environment.systemPackages = [pkgs.aseprite];

  # Aseprite owns aseprite.ini and rewrites it on exit, so pick the flavour
  # once in Preferences → Theme.
  hjem.users.${username}.xdg.config.files =
    lib.listToAttrs (lib.concatMap extension flavours)
    // {
      # Writable so Edit → Keyboard Shortcuts can save; hjem only rewrites it
      # when the keys above change.
      "aseprite/user.aseprite-keys" = {
        type = "copy";
        source = keys;
        permissions = "0644";
        clobber = true;
      };
    };
}
