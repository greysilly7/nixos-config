{
  den,
  lib,
  ...
}:
{
  den.aspects.noctalia._.class = den.lib.perUser (
    {
      user,
    }:
    {
      aspect-chain,
    }:
    den._.forward {
      each = lib.singleton user;
      fromClass = _: "noctalia";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "noctalia-shell"
      ];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = lib.id;
      guard = { options, ... }: options.programs ? noctalia-shell;
    }
  );
}
