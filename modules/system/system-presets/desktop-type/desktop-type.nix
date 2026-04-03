# Preset desktop types.
# These should be imported by BOTH hosts and users wanting to use them.
{ den, ... }:
{
  den.aspects.desktop-type = {
    _.desktop-environment = { }; # None defined yet

    _.window-manager = {
      _.niri = {
        includes = [
          (den.lib.perHost {
            nixos =
              { lib, ... }:
              {
                # Set the default login session to Niri
                services.displayManager.defaultSession = lib.mkDefault "niri";
              };
          })
          # ---Core Aspects--- #
          den.aspects.niri
          den.aspects.noctalia
          den.aspects.stylix # Theming
        ];
      };
    };
  };
}
