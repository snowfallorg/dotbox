{
  description = "DotBox support for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=v3.0.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "snowfallorg";
      };
    };
  in
    lib.mkFlake {
      alias = {
        packages.default = "dotbox";
        shells.default = "dotbox";
      };

      outputs-builder = channels: {
        apps = rec {
          default = dotbox;

          dotbox = lib.flake-utils-plus.mkApp {
            exePath = "/bin/dotbox";
            drv = inputs.self.packages.${channels.nixpkgs.system}.dotbox;
          };
        };
      };
    };
}
