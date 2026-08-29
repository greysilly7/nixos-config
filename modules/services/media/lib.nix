{ pkgs, lib }:
dir:
lib.mkAfter [
  "+${pkgs.coreutils}/bin/chown -R media:media ${dir}"
  "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX ${dir}"
]
