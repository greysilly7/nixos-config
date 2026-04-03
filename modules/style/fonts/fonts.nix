{ den, ... }:
{
  den.aspects.fonts = {
    includes = [
      den.aspects.fonts._.regular
      den.aspects.fonts._.nerd
    ];

    _.config = den.lib.perHost {
      nixos =
        { lib, ... }:
        {
          fonts.fontconfig.enable = lib.mkDefault true;
        };
      persistUserIgnore =
        { hmConfig, ... }:
        {
          directories = [ "${hmConfig.xdg.cacheHome}/fontconfig" ];
        };
    };

    _.regular = den.lib.perHost {
      includes = [ den.aspects.fonts._.config ];
      nixos =
        { pkgs, ... }:
        {
          # Regular fonts
          fonts.packages = [
            pkgs.fira
            pkgs.jetbrains-mono
            pkgs.adwaita-fonts
            pkgs.googlesans-code
          ];
        };
    };

    _.nerd = den.lib.perHost {
      includes = [ den.aspects.fonts._.config ];
      nixos =
        { pkgs, ... }:
        {
          # Nerd-fonts
          fonts.packages = [
            pkgs.nerd-fonts.symbols-only
            pkgs.nerd-fonts.fira-mono
            pkgs.nerd-fonts.fira-code
            pkgs.nerd-fonts.adwaita-mono
            pkgs.nerd-fonts.jetbrains-mono
          ];
        };
    };
  };
}
