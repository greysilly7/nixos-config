_: {
  den.aspects.media._.seerr = {
    nixos =
      { pkgs, ... }:
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
            DynamicUser = false;
            ExecStartPre = [
              "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/seerr"
              "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/seerr"
            ];
          };
        };
      };
  };
}
