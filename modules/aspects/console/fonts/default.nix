###################################################
# Sets the virtual console font to Terminus for NixOS
###################################################
{pkgs, ...}: {
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v22n.psf.gz";
}
