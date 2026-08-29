_: {
  den.aspects.media._.navidrome = {
    nixos = _: {
      # Navidrome (Music Streaming)
      services.navidrome = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
        settings = {
          Address = "0.0.0.0";
          MusicFolder = "/mnt/pool/arr/media/music";
        };
      };
    };
  };
}
