{
  den,
  lib,
  ...
}:
{
  den.aspects.system = {
    includes = lib.attrValues den.aspects.system._;
  };
}
