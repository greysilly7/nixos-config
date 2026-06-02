{
  den,
  lib,
  ...
}:
{
  den.aspects.noctalia._.class =
    {
      user,
      aspect-chain ? [ ],
      ...
    }:
    den._.forward {
      each = lib.singleton user;
      fromClass = _: "noctalia";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "noctalia-shell"
      ];
      fromAspect = _: if aspect-chain != [ ] then lib.head aspect-chain else "";
      adaptArgs = lib.id;
      guard = { options, ... }: options.programs ? noctalia-shell;
    };
}
