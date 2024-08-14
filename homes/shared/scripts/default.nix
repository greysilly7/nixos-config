{pkgs, ...}: let
  compress = pkgs.writeScriptBin "compress" (builtins.readFile ./scripts/compress.sh);
  extract = pkgs.writeScriptBin "extract" (builtins.readFile ./scripts/extract.sh);
  fs-diff = pkgs.writeScriptBin "fs-diff" (builtins.readFile ./scripts/fs-diff.sh);

in {
  home.packages = with pkgs; [
    compress
    extract

    fs-diff
  ];
}
