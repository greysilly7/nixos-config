{
  den,
  lib,
  ...
}:
{
  den.aspects.dev = {
    includes = lib.attrValues den.aspects.dev._;
  };
}
