_: {
  den.aspects.media._.nzbhydra2 = {
    nixos = _: {
      services.nzbhydra2 = {
        enable = true;
        openFirewall = false;
      };

      systemd.services.nzbhydra2.serviceConfig = {
        User = "media";
        Group = "media";
      };
    };
  };
}
