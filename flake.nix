{
  description = "Snowfall DotBox";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs";

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;

        src = ./.;
      };
    in
    lib.mkFlake {
      overlay-package-namespace = "snowfallorg";

      alias = {
        packages.default = "dotbox";
        shells.default = "dotbox";
      };

      outputs-builder = channels: {
        apps = rec {
          default = dotbox;

          dotbox = lib.flake-utils-plus.mkApp {
            exePath = "/bin/dotbox";
            drv = channels.nixpkgs.snowfallorg.dotbox;
          };
        };
      };
    };
}
