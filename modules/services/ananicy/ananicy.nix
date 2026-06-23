{ den, ... }:
{
  den.aspects.ananicy = {
    includes = [
      den.aspects.ananicy._.enable
    ];

    _.enable = _: {
      nixos =
        {
          pkgs,
          lib,
          ...
        }:
        {
          services.ananicy = {
            enable = lib.mkDefault true;
            package = lib.mkDefault pkgs.ananicy-cpp;
          };
        };
    };
  };
}
