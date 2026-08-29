_: {
  den.aspects.media._.seerr = {
    nixos =
      { pkgs, lib, ... }:
      let
        fixOwnership = import ./lib.nix { inherit pkgs lib; };
      in
      {
        # Seerr (Media Requests)
        services.seerr = {
          enable = true;
          openFirewall = false;
        };

        systemd.services.seerr = {
          serviceConfig = {
            User = "media";
            Group = "media";
            # services.seerr has no user/group option upstream and defaults to
            # DynamicUser; disable it so the unit can run as the shared media user.
            DynamicUser = lib.mkForce false;
            ExecStartPre = fixOwnership "/var/lib/seerr";
          };
        };
      };
  };
}
