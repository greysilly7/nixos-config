_: {
  den.aspects.media._.nzbdav = {
    nixos = _: {
      virtualisation.oci-containers.containers.nzbdav = {
        image = "nzbdav/nzbdav:latest";
        extraOptions = [ "--network=host" ];
        environment = {
          PUID = "993";
          PGID = "993";
          NZBDAV_PORT = "3002";
        };
        volumes = [
          "/var/lib/nzbdav:/config"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/nzbdav 0755 media media -"
      ];
    };
  };
}
