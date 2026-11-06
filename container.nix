{
  # the usual:
  pkgs,
  lib ? pkgs.lib,
  n2cPkgs,
  # container-specific settings:
  name ? "hello",
  pkg ? pkgs.hello,
  entrypoint ? null,
  args ? [],
  extraPackages ? [],
  includeDebug ? false,
}:
n2cPkgs.nix2container.buildImage {
  name = "git.sapphiccode.net/SapphicCode/declarative-containers/${name}";
  tag = "v${pkg.version}${lib.optionalString includeDebug "-debug"}";
  layers =
    [
      (import ./container-layer-default.nix {inherit pkgs n2cPkgs;})
    ]
    ++ lib.optional includeDebug (import ./container-layer-debug.nix {inherit pkgs n2cPkgs;});
  config = {
    # user can override the entrypoint with bash in a debug image if they want to get a shell
    Entrypoint =
      [
        (lib.getExe pkgs.tini)
        (
          if entrypoint != null
          then (lib.getExe' pkg entrypoint)
          else (lib.getExe pkg)
        )
        "--"
      ]
      ++ args;
    User = "nobody";
    Labels = {
      "org.opencontainers.image.source" = "https://git.sapphiccode.net/SapphicCode/containers";
      "org.opencontainers.image.version" = "${pkg.version}";
    };
  };
}
