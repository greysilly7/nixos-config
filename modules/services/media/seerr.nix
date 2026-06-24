_: {
  den.aspects.media._.seerr = {
    nixos = _: {
      # Seerr (Media Requests)
      services.seerr = {
        enable = true;
        openFirewall = false;
      };
    };
  };
}
