# this layer contains bare-minimum config for a hardened container image
{
  pkgs,
  n2cPkgs,
}:
n2cPkgs.nix2container.buildLayer {
  copyToRoot = import ./env-default.nix {inherit pkgs;};
}
