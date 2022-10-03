{ lib, pkgs, nodejs ? pkgs.nodejs-16_x, ... }:

let
  node-packages = import ./create-node-packages.nix {
    inherit pkgs nodejs;
    system = pkgs.system;
  };
  dotbox-cli =
    node-packages."@dotbox/cli".override {
      dontNpmInstall = true;
    };
in
dotbox-cli.overrideAttrs (oldAttrs: {
  postInstall = oldAttrs.postInstall or "" + ''
    mkdir $out/bin

    chmod +x $out/lib/node_modules/@dotbox/cli/bin/dotbox.js

    ln -s $out/lib/node_modules/@dotbox/cli/bin/dotbox.js $out/bin/dotbox
  '';
})
