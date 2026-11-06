# this derivation contains bare-minimum config for a hardened container image
{
  pkgs,
  lib ? pkgs.lib,
}: let
  passwd = pkgs.writeText "passwd" ''
    root:x:0:0:root:/root:/bin/bash
    nobody:x:65534:65534:nobody:/nonexistent:/bin/nologin
  '';
  group = pkgs.writeText "group" ''
    root:x:0:
    nobody:x:65534:
  '';
  shadow = pkgs.writeText "shadow" ''
    root:*::::::
    nobody:*::::::
  '';

  osRelease = pkgs.writeText "os-release" ''
    NAME="Not NixOS"
    VARIANT="hardened-container"
    ID="hardened"
    ID_LIKE="nixos"
  '';
in
  pkgs.runCommandWith {
    name = "root";
  } ''
    mkdir -p $out/root

    mkdir -p $out/etc

    # create a dummy os-release
    cp ${osRelease} $out/etc/os-release

    # create the usual security files
    cp ${passwd} $out/etc/passwd
    cp ${group} $out/etc/group
    cp ${shadow} $out/etc/shadow
  ''
