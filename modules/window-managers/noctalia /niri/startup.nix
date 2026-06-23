_: {
  den.aspects.noctalia._.niri._.startup = _: {
    niri =
      {
        lib,
        config,
        ...
      }:
      {
        settings.spawn-at-startup = [
          { command = [ "${lib.getExe config.programs.noctalia-shell.package}" ]; }
        ];
      };
  };
}
