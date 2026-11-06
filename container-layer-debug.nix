# this layer contains useful debugging tools for the container environment
{
  pkgs,
  n2cPkgs,
}:
n2cPkgs.nix2container.buildLayer {
  copyToRoot = import ./env-debug.nix {inherit pkgs;};
}
