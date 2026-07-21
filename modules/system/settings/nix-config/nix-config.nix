{ den, ... }:
{
  # `core-config` is used by all hosts by default
  den.schema.host.includes = [ den.aspects.nix-config._.core-config ];

  den.aspects.nix-config = {
    # Bundles all non-default components when the complete 'nix-config' aspect is used
    includes = [
      den.aspects.nix-config._.garbage-collection
      den.aspects.nix-config._.locale
    ];

    _.core-config = _:
      let
        baseNixSettings = {
          experimental-features = [ "nix-command" "flakes" ];
        };
        allowUnfree = true;
      in
      {
        nixos =
          { lib, ... }:
          {
            nix.settings = baseNixSettings // { trusted-users = [ "@wheel" ]; };
            nixpkgs.config.allowUnfree = allowUnfree;
            system.stateVersion = lib.mkDefault "25.11";
            security.sudo.extraConfig = ''
              Defaults lecture = "never"
            '';
            users.mutableUsers = lib.mkDefault false;
          };
        darwin =
          { lib, ... }:
          {
            nix.settings = baseNixSettings // { trusted-users = [ "@admin" ]; };
            nixpkgs.config.allowUnfree = allowUnfree;
          };
      };

    _.garbage-collection = _: {
      nixos =
        { lib, ... }:
        {
          nix.gc = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault "weekly";
            options = lib.mkDefault "--delete-older-than 30d";
          };
          # Hard link identical files to save space
          nix.optimise.automatic = lib.mkDefault true;
        };
      darwin =
        { lib, ... }:
        {
          nix.gc = {
            automatic = lib.mkDefault true;
            interval = lib.mkDefault {
              Hour = 3;
              Minute = 0;
            };
            options = lib.mkDefault "--delete-older-than 7d";
          };
          nix.optimise.automatic = lib.mkDefault true;

          nix.settings = {
            min-free = lib.mkDefault 5000000000;
            max-free = lib.mkDefault 10000000000;
            auto-optimise-store = lib.mkDefault true;
            warn-dirty = lib.mkDefault false;
          };
        };
    };

    _.locale = _: {
      nixos =
        { lib, ... }:
        {
          time.timeZone = lib.mkDefault "America/Detroit";
          i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
          console.keyMap = lib.mkDefault "us";
        };
    };
  };
}
