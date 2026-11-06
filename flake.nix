{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };
  inputs.nix2container = {
    url = "github:nlewo/nix2container";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nix2container,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        n2cPkgs = nix2container.packages.${system};
      in rec {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
          ];
        };

        packages._cacheTheseInputs = pkgs.buildEnv {
          name = "cache-these-inputs";
          paths = [
            n2cPkgs.nix2container-bin
            n2cPkgs.skopeo-nix2container
          ];
        };
        packages._debugEnv = import ./env-debug.nix {inherit pkgs;};
        packages._defaultEnv = import ./env-default.nix {inherit pkgs;};

        packages.hello = import ./container.nix {
          inherit pkgs n2cPkgs;
          name = "hello";
        };
        packages.hello-debug = import ./container.nix {
          inherit pkgs n2cPkgs;
          name = "hello";
          includeDebug = true;
        };

        packages.murmur = import ./container.nix {
          inherit pkgs n2cPkgs;
          name = "murmur";
          pkg = pkgs.murmur;
          args = ["-fg"];
        };
        packages.murmur-debug = import ./container.nix {
          inherit pkgs n2cPkgs;
          name = "murmur";
          pkg = pkgs.murmur;
          includeDebug = true;
        };

        # CI scripts:
        packages.task-build = pkgs.writeShellScriptBin "task-build" ''
          for ctr in hello hello-debug murmur murmur-debug; do
            echo ">>> building $ctr"
            nix run ".#''${ctr}.copyToDockerDaemon"
          done
        '';
      }
    );
}
