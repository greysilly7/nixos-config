_: {
  den.aspects.cli._.tools._.cli-tools = _: {
      nixos =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            pkgs.parted
            pkgs.file
            pkgs.tree
            pkgs.which
            pkgs.wget2
            pkgs.curl
            pkgs.gnused
            pkgs.gawk
            pkgs.jq
            pkgs.nil
            pkgs.nixd
          ];
        };
      homeManager =
        { pkgs, lib, ... }:
        lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          home.packages = [ pkgs.sd ];
        };
  };
}
