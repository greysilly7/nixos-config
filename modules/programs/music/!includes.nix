{
  den,
  lib,
  ...
}:
{
  den.aspects.music = {
    includes = lib.attrValues den.aspects.music._;
  };
}
