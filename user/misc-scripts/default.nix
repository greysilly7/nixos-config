{pkgs, ...}: {
  compress = pkgs.writeShellScriptBin "compress" (builtins.readFile ./scripts/compress.sh);
  extract = pkgs.writeShellScriptBin "extract" (builtins.readFile ./scripts/extract.sh);
  fs-diff = pkgs.writeShellScriptBin "fs-diff" (builtins.readFile ./scripts/fs-diff.sh);
  brightness = pkgs.writeShellScriptBin "brightness" (builtins.readFile ./scripts/brightness.sh);
}
