# ponytail: simple aspect to enable sketchybar on darwin hosts
_: {
  den.aspects.sketchybar = {
    darwin = _: {
      services.sketchybar.enable = true;
    };
    homeManager = _: {
      home.file.".config/sketchybar" = {
        source = ./sketchybar;
        recursive = true;
      };
    };
  };
}
