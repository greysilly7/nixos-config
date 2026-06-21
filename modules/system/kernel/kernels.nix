{
  den,
  ...
}:
{
  # Include regular kernel by default in all hosts
  den.schema.host.includes = [ den.aspects.kernel._.default ];

  den.aspects.kernel = {
    includes = [ den.aspects.kernel._.default ];

    # Regular NixOS kernel
    _.default = _: {
      nixos =
        {
          pkgs,
          lib,
          ...
        }:
        {
          boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        };
    };
  };
}
