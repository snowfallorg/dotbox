{
  description = "My Nix packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs";

    snowfall = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall.mkLib {
        inherit inputs;

        src = ./.;
      };
    in
    lib.mkFlake {
      overlay-package-namespace = "snowfallorg";

      outputs-builder = channels: rec {
        apps.default = apps.dotbox;
        apps.dotbox = lib.flake-utils-plus.mkApp {
          exePath = "/bin/dotbox";
          drv = channels.nixpkgs.snowfallorg.dotbox;
        };

        packages.default = "dotbox";
        devShells.default = "dotbox";
      };
    };
}
