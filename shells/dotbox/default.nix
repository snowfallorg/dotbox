{ mkShell, snowfallorg, ... }:

mkShell {
  nativeBuildInputs = [ snowfallorg.dotbox ];
}
