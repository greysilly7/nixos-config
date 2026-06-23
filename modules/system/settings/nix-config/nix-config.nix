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

    # Required core config for all hosts
    _.core-config = _: {
      nixos =
        { lib, ... }:
        {
          nix.settings = {
            # Enable flakes
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            # Add `wheel` to trusted users
            trusted-users = [ "@wheel" ];
          };

          system.stateVersion = lib.mkDefault "25.11";
          nixpkgs.config.allowUnfree = lib.mkDefault true;
          # Silence the first time sudo warning
          security.sudo.extraConfig = ''
            Defaults lecture = "never"
          '';
          users.mutableUsers = lib.mkDefault false;
        };
      darwin =
        { lib, ... }:
        {
          nix.settings = {
            # Enable flakes
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            # Add `admin` to trusted users
            trusted-users = [ "@admin" ];
          };

          nixpkgs.config.allowUnfree = lib.mkDefault true;
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
              Weekday = 0;
              Hour = 0;
              Minute = 0;
            };
            options = lib.mkDefault "--delete-older-than 30d";
          };
          # Hard link identical files to save space
          nix.optimise.automatic = lib.mkDefault true;
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
