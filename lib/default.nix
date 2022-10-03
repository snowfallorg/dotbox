{ lib, inputs, ... }:

{
  # Construct a DotBox importer.
  # Type: Attrs -> Attrs
  # Usage: mkImporter pkgs
  #   result: { import = file: { /* ... */ }; }
  mkImporter = pkgs:
    let
      inherit (pkgs) system runCommand;
      self = builtins.getFlake (builtins.toString ../.);
      dotbox = "${self.packages.${system}.dotbox}/bin/dotbox";
    in
    {
      import = file:
        let
          json =
            runCommand "output.json" { } ''
              ${dotbox} compile ${file} --output $out
            '';
        in
        lib.importJSON "${json}";
    };
}
