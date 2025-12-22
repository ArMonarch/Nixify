{ lib, pkgs, ... }:
let
  cmake = pkgs.cmake;
  chafa = pkgs.chafa;
  imagemagick = pkgs.imagemagick;
  installShellFiles = pkgs.installShellFiles;
  makeBinaryWrapper = pkgs.makeBinaryWrapper;
  pkg-config = pkgs.pkg-config;
  python3 = pkgs.python311;
  yyjson = pkgs.yyjson;
  zfs = pkgs.zfs;
  zlib = pkgs.zlib;

  inherit lib;
  inherit pkgs;
  stdenv = pkgs.stdenv;
  fetchFromGitHub = pkgs.fetchFromGitHub;
  versionCheckHook = pkgs.versionCheckHook;
in
{
  default = pkgs.hello;
  fastfetch = import ./fastfetch.nix {
    inherit cmake;
    inherit chafa;
    inherit imagemagick;
    inherit installShellFiles;
    inherit makeBinaryWrapper;
    inherit pkg-config;
    inherit python3;
    inherit yyjson;
    inherit zfs;
    inherit zlib;

    inherit lib;
    inherit stdenv;
    inherit fetchFromGitHub;
    inherit versionCheckHook;
  };
}
