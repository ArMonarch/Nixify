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
in {
  environment.systemPackages = [pkgs.aseprite];

  # Aseprite owns aseprite.ini and rewrites it on exit, so pick the flavour
  # once in Preferences → Theme.
  hjem.users.${username}.xdg.config.files = lib.listToAttrs (lib.concatMap extension flavours);
}
