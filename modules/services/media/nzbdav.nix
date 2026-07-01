_: {
  den.aspects.media._.nzbdav = {
    nixos = _: {
      virtualisation.oci-containers.containers.nzbdav = {
        image = "ghcr.io/qooode/nzbdavex";
        ports = [ "3002:3000" ];
        environment = {
          PUID = "993";
          PGID = "993";
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
